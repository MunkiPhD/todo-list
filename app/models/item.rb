class Item < ActiveRecord::Base
  before_save :add_item_number

  validates :description, :length => { maximum: 75 }, :presence => true, :allow_blank => false

  belongs_to :user

  private

  # Instead of trying to constantly update the number so that the highest priority has the number 1
  # I'm going to make is to the highest priority has the highest number altogether (e.g. 124 instead of 1)
  def add_item_number
    max_num = Item.where("user_id = ?", self.user).maximum("number")
    max_num.nil? ? max_num = 1 : max_num += 1
  
    self.number = max_num
  end
end
