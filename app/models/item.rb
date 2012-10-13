class Item < ActiveRecord::Base
  validates :description, :length => { maximum: 75 }, :presence => true, :allow_blank => false

  belongs_to :user
end
