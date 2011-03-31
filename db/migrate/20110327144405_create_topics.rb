class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :category_id
      t.string :title
      t.text :content
      t.text :summary
      t.integer :hits, :null => false, :default => 0
      t.string :pub_from
      t.string :editor
      t.string :cover_file_name

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
