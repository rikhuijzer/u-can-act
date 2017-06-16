# frozen_string_literal: true

class Response < ApplicationRecord
  RECENT_PAST = 2.hours
  REMINDER_DELAY = 8.hours
  NOT_SENT_STATE = 'not_sent'
  SENDING_STATE = 'sending'
  SENT_STATE = 'sent'
  SENDING_REMINDER_STATE = 'sending_reminder'
  REMINDER_SENT_STATE = 'reminder_sent'
  belongs_to :protocol_subscription
  validates :protocol_subscription_id, presence: true
  belongs_to :measurement
  validates :measurement_id, presence: true
  validates :open_from, presence: true
  validates :invited_state, inclusion: { in: [NOT_SENT_STATE,
                                              SENDING_STATE,
                                              SENT_STATE,
                                              SENDING_REMINDER_STATE,
                                              REMINDER_SENT_STATE] }
  has_one :invitation_token, dependent: :destroy # has one or none

  scope :recently_opened_and_not_sent, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invited_state = :not_sent',
      time_now: Time.zone.now,
      recent_past: RECENT_PAST.ago.in_time_zone,
      not_sent: NOT_SENT_STATE
    )
  })
  scope :still_open_and_not_completed, (lambda {
    where(
      'open_from <= :time_now AND open_from > :recent_past AND invited_state = :sent and completed_at IS NULL',
      time_now: Time.zone.now - REMINDER_DELAY,
      recent_past: (RECENT_PAST + REMINDER_DELAY).ago.in_time_zone,
      sent: SENT_STATE
    )
  })
  scope :completed, (-> { where.not(completed_at: nil) })
  scope :invite_sent, (-> { where(invited_state: SENT_STATE) })
  scope :invited, (-> { where('invited_state <> :state', state: NOT_SENT_STATE) })

  # De expired check hiervoor staat in de view:
  scope :open, (lambda {
    where('open_from <= :time_now AND completed_at IS NULL', time_now: Time.zone.now)
  })

  def remote_content
    ResponseContent.find(content) if content.present?
  end

  def initialize_invitation_token!
    # If a token exists for this response, reuse that token (so the old SMS invite link still works
    # when sending a reminder). But still recreate the invitation_token object, so we know that the
    # created_at is always when the object was last used. Also, if we don't first destroy the
    # invitation_token, then it will set a different token than what we're giving (since tokens have
    # to be unique).
    token = invitation_token&.token
    invitation_token&.destroy
    create_invitation_token!(token: token)
  end

  def values
    remote_content&.content
  end

  def expired?
    response_expired? || protocol_subscription.ended?
  end

  private

  def response_expired?
    measurement.open_duration.present? &&
      Time.zone.now > TimeTools.increase_by_duration(open_from, measurement.open_duration)
  end
end
