class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :number, :null => false
      t.text :description, :null => false, :default => ""
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
