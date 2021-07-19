# frozen_string_literal: true

team_name = 'Evaluatieonderzoek'
title = 'Evalueerder'

organization_name = 'Evaluatieonderzoek'
organization = Organization.find_by(name: organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by(name: team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update!(organization: organization)

entry = team.roles.where(group: Person::SOLO, title: title).first
entry ||= team.roles.create!(group: Person::SOLO, title: title)
