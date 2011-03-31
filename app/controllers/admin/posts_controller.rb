class Admin::PostsController < Admin::AdminBackEndController
  
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
      for post in hsh["articles"]["article"]
        t = Post.new
        t.category_id = 7
        t.title = post["title"]
        t.url = post["url"]
        t.created_at = post["date"]
        t.save
      end
      render :text => "ok"
    end
  end
    
  def index
    if !params[:post_ids].nil?
      Post.destroy_all(["id in (?)", params[:post_ids]])
    end
    if !params[:keyword].nil?
      @posts = Post.paginate :page => params[:page], :per_page => 15, :conditions => "is_get = 0 and title like '%#{params[:keyword]}%'", :order => "created_at desc"
    else
      @posts = Post.paginate :page => params[:page], :per_page => 15, :conditions => "is_get = 0", :order => "created_at desc"
    end
  end
    
  def all
    if !params[:post_ids].nil?
      Post.destroy_all(["id in (?)", params[:post_ids]])
    end
    if !params[:keyword].nil?
      @posts = Post.paginate :page => params[:page], :per_page => 15, :conditions => "title like '%#{params[:keyword]}%'", :order => "created_at desc"
    else
      @posts = Post.paginate :page => params[:page], :per_page => 15, :order => "created_at desc"
    end
  end

  def new
    @categories = Category.all
    @post = Post.new
  end

  def edit
    @categories = Category.all
    @post = Post.find(params[:id])
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to :action => "index"
  end
  
end
