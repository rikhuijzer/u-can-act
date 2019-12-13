# frozen_string_literal: true

pr_name = 'general-solo-protocol'
general_solo_protocol = Protocol.find_by_name(pr_name)
general_solo_protocol ||= Protocol.new(name: pr_name)
general_solo_protocol.duration = 1.day
general_solo_protocol.invitation_text = 'Je bent uitgenodigd door je coach om een vragenlijst in te vullen.'

bp_name = 'base-platform-subscription'
bp_push_subscription = general_solo_protocol.push_subscriptions.find_by(name: bp_name)
bp_push_subscription ||= general_solo_protocol.push_subscriptions.build(name: bp_name)
bp_push_subscription.method = 'POST'
bp_push_subscription.url = ENV['PUSH_SUBSCRIPTION_URL']
bp_push_subscription.save!

general_solo_protocol.save!

# Add questionnaires
questionnaires = [
  'ostrc',
  'rpe',
  'rtt',
  'training_satisfaction',
  'wellness'
]
questionnaires.each_with_index do |questionnaire_name, idx|
  last_questionnaire = (idx == questionnaires.length - 1)
  questionnaire_id = Questionnaire.find_by_name(questionnaire_name)&.id
  raise "Cannot find questionnaire: #{questionnaire_name}" unless questionnaire_id

  demo_measurement = general_solo_protocol.measurements.find_by_questionnaire_id(questionnaire_id)
  demo_measurement ||= general_solo_protocol.measurements.build(questionnaire_id: questionnaire_id)
  demo_measurement.open_from_offset = 0 # open right away
  demo_measurement.period = nil # one-off and not repeated
  demo_measurement.open_duration = nil # always open
  demo_measurement.reward_points = 0
  demo_measurement.stop_measurement = last_questionnaire # unsubscribe immediately if it is the last questionnaire
  demo_measurement.should_invite = true # send e-mail invitations
  demo_measurement.redirect_url = ENV['BASE_PLATFORM_URL'] if last_questionnaire
  demo_measurement.save!
end
