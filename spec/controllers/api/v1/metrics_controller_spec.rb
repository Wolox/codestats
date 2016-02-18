require 'rails_helper'

describe Api::V1::MetricsController do
  describe 'POST #create' do
    context 'When creating a metric with an empty Authorization header' do
      it 'returns unauthorized status' do
        post :create
        expect(response.status).to eq 401
      end
    end

    context 'When creating a metric with an invalid Authorization header' do
      before(:each) do
        request.headers['Authorization'] = Faker::Number.number(8)
      end

      it 'returns unauthorized status' do
        post :create
        expect(response.status).to eq 401
      end
    end

    context 'When creating a metric with missing parameters' do
      let(:project) { create(:project) }

      before(:each) do
        request.headers['Authorization'] = project.metrics_token
      end

      it 'returns bad request status' do
        post :create
        expect(response.status).to eq 400
      end
    end

    context 'When creating a metric valid parameters' do
      let!(:user)    { create(:user) }
      let!(:project) { create(:project) }
      let!(:team) do
        create(
          :team,
          organization: project.organization,
          admin: true,
          projects: [project],
          users: [user]
        )
      end
      let(:metric_params) do
        { branch_name: Faker::Name.name, name: Faker::Name.name, value: Faker::Number.number(8) }
      end

      before(:each) do
        request.headers['Authorization'] = project.metrics_token
      end

      it 'returns bad request status' do
        post :create, metric: metric_params
        expect(response.status).to eq 202
      end

      it 'enqueues a BranchMetricUpdater job' do
        expect do
          post :create, metric: metric_params
        end.to change(BranchMetricUpdater.jobs, :size).by(1)
      end
    end
  end
end
