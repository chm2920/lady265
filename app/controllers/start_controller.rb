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
    @topics_list = []
    @topics_list << @s1_topics
    @topics_list << @s2_topics
    @topics_list << @s3_topics
    @topics_list << @s4_topics
    
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
    @topic = Topic.find(params[:id])
    @contents = @topic.content.split("<hr><hr>")
    @page_count = @contents.length
    if params[:page].nil? || params[:page].to_i > @contents.length
      @page = 1
      @content = @contents[0]
    else
      @page = params[:page].to_i
      @content = @contents[@page-1]
    end
    @page_title = @topic.title
  end
  
private

  def find_categories
    @categories = Category.all
  end
  
end
