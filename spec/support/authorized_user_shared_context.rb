RSpec.shared_context 'Authorized User Shared Context' do
  let!(:user)        { create(:user) }

  before(:each) do
    sign_in(user)
  end

  after(:each) do
    sign_out user
  end
end
