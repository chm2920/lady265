class StartController < ApplicationController
  
  before_filter :find_categories, :get_side_topics
  
  def index
    @cur = "index"
    @slide_topics = Topic.find(:all, :conditions => "cover_file_name <> ''", :order => "created_at desc", :limit => 5)
    @new_topics = Topic.find(:all, :order => "created_at desc", :limit => 15)
  end
  
  def category
    @cur = params[:id]
    @category = Category.find_by_alias(params[:id])
    @pic_topics = Topic.find(:all, :conditions => "category_id = #{@category.id} and cover_file_name <> ''", :order => "created_at desc", :limit => 5)
    @topics = Topic.paginate :page => params[:page], :per_page => 60, :conditions => "category_id = #{@category.id}", :order => "created_at desc"
    @side_pic_topics = Topic.find(:all, :conditions => "category_id = #{@category.id} and cover_file_name <> ''", :order => "hits desc, created_at desc", :limit => 2)
    @side_topics = Topic.find(:all, :conditions => "category_id = #{@category.id}", :order => "hits desc, created_at desc", :limit => 10)
    @page_title = @category.name
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
    @re_pic_topics = Topic.find(:all, :conditions => "cover_file_name <> ''", :order => "hits desc, created_at desc", :limit => 4)
    @re_topics = Topic.find(:all, :order => "hits desc, created_at desc", :limit => 20)
    @side_pic_topics = Topic.find(:all, :conditions => "category_id = #{@category.id} and cover_file_name <> ''", :order => "hits desc, created_at desc", :limit => 2)
    @side_topics = Topic.find(:all, :conditions => "category_id = #{@category.id}", :order => "hits desc, created_at desc", :limit => 10)
    @page_title = @topic.title
  end
  
private

  def find_categories
    @categories = Category.all
  end
  
  def get_side_topics    
    @s5_topics = Topic.find(:all, :conditions => "category_id = 5", :order => "created_at desc", :limit => 10)
    @s6_topics = Topic.find(:all, :conditions => "category_id = 6", :order => "created_at desc", :limit => 10)
    @s7_topics = Topic.find(:all, :conditions => "category_id = 7", :order => "created_at desc", :limit => 10)
  end
  
end
