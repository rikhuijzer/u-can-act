# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Knock::Authenticable

      private 

      def unauthorized_entity(entity_name)
        render json: { error: "#{entity_name} Unauthorized request" }, status: :unauthorized
      end

      def check_access_allowed(protocol_subscription)
        current_user_has_access = protocol_subscription.person == current_user
        current_mentor_has_access = protocol_subscription.person.mentor == current_user
        current_mentor_has_access || current_user_has_access
      end
    end
  end
end
