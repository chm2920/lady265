class Admin::TopicsController < Admin::AdminBackEndController
    
  def index
    if !params[:topic_ids].nil?
      Topic.destroy_all(["id in (?)", params[:topic_ids]])
    end
    @topics = Topic.paginate :page => params[:page], :per_page => 15, :order => "created_at desc"
  end

  def new
    @categories = Category.all
    @topic = Topic.new
  end

  def edit
    @categories = Category.all
    @topic = Topic.find(params[:id])
  end
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to :action => "index"
  end
  
end
