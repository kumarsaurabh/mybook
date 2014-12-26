class Post < ActiveRecord::Base
  belongs_to :product
  belongs_to :author
end
