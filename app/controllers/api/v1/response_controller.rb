# frozen_string_literal: true

module Api
  module V1
    class ResponseController < ApiController
      include ::Concerns::IsBasicAuthenticated
      before_action :set_response, only: %i[show create]
      before_action :set_responses, only: %i[index]
      before_action :check_empty_response, only: %i[create]

      def show
        render json: @response, serializer: Api::PersonalizedQuestionnaireSerializer
      end

      def index
        render json: @responses, each_serializer: Api::ResponseSerializer
      end

      def create
        content = ResponseContent.create!(content: response_content)
        @response.update_attributes!(content: content.id)
        @response.complete!
        head 201
      end

      private

      def set_responses
        # TODO: This will be replaced with current user once we have correct authentication
        person = Person.find_by_external_identifier(response_params[:external_identifier])
        (@responses = person.my_open_responses) && return if person.present?
        render(status: 404, json: 'Persoon met die external_identifier niet gevonden')
      end

      def set_response
        @response = Response.find_by_uuid(response_params[:uuid])
        return if @response.present?
        render(status: 404, json: 'Response met dat uuid niet gevonden')
      end

      def check_empty_response
        return if @response.content.blank?
        render(status: 400, json: 'Response met dat uuid heeft al content')
      end

      def response_content
        return {} if response_params[:content].nil?
        response_params[:content].to_unsafe_h
      end

      def response_params
        # TODO: change the below line to the following in rails 5.1:
        # params.permit(:response_id, content: {})
        params.permit(:external_identifier, :uuid, content: permit_recursive_params(params[:content]&.to_unsafe_h))
      end
    end
  end
end