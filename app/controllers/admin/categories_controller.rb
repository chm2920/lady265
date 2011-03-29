class Admin::CategoriesController < Admin::AdminBackEndController
    
  def index
    if !params[:category_ids].nil?
      Category.destroy_all(["id in (?)", params[:category_ids]])
    end
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to :action => "index"
  end
  
  def show
    
  end
  
end
