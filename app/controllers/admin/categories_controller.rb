class Admin::CategoriesController < ApplicationController
  
  before_filter :set_cur_panel_active, :except => ["new"]
  
  def index
    if !params[:deal_ids].nil?
      Deal.destroy_all(["id in (?)", params[:deal_ids]])
    end
    if !params[:keyword].nil?
      @deals = Deal.paginate :conditions => ["title like ?", "%" + params[:keyword] + "%"], :page => params[:page], :per_page => 15, :order => "id desc"
    else
      @deals = Deal.paginate :page => params[:page], :per_page => 15, :order => "id desc"
    end
  end

  def new
    @deal = Deal.new
    set_panel_active("Deal", "deal_new")
  end

  def edit
    @deal = Deal.find(params[:id])
  end
  
  def create
    @deal = Deal.new(params[:deal])
    if @deal.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @deal = Deal.find(params[:id])
    if @deal.update_attributes(params[:deal])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy
    redirect_to :action => "index"
  end
  
private

  def set_cur_panel_active
    set_panel_active("Deal", "deals")
  end
  
end
