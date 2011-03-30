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
    
  end
  
private

  def find_categories
    @categories = Category.all
  end
  
end
