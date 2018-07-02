# frozen_string_literal: true

class Measurement < ApplicationRecord
  belongs_to :questionnaire
  validates :questionnaire_id, presence: true
  belongs_to :protocol # , autosave: true, validate: true
  validate :at_most_one_stop_measurement_per_protocol
  validates :protocol_id, presence: true
  validates :stop_measurement, inclusion: { in: [true, false] }
  validates :should_invite, inclusion: { in: [true, false] }
  # period can be nil, in which case the questionnaire is one-off and not repeated
  validates :period, numericality: { only_integer: true, allow_nil: true, greater_than: 0 }
  # open_duration can be nil, in which case the questionnaire can be filled out until the end of the protocol
  validates :open_duration, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  # either open_from_offset or offset_till_end has to be specified
  validates :open_from_offset, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :offset_till_end, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 0 }
  validates :reward_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :either_open_from_or_offset_till_end

  has_many :responses, dependent: :destroy

  def periodical?
    period.present?
  end

  def response_times(start_date, end_date)
    unless periodical?
      return [open_till(end_date)] if offset_till_end.present?
      return [open_from(start_date)]
    end
    response_times = []
    temp_open_from = open_from(start_date)
    temp_open_till = open_till(end_date)
    while temp_open_from < temp_open_till
      response_times << temp_open_from
      temp_open_from = TimeTools.increase_by_duration(temp_open_from, period)
    end
    response_times
  end

  private

  def at_most_one_stop_measurement_per_protocol
    return unless stop_measurement
    protocol.reload
    return if protocol.stop_measurement.nil? || protocol.stop_measurement == self
    errors.add(:protocol, 'can only have a single stop_measurement')
  end

  def open_till(end_date)
    if offset_till_end.present?
      TimeTools.increase_by_duration(end_date, -offset_till_end)
    else
      end_date
    end
  end

  def open_from(start_date)
    if open_from_offset.present?
      TimeTools.increase_by_duration(start_date, open_from_offset)
    else
      start_date
    end
  end

  def either_open_from_or_offset_till_end
    if periodical?
      open_from_offset_cannot_be_blank
    else
      offsets_cannot_both_be_blank
      offsets_cannot_both_be_present
    end
  end

  def open_from_offset_cannot_be_blank
    return unless open_from_offset.blank?
    errors.add(:open_from_offset, 'cannot be blank')
  end

  def offsets_cannot_both_be_blank
    return unless open_from_offset.blank? && offset_till_end.blank?
    errors.add(:open_from_offset, 'cannot be blank if offset_till_end is blank')
    errors.add(:offset_till_end, 'cannot be blank if open_from_offset is blank')
  end

  def offsets_cannot_both_be_present
    return unless open_from_offset.present? && offset_till_end.present?
    errors.add(:open_from_offset, 'cannot be present if offset_till_end is present')
    errors.add(:offset_till_end, 'cannot be present if open_from_offset is present')
  end
end
