module Api
  module V1
    class MetricsController < ApiController
      def create
        # TODO: Find out how to get the branches without an user
        return head :bad_request unless complete_metric_params?
        BranchMetricUpdater.perform_async(User.first.id, project.id, metric_params)
        head :accepted
      end

      private

      def complete_metric_params?
        %w(branch_name name value).all? { |param| metric_params[param].present? }
      end

      def metric_params
        params.fetch(:metric, {}).permit(:branch_name, :name, :value, :url)
      end
    end
  end
end
