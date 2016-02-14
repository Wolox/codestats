class Organization < ActiveRecord::Base
  validates :name, presence: true
  has_many :projects, dependent: :destroy
end
