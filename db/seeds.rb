# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


Category.create(:name => "明星装扮", :alias => "star")
Category.create(:name => "流行服饰", :alias => "fashion")
Category.create(:name => "搭配学堂", :alias => "school")
Category.create(:name => "环球街拍", :alias => "streetsnap")
Category.create(:name => "配饰", :alias => "accessories")
Category.create(:name => "包包", :alias => "bags")
Category.create(:name => "鞋帽", :alias => "shoes")