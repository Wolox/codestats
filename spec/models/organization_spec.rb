require 'rails_helper'

describe Organization do
  it { should validate_presence_of(:name) }
end
