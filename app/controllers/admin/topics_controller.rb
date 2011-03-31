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
  
  def import
    if request.post?
      xml = params[:xml]
      name = xml.original_filename
      directory = "#{RAILS_ROOT}/public/data"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(xml.read) }
      
      xml_data = File.open(path, "r:utf-8")
      result = ""
      xml_data.each_line do |line|
        result += line
      end
      hsh = Hash.from_xml(result)
      for topic in hsh["articles"]["article"]
        t = Topic.new
        t.category_id = 1
        t.title = topic["title"]
        t.content = topic["url"]
        t.created_at = topic["date"]
        t.save
      end
      render :text => "ok"
    end
  end
  
end
