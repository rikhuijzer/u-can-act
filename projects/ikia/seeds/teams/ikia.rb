# frozen_string_literal: true

team_name = 'Schoolnaam'

organization_name = 'IKIA'
organization = Organization.find_by_name(organization_name)

puts "Running seeds for #{team_name}"
team = Team.find_by_name(team_name)
team ||= Team.create!(name: team_name, organization: organization)
team.update_attributes!(organization: organization)

title = 'Demo-solo'
entry = team.roles.where(group: Person::SOLO, title: title).first
entry ||= team.roles.create!(group: Person::SOLO, title: title)

# title = 'Demo-student'
# entry = team.roles.where(group: Person::STUDENT, title: title).first
# entry ||= team.roles.create!(group: Person::STUDENT, title: title)
#
# title = 'Demo-mentor'
# entry = team.roles.where(group: Person::MENTOR, title: title).first
# entry ||= team.roles.create!(group: Person::MENTOR, title: title)
