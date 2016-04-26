module Api
  module V1
    class MetricsController < ApiController
      def create
        return head :bad_request if !complete_metric_params? || !admin_user.present?
        BranchMetricUpdater.perform_async(admin_user.id, project.id, metric_params)
        head :accepted
      end

      private

      def admin_user
        @admin_user ||= project.organization.admin_team.users.first
      end

      def complete_metric_params?
        %w(branch_name name value).all? { |param| metric_params[param].present? }
      end

      def metric_params
        params.fetch(:metric, {}).permit(:branch_name, :name, :value, :url, :minimum)
      end
    end
  end
end
