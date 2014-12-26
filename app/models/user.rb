class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable

  #relationships
  has_one :profile, dependent: :destroy

  #accepts
  accepts_nested_attributes_for :profile

  #validations
  validates_presence_of :profile
  validates_associated :profile
end
