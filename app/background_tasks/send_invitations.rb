# frozen_string_literal: true

class SendInvitations
  class << self
    def run
      # Since we're modifying the object, find_each would probably not work.
      # find_each isn't needed, since the scope should always be sufficiently small.
      mentor_responses = {}
      Response.recently_opened_and_not_sent.each do |response|
        next if response.expired?
        next unless response.protocol_subscription.active?
        if response.protocol_subscription.for_myself?
          response.update_attributes!(invited_state: Response::SENDING_STATE)
          SendInvitationJob.perform_later response
        else
          response.update_attributes!(invited_state: Response::SENT_STATE)
          mentor_responses[response.protocol_subscription.person_id] = response
        end
      end
      queue_mentor_responses(mentor_responses)
      send_for_myself_reminders
    end

    def queue_mentor_responses(mentor_responses)
      # We collect the responses for the mentor before, and send them only a single text.
      mentor_responses.each_value do |response|
        response.update_attributes!(invited_state: Response::SENDING_STATE)
        SendInvitationJob.perform_later response
      end
    end

    def send_for_myself_reminders
      Response.still_open_and_not_completed.each do |response|
        next unless response.protocol_subscription.active? && response.protocol_subscription.for_myself?
        next if response.expired?
        response.update_attributes!(invited_state: Response::SENDING_REMINDER_STATE)
        SendInvitationJob.perform_later response
      end
    end
  end
end
