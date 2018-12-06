# frozen_string_literal: true

module Api
  module V1
    module StatisticsHelper
      def number_of_informed_consents_given(group)
        # If this method is used to count people then it is assumed that a person is asked
        # for informed consent in at most one of her protocols.
        role_ids = Role.where(group: group).pluck(:id)
        person_ids = Person.where(role: role_ids).pluck(:id)
        ProtocolSubscription
          .where('informed_consent_given_at IS NOT NULL')
          .where(person_id: person_ids)
          .group(:person_id).count.count
      end

      def number_of_completed_questionnaires(groups)
        role_ids = Role.where(group: groups).pluck(:id)
        person_ids = Person.where(role: role_ids).pluck(:id)
        Response.completed.where(filled_out_by_id: person_ids).count
      end
    end
  end
end