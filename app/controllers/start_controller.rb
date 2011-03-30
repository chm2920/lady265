class StartController < ApplicationController
  
  before_filter :find_categories
  
  def index
    @cur = "index"
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
