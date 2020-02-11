# frozen_string_literal: true

module Api
  module V1
    module JwtApi
      class QuestionnaireController < JwtApiController
        before_action :check_admin_authenticated, only: %i[create]
        before_action :set_questionnaire, only: %i[show]

        def show
          # TODO: Add different formats
          render json: @questionnaire, serializer: Api::QuestionnaireSerializer
        end

        def create
          fqparams = questionnaire_params.to_hash.with_indifferent_access
          fqparams[:content] = full_content(fqparams[:content]) if fqparams.key?(:content)
          questionnaire = Questionnaire.new(fqparams)
          if questionnaire.save
            head 201
          else
            result = { result: questionnaire.errors }
            render(status: :bad_request, json: result)
          end
        end

        private

        def full_content(content)
          full_content = content.deep_dup
          full_content[:scores] = [] unless full_content.key?(:scores)
          full_content[:questions] = [] unless full_content.key?(:questions)
          full_content
        end

        def check_admin_authenticated
          return if current_auth_user.access_level == AuthUser::ADMIN_ACCESS_LEVEL

          result = { result: 'User is not an admin' }

          render(status: :forbidden, json: result)
        end

        def set_questionnaire
          @questionnaire = Questionnaire.find_by(key: params[:key])
          return if @questionnaire.present?

          render(status: :not_found, json: 'Vragenlijst met die key niet gevonden')
        end

        def questionnaire_params
          load_params = params.require(:questionnaire).permit(:name, :key, :title)

          # Whitelist the hash
          # see https://github.com/rails/rails/issues/9454
          load_params[:content] = params[:questionnaire][:content] if params[:questionnaire][:content]
          load_params.permit!
        end
      end
    end
  end
end
