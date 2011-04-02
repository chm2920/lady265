# coding: utf-8  
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
  
  def get_article
    1.upto 7 do |i|
      @posts = Post.find(:all, :conditions => "category_id = #{i} and is_get = 0", :order => "created_at desc", :limit => 20)
      for post in @posts
        get_content(post)
      end
    end
    #Topic.destroy_all
    redirect_to :action => :index
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
  
  def get_content(post)
    ActiveRecord::Base.transaction do
      begin
        topic = Topic.new
        topic.category_id = post.category_id
        topic.title = post.title
        topic.created_at = post.created_at
        topic.pub_from = "爱美网"
        topic.editor = "hello_su"
        topic.hits = 0
        require 'open-uri'
        require 'iconv'
        url = post.url
        gets = open(url).read
        last_url = url.split("/").last.to_s
        summary = ""
        content = ""
        pages = []
        
        gets.scan(/<div class="guide_txt">(.*?)<\/div>/m) do |c|
          summary = c[0].strip.to_s.force_encoding('UTF-8').downcase
        end
        gets.scan(/div id="content_pagelist"(.*?)>(.*?)<\/div>/) do |e, f|
          pages = f.to_s.scan(/href='(.*?)'/).uniq
        end
        
        c = []
        gets.scan(/<span id="TEXT_CONTENT" style="margin-top:3px;display:block;">(.*?)<\/span>/m) do |d|
          c << d[0].strip.to_s.force_encoding('UTF-8').downcase
        end
        for page in pages
          page = page[0].to_s
          puts page
          sub_get = open(url.gsub(last_url, page)).read
          sub_get.scan(/<span id="TEXT_CONTENT" style="margin-top:3px;display:block;">(.*?)<\/span>/m) do |d|
            c << d[0].strip.to_s.force_encoding('UTF-8').downcase
          end
        end
        content = c.join("<hr><hr>")
        
        summary = summary.gsub(" ", "")
        summary = summary.gsub("\t", "")
        summary = summary.gsub("\n", "")
        content = content.gsub(/<a(.*?)>/, "")
        content = content.gsub(/<\/a>/, "")
        content = content.gsub(/<htm(.*?)>/, "")
        content = content.gsub(/<met(.*?)>/, "")
        content = content.gsub(/<bod(.*?)>/, "")
        content = content.gsub(/<\/body>/, "")
        content = content.gsub(/<head(.*?)>/, "")
        content = content.gsub(/<\/head>/, "")

        topic.summary = summary
        topic.content = content
        topic.save!
      
        full_directory = "#{RAILS_ROOT}/public/imgfiles/#{topic.id}/"
        directory = "/imgfiles/#{topic.id}/"
        Dir.mkdir(full_directory)
        
        cs = content.scan(/src="(.*?)"/)
        if cs.length>0
          tmp_arr = []
          cs.each do |h|
            image_file = h[0].to_s
            puts image_file
            name = Time.now.strftime("%Y%m%d%H%M%S") + rand(100).to_s + "." + image_file.split(".").last
            path = File.join(full_directory, name)
            File.open(path, "wb") { |f| f.write(open(image_file).read) }
            puts directory + name
            tmp_arr << directory + name
            content = content.gsub(image_file, directory + name)
          end
          
          topic.content = content
          topic.cover_file_name = tmp_arr[0].to_s
        end
        topic.save!
        
        post.topic_id = topic.id
        post.is_get = 1
        post.save!
      rescue Exception => e
        ActiveRecord::Rollback
        record_error(e)
      end
    end
  end
  
  def set_cover
    for topic in Topic.all
      imgs = topic.content.scan(/src="(.*?)"/)
      if imgs.length > 0
        topic.cover_file_name = imgs[0][0].to_s
      else
        topic.cover_file_name = ""
      end
      topic.save
    end
    render :text => "ok"
  end
  
end
