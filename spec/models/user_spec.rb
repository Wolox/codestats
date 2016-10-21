require 'rails_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  subject(:user) { User.new(email: email, password: password) }

  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(8) }

  it { is_expected.to be_valid }

  describe '#organizations' do
    context 'When the user has organizations' do
      let!(:team) { create(:team, users: [user]) }
      it 'returns the organizations collection' do
        expect(user.organizations).to eq [team.organization]
      end
    end
    context 'When the user doesn\'t have organizations' do
      it 'returns an emtpy array' do
        expect(user.organizations).to eq []
      end
    end
  end
end
