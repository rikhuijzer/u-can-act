# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :people, dependent: :destroy
  has_many :roles, dependent: :destroy

  DEFAULT_PERCENTAGE = 70

  def self.overview(week_number = nil, year = nil, threshold_percentage = nil)
    Organization.all.map do |organization|
      organization_stats = organization.stats(week_number, year, threshold_percentage)
      { name: organization.name, data: organization_stats }
    end
  end

  def stats(week_number, year, threshold_percentage)
    all_role_stats = Hash.new({})
    roles.each do |role|
      role_stats = stats_for_role(role, week_number, year, threshold_percentage)

      # Note that we merge the stats based on the group of the role, not on the title.
      merged = all_role_stats[role.group].merge(role_stats) do |_key, val1, val2|
        val1 + val2
      end
      all_role_stats[role.group] = merged
    end
    calculate_above_threshold_percentage(all_role_stats)
  end

  private

  def calculate_above_threshold_percentage(role_stats)
    role_stats.each_key do |group|
      roles_for_group = roles.where(group: group)
      perc = calculate_above_threshold_for_group(roles_for_group, role_stats[group])
      role_stats[group][:percentage_above_threshold] = perc if perc.present?
    end
    role_stats
  end

  def calculate_above_threshold_for_group(roles_for_group, role_stats_for_group)
    total_people = roles_for_group.reduce(0) { |tot, val| tot + val.people.count }
    total_people.positive? ? role_stats_for_group[:met_threshold_completion].to_d / total_people.to_d * 100 : nil
  end
end
