# frozen_string_literal: true

class ProtocolSubscription < ApplicationRecord
  include ActiveModel::Validations
  ACTIVE_STATE = 'active'
  CANCELED_STATE = 'canceled'
  COMPLETED_STATE = 'completed'
  belongs_to :person
  belongs_to :filling_out_for, class_name: 'Person', foreign_key: 'filling_out_for_id'
  validates :person_id, presence: true
  validates :filling_out_for_id, presence: true
  belongs_to :protocol
  validates :protocol_id, presence: true
  validates :state, inclusion: { in: [ACTIVE_STATE, CANCELED_STATE, COMPLETED_STATE] }
  validates :start_date, presence: true, start_of_day: true
  has_many :responses, -> { order open_from: :asc }, dependent: :destroy
  after_create :schedule_responses
  after_initialize :initialize_filling_out_for

  scope :active, (-> { where(state: ACTIVE_STATE) })

  def active?
    state == ACTIVE_STATE
  end

  def ended?
    Time.zone.now > TimeTools.increase_by_duration(start_date, protocol.duration)
  end

  def for_myself?
    person == filling_out_for
  end

  def reward_points
    responses.completed.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  def possible_reward_points
    responses.invite_sent.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  def max_reward_points
    responses.map { |response| response.measurement.reward_points }.reduce(0, :+)
  end

  private

  def initialize_filling_out_for
    self.filling_out_for ||= person
  end

  def schedule_responses
    prot_sub_end = TimeTools.increase_by_duration(start_date, protocol.duration)
    ActiveRecord::Base.transaction do
      protocol.measurements.each do |measurement|
        schedule_responses_for_measurement(measurement, prot_sub_end)
      end
    end
  end

  def schedule_responses_for_measurement(measurement, prot_sub_end)
    open_from = TimeTools.increase_by_duration(start_date, measurement.open_from_offset)
    while open_from < prot_sub_end
      Response.create!(protocol_subscription_id: id,
                       measurement_id: measurement.id,
                       open_from: open_from)
      break unless measurement.period
      open_from = TimeTools.increase_by_duration(open_from, measurement.period)
    end
  end
end
