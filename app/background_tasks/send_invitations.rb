# frozen_string_literal: true

class SendInvitations
  def self.run
    # Since we're modifying the object, find_each would probably not work.
    # find_each isn't needed, since the scope should always be sufficiently small.
    Response.check_for_send.each do |response|
      next unless response.protocol_subscription.active?
      next if response.expired?
      response.update_attributes!(invited_state: Response::SENDING_STATE)
      SendInvitationJob.perform_later response
    end
  end
end
