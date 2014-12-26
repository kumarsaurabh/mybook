class Profile < ActiveRecord::Base


  #settings
  enum gender: [ :unspecified, :male, :female ]

  #relationship with user(one user has one profile)
  belongs_to :user

  #validations
  validates :first_name, presence: true, length: { in: 1..30 }
  validates :last_name, presence: true, length: { in: 1..30 }
end
