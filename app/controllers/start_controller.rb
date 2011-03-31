class StartController < ApplicationController
  
  before_filter :find_categories
  
  def index
    @cur = "index"
    @slide_topics = Topic.find(:all, :order => "created_at desc", :limit => 5)
    @new_topics = Topic.find(:all, :order => "created_at desc", :limit => 15)
    @s1_topics = Topic.find(:all, :conditions => "category_id = 1", :order => "created_at desc", :limit => 18)
    @s2_topics = Topic.find(:all, :conditions => "category_id = 2", :order => "created_at desc", :limit => 18)
    @s3_topics = Topic.find(:all, :conditions => "category_id = 3", :order => "created_at desc", :limit => 18)
    @s4_topics = Topic.find(:all, :conditions => "category_id = 4", :order => "created_at desc", :limit => 18)
    @s5_topics = Topic.find(:all, :conditions => "category_id = 5", :order => "created_at desc", :limit => 10)
    @s6_topics = Topic.find(:all, :conditions => "category_id = 6", :order => "created_at desc", :limit => 10)
    @s7_topics = Topic.find(:all, :conditions => "category_id = 7", :order => "created_at desc", :limit => 10)
  end
  
  def category
    @cur = params[:id]
    @category = Category.find_by_alias(params[:id])
  end
  
  def topic
    @cur = params[:c]
    @category = Category.find_by_alias(params[:c])
    #@topic = Topic.find(params[:id])
  end
  
private

  def find_categories
    @categories = Category.all
  end
  
end
