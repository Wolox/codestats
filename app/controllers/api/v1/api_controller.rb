module Api
  module V1
    class ApiController < ActionController::Base
      protect_from_forgery with: :null_session
      before_action :authenticate

      private

      def project
        @project ||= Project.find_by_metrics_token(request.headers['Authorization'])
      end

      def authenticate
        head :unauthorized unless request.headers['Authorization'].present?
        head :unauthorized unless project.present?
      end
    end
  end
end
