class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :category_id
      t.integer :topic_id
      t.string :title
      t.string :url
      t.integer :is_get, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
