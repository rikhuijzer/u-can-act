# frozen_string_literal: true

require 'rails_helper'

describe 'GET /edit', type: :feature, js: true do
  let!(:person) { FactoryBot.create(:person, gender: 'female') }

  let(:protocol_with_rewards) { FactoryBot.create(:protocol, :with_rewards) }

  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription,
                      protocol: protocol_with_rewards,
                      person: person,
                      start_date: 1.week.ago.at_beginning_of_day)
  end

  let!(:responseobj) do
    FactoryBot.create(:response, :periodical, :invited,
                      protocol_subscription: protocol_subscription,
                      open_from: 1.hour.ago)
  end
  let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

  before :each do
    # Login
    visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
  end

  it 'should list the correct labels / fields' do
    visit edit_person_path
    expect(page).to have_content('Accountgegevens bewerken')
    expect(page).to have_content('Voornaam')
    expect(page).to have_content('Achternaam')
    expect(page).to have_content('Geslacht')
    expect(page).to have_content('Emailadres')
    expect(page).to have_content('Mobiele telefoonnummer')
    expect(page).to have_content('Bankrekeningnummer (IBAN)')
  end

  it 'should store data after clicking the update button' do
    visit edit_person_path
    expect(page).to have_content('Accountgegevens bewerken')
    page.fill_in('person_first_name', with: 'new_first')
    page.fill_in('person_last_name', with: 'new_last')
    page.fill_in('person_mobile_phone', with: '0698417312')
    page.fill_in('person_email', with: 'anew@email.com')
    page.fill_in('person_iban', with: 'NL13RTEF0518590011')

    page.choose('Man', allow_label_click: true)

    all('input[type="submit"][value="Opslaan"]').first.click
    visit edit_person_path

    expect(page).to have_selector("input[value='new_first']")
    expect(page).to have_selector("input[value='new_last']")
    expect(page).to have_selector("input[value='0698417312']")
    expect(page).to have_selector("input[value='anew@email.com']")
    expect(page).to have_selector("input[value='NL13RTEF0518590011']")
    expect(find("[name='person[gender]'][checked]").value).to eq 'male'
  end

  it 'should actually update the person object' do
    expect(person.first_name).to_not eq 'new_first'
    expect(person.last_name).to_not eq 'new_last'
    expect(person.mobile_phone).to_not eq '0698417312'
    expect(person.email).to_not eq 'anew@email.com'
    expect(person.iban).to_not eq('NL13RTEF0518590011')

    visit edit_person_path
    expect(page).to have_content('Accountgegevens bewerken')
    page.fill_in('person_first_name', with: 'new_first')
    page.fill_in('person_last_name', with: 'new_last')
    page.fill_in('person_mobile_phone', with: '0698417312')
    page.fill_in('person_email', with: 'anew@email.com')
    page.fill_in('person_iban', with: 'NL13RTEF0518590011')
    page.choose('Man', allow_label_click: true)
    all('input[type="submit"][value="Opslaan"]').first.click

    person.reload

    expect(person.first_name).to eq 'new_first'
    expect(person.last_name).to eq 'new_last'
    expect(person.mobile_phone).to eq '0698417312'
    expect(person.email).to eq 'anew@email.com'
    expect(person.iban).to eq('NL13RTEF0518590011')
  end
end

describe 'GET /unsubscribe', type: :feature, js: true do
  let!(:person) { FactoryBot.create(:mentor, gender: 'female') }

  let(:protocol) { FactoryBot.create(:protocol) }

  let(:protocol_subscription) do
    FactoryBot.create(:protocol_subscription,
                      :mentor,
                      protocol: protocol,
                      person: person,
                      start_date: 1.week.ago.at_beginning_of_day)
  end

  let!(:responseobj) do
    FactoryBot.create(:response, :periodical, :invited,
                      protocol_subscription: protocol_subscription,
                      open_from: 1.hour.ago)
  end
  let!(:invtoken) { FactoryBot.create(:invitation_token, invitation_set: responseobj.invitation_set) }

  before :each do
    # Login
    visit responseobj.invitation_set.invitation_url(invtoken.token_plain, false)
  end

  it 'should unsubscribe when you click the unsubscribe button' do
    expect(page).to have_content('Klaar met dit schooljaar?')
    expect(person.protocol_subscriptions.active.count).to eq 1
    page.click_on 'Onderzoek afronden'
    expect(person.protocol_subscriptions.active.count).to eq 0
    expect(page).to have_content('Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!')
  end

  it 'should redirect to a stop questionnaire if there is one and then unsubscribe when click unsubscribe button' do
    questionnaire = FactoryBot.create(:questionnaire, :minimal)
    measurement = FactoryBot.create(:measurement, :stop_measurement, protocol: protocol, questionnaire: questionnaire)
    FactoryBot.create(:response,
                      measurement: measurement,
                      protocol_subscription: protocol_subscription,
                      open_from: 4.hours.from_now)
    protocol2 = FactoryBot.create(:protocol)
    protocol_subscription2 = FactoryBot.create(:protocol_subscription,
                                               :mentor,
                                               protocol: protocol,
                                               person: person,
                                               start_date: 1.week.ago.at_beginning_of_day)
    measurement2 = FactoryBot.create(:measurement, :stop_measurement, protocol: protocol2, questionnaire: questionnaire)
    FactoryBot.create(:response,
                      measurement: measurement2,
                      protocol_subscription: protocol_subscription2,
                      open_from: 5.hours.from_now)
    expect(page).to have_content('Klaar met dit schooljaar?')
    expect(person.protocol_subscriptions.active.count).to eq 2
    page.click_on 'Onderzoek afronden'
    expect(person.protocol_subscriptions.active.count).to eq 2
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_content('Hoihoihoi')
    page.click_on 'Opslaan'
    expect(person.protocol_subscriptions.active.count).to eq 1
    expect(page).to have_content('vragenlijst-dagboekstudie-studenten')
    expect(page).to have_content('Hoihoihoi')
    page.click_on 'Opslaan'
    expect(person.protocol_subscriptions.active.count).to eq 0
    expect(page).to have_content('Je hebt je uitgeschreven voor het u-can-act onderzoek. Bedankt voor je inzet!')
  end
end