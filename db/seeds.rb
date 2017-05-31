# frozen_string_literal: true

# Running rake db:reset will leave seeds with a terminated connection.
ActiveRecord::Base.connection.reconnect! if Rails.env.development?

# Require personal question seeds separately because they
# need to already exist when the protocol seeds are loaded, and the
# order is different on production servers.
require File.join(File.dirname(__FILE__),'seeds','questionnaire_seeds.rb')
# Load seeds from the seeds directory.
Dir[File.join(File.dirname(__FILE__),'seeds','*.rb')].each do |file|
  require file
end

if Rails.env.development? || Rails.env.staging?
  protocol = Protocol.find_by_name('pilot - mentoren 1x per week')
  person = Mentor.first
  students = Student.all[0..-2]

  students.each do |student|
    prot_sub = ProtocolSubscription.create!(
      protocol: protocol,
      person: person,
      filling_out_for: student,
      state: ProtocolSubscription::ACTIVE_STATE,
      start_date: Time.zone.now.change(hour:0, minute:0, second:0)
    )
    responseobj = prot_sub.responses.first
    responseobj.update_attributes!(
      open_from: 4.weeks.from_now, # Doesn't expire for a month (or actually 3 weeks since that's the prot duration)
      invited_state: Response::SENT_STATE)
    responseobj.initialize_invitation_token!
    puts "#{Rails.application.routes.url_helpers.root_url}?q=#{responseobj.invitation_token.token}"
  end
end

puts 'Seeds loaded!'
