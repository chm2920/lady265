# coding: utf-8 
class StartController < ApplicationController
  
  before_filter :find_categories
  
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
		case @category.id
			when 1
				@keywords = "明星服饰,女星装扮,明星搭配,明星婚纱,明星旗袍"
				@description = "明星装扮-服饰|服装|时装  明星服饰,女星装扮,明星搭配,明星婚纱,明星"
			when 2
				@keywords = "流行服饰,时尚服饰,休闲服饰,韩国服饰,日本服饰,OL服饰,时装,服装,春装,夏装,秋装,冬装"
				@description = "流行服饰-服饰|服装|时装  流行服饰,时尚服饰,休闲服饰,韩国服饰,日本服饰,OL服饰,时装,服装,春装,夏装,秋装,冬装"
			when 3
				@keywords = "服饰搭配,搭配技巧, 时尚搭配,穿衣技巧,混搭,街头混搭,混搭技巧,休闲混搭,问题身材"
				@description = "搭配学堂-服饰|服装|时装  服饰搭配,搭配技巧, 时尚搭配,穿衣技巧,混搭,街头混搭,混搭技巧,休闲混搭,问题身材"
			when 4
				@keywords = "街拍"
				@description = "街拍已经逐渐成为时尚人生活中的一部分.环球街拍不但能让你接收到第一手的潮流资讯，更能让你了解世界各地的着装风格与街头达人的高超搭配术，将最真实最地道的型人风格展现你眼前。"
			when 5
				@keywords = "配饰,配件,饰品,袜子,皮带,围巾,手套,眼镜,首饰,耳环,项链,戒指,胸针"
				@description = "配饰-饰品|配饰|配件  配饰,配件,饰品,袜子,皮带,围巾,手套,眼镜,首饰,耳环,项链,戒指,胸针"
			when 6
				@keywords = "韩国包包,日本包包,韩日包包,钱包,单肩包,休闲包,淑女包,运动包"
				@description = "包包-饰品|配饰|配件  韩国包包,日本包包,韩日包包,钱包,单肩包,休闲包,淑女包,运动包"
			when 7
				@keywords = "鞋帽,女鞋,太阳帽,高跟鞋,平跟鞋,运动鞋,休闲鞋,凉鞋,靴子,长筒靴,短筒靴,皮鞋,男鞋"
				@description = "鞋帽-饰品|配饰|配件  鞋帽,女鞋,太阳帽,高跟鞋,平跟鞋,运动鞋,休闲鞋,凉鞋,靴子,长筒靴,短筒靴,皮鞋,男鞋"
			else
				@keywords = nil
				@description = nil
		end
  end
  
  def topic
    @cur = params[:c]
    @category = Category.find_by_alias(params[:c])
    @topic = Topic.find(params[:id])
    @topic.hits = @topic.hits + 1
    @topic.save
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
		@keywords = @topic.title
		@description = @topic.summary
  end
  
private

  def find_categories
    @categories = Category.all
  end
  
end
