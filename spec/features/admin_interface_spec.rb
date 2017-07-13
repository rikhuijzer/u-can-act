# frozen_string_literal: true

require 'rails_helper'

describe 'GET /admin', type: :feature, js: true do
  before do
    @questionnaire_names = ['my_name',
                            'second_name',
                            'hey I have spaces dagboek 5x per week dinsdag, woensdag, vrijdag']
    @questionnaire_names.each do |questionnaire_name|
      FactoryGirl.create(:questionnaire, name: questionnaire_name)
    end
  end

  it 'should give a 404 error when not authorized' do
    visit '/admin'
    expect(page).to have_http_status(401)
  end

  it 'should be able to download questionnaires correctly' do
    basic_auth 'admin', 'admin'
    visit '/admin'
    expect(page).to have_http_status(200)

    # People
    expect(page).to have_content('People')
    expect(page).not_to have_css('a[disabled]')
    expect(page).to have_link('Download', href: '/admin/person_export.csv')
    page.all('a', text: 'Download')[0].click
    expect(page).to have_http_status(200)
    expect(page.response_headers['Content-Type']).to eq 'text/csv'
    expected_filename = "people_#{Time.zone.now.to_date}.csv"
    expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
    expect(page).to have_css('a[disabled]', count: 1)

    # ProtocolSubscriptions
    expect(page).to have_content('ProtocolSubscriptions')
    expect(page).to have_link('Download', href: '/admin/protocol_subscription_export.csv')
    page.all('a', text: 'Download')[1].click
    expect(page).to have_http_status(200)
    expect(page.response_headers['Content-Type']).to eq 'text/csv'
    expected_filename = "protocol_subscriptions_#{Time.zone.now.to_date}.csv"
    expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
    expect(page).to have_css('a[disabled]', count: 2)

    # Questionnaires
    expect(@questionnaire_names.size).to eq 3
    expect(page).to have_link('Definition', count: @questionnaire_names.size)
    expect(page).to have_link('Responses', count: @questionnaire_names.size)
    disabled_count = 2
    @questionnaire_names.each_with_index do |questionnaire_name, idx|
      expect(page).to have_content("Questionnaire: #{questionnaire_name}")

      # Definition
      expect(page).to have_link('Definition',
                                href: "/admin/questionnaire_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
      page.all('a', text: 'Definition')[idx].click
      expect(page).to have_http_status(200)
      expect(page.response_headers['Content-Type']).to eq 'text/csv'
      idified_name = "#{questionnaire_name.parameterize.underscore}_#{Time.zone.now.to_date}"
      expected_filename = "questionnaire_#{idified_name}.csv"
      expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
      disabled_count += 1
      expect(page).to have_css('a[disabled]', count: disabled_count)

      # Responses
      expect(page).to have_link('Responses',
                                href: "/admin/response_export/#{questionnaire_name.gsub(' ', '%20')}.csv")
      page.all('a', text: 'Responses')[idx].click
      expect(page).to have_http_status(200)
      expect(page.response_headers['Content-Type']).to eq 'text/csv'
      expected_filename = "responses_#{idified_name}.csv"
      expect(page.response_headers['Content-Disposition']).to match(/attachment; filename="#{expected_filename}"/)
      disabled_count += 1
      expect(page).to have_css('a[disabled]', count: disabled_count)
    end
  end
end