# frozen_string_literal: true

organization_name = 'UCF'
puts "Running seeds for organization #{organization_name}"
organization = Organization.find_by_name(organization_name)
organization ||= Organization.create!(name: organization_name)