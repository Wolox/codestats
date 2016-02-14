class Metric < ActiveRecord::Base
  belongs_to :branch
  validates :name, :value, :branch, presence: true
end
