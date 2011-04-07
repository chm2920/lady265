
require 'open-uri'
require 'iconv'

desc "get_new_articles_from_web"
task(:get_new => :environment) do  
  def get_content(post)
    topic = Topic.new
    topic.category_id = post.category_id
    topic.title = post.title
    topic.created_at = post.created_at
    topic.pub_from = "爱美网"
    topic.editor = "hello_su"
    topic.hits = 0
    
    url = post.url
    content = get_summary_and_content(url)

    topic.summary = content[0]
    topic.content = content[1]
    topic.save!
    save_images(topic)
    
    post.topic_id = topic.id
    post.is_get = 1
    post.save!
  end
  
  def save_images(topic)
    full_directory = "#{RAILS_ROOT}/public/imgfiles/#{topic.id}/"
    directory = "/imgfiles/#{topic.id}/"
    Dir.mkdir(full_directory)
    
    content = topic.content
    imgs = content.scan(/src="(.*?)"/)
    if imgs.length>0
      tmp_arr = []
      imgs.each do |img|
        image_file = img[0].to_s
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
  end
  
  def get_summary_and_content(url)
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
    return [summary, content]
  end
  
  def get_photo_content(post)
    ActiveRecord::Base.transaction do
      begin
        require 'open-uri'
        require 'iconv'
        topic = post.topic
        puts topic.id.to_s + "======================"
        url = post.url
        gets = open(url).read
        imgs = Array.new()        
        page = 2
        gets.scan(/max_page = (.*?);/) do |a|
          puts a[0].to_s
          page = a[0].to_s
        end
    
        gets.scan(/<img src=\"(.*?)\" lowsrc=/) do |b|
          puts b[0].to_s
          imgs << "<img src=\"" + b[0].to_s + "\">"
        end
        
        2.upto page.to_i do |i|
          sub_url = url.gsub(".html", "_#{i-1}.html")
          sub_get = open(sub_url).read
          sub_get.scan(/<img src=\"(.*?)\" lowsrc=/) do |b|
            puts b[0].to_s
            imgs << "<img src=\"" + b[0].to_s + "\">"
          end
        end
        
        content = imgs.join("<hr><hr>")
      
        full_directory = "#{RAILS_ROOT}/public/imgfiles/#{topic.id}/"
        directory = "/imgfiles/#{topic.id}/"
        #Dir.mkdir(full_directory)
        
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
  
  BEGINDATE = "2011-04-01" 

  urls = []
  urls << "http://clothing.lady8844.com/clothing/star/index.html"
  #urls << "http://clothing.lady8844.com/clothing/fashion/index.html"
  #urls << "http://clothing.lady8844.com/clothing/school/index.html"
  #urls << "http://clothing.lady8844.com/streetsnap/index.html"
  #urls << "http://clothing.lady8844.com/clothing/accessories/index.html"
  #urls << "http://clothing.lady8844.com/clothing/bags/index.html"
  #urls << "http://clothing.lady8844.com/clothing/shoes/index.html"

  0.upto urls.length-1 do |i|
    url = urls[i]
    puts url
    gets = open(url).read
    posts = []
    j = 1    
    gets.scan(/<a target="_blank" href="(.*?).html" title="(.*?)">(.*?)<\/a><span class="date">(.*?)<\/span>/) do |a, b, c, d|
      post = Hash.new
      sub_url = a.to_s + ".html"
      post["sub_url"] = sub_url
      post["title"] = b.to_s.force_encoding('UTF-8').gsub('&', "_")
      post["date"] = d.to_s.force_encoding('UTF-8').gsub('[', "").gsub(']', "")
      if post["date"]>=BEGINDATE
        puts j.to_s + "_" + sub_url
        j += 1
        posts << post
      end
    end  
    posts.reverse!
#    for post in posts
#      p = Post.new
#      p.category_id = i+1
#      p.title = post["title"]
#      p.url = post["url"]
#      p.created_at = post["date"]
#      p.save!
#      get_content(p)
#    end
  end
  @topics = Topic.find(:all, :conditions => "content = ''")
  for topic in @topics
    @post = Post.find_by_topic_id(topic.id)
    get_photo_content(@post)
  end
end

#begin
#  0.upto urls.length-1 do |i|
#    url = urls[i]
#    puts url
#    puts "========================================================================="
#    gets = open(url).read
#    j = 1    
#    gets.scan(/<a target="_blank" href="(.*?).html" title="(.*?)">(.*?)<\/a><span class="date">(.*?)<\/span>/) do |a, b, c, d|
#      post = Hash.new
#      sub_url = a.to_s + ".html"
#      post["sub_url"] = sub_url
#      post["title"] = b.to_s.force_encoding('UTF-8').gsub('&', "_")
#      post["date"] = d.to_s.force_encoding('UTF-8').gsub('[', "").gsub(']', "")
#      if post["date"]>=BEGINDATE
#        puts j.to_s + "_" + sub_url
#        j += 1
#        posts << post
#      end
#    end  
#    posts.reverse!
#    for post in posts
#      p = Post.new
#      p.category_id = i+1
#      p.title = post["title"]
#      p.url = post["url"]
#      p.created_at = post["date"]
#      p.save!
#      get_content(p)
#    end
#  end  
#  @topics = Topic.find(:all, :conditions => "content = ''")
#  for topic in @topics
#    @post = Post.find_by_topic_id(topic.id)
#    get_photo_content(@post)
#  end
#rescue
#ensure
#end
#
#
##  
#  def get_content(post)
#    ActiveRecord::Base.transaction do
#      begin
#        topic = Topic.new
#        topic.category_id = post.category_id
#        topic.title = post.title
#        topic.created_at = post.created_at
#        topic.pub_from = "爱美网"
#        topic.editor = "hello_su"
#        topic.hits = 0
#        url = post.url
#        gets = open(url).read
#        last_url = url.split("/").last.to_s
#        summary = ""
#        content = ""
#        pages = []
#        
#        gets.scan(/<div class="guide_txt">(.*?)<\/div>/m) do |c|
#          summary = c[0].strip.to_s.force_encoding('UTF-8').downcase
#        end
#        gets.scan(/div id="content_pagelist"(.*?)>(.*?)<\/div>/) do |e, f|
#          pages = f.to_s.scan(/href='(.*?)'/).uniq
#        end
#        
#        c = []
#        gets.scan(/<span id="TEXT_CONTENT" style="margin-top:3px;display:block;">(.*?)<\/span>/m) do |d|
#          c << d[0].strip.to_s.force_encoding('UTF-8').downcase
#        end
#        for page in pages
#          page = page[0].to_s
#          puts page
#          sub_get = open(url.gsub(last_url, page)).read
#          sub_get.scan(/<span id="TEXT_CONTENT" style="margin-top:3px;display:block;">(.*?)<\/span>/m) do |d|
#            c << d[0].strip.to_s.force_encoding('UTF-8').downcase
#          end
#        end
#        content = c.join("<hr><hr>")
#        
#        summary = summary.gsub(" ", "")
#        summary = summary.gsub("\t", "")
#        summary = summary.gsub("\n", "")
#        content = content.gsub(/<a(.*?)>/, "")
#        content = content.gsub(/<\/a>/, "")
#        content = content.gsub(/<htm(.*?)>/, "")
#        content = content.gsub(/<met(.*?)>/, "")
#        content = content.gsub(/<bod(.*?)>/, "")
#        content = content.gsub(/<\/body>/, "")
#        content = content.gsub(/<head(.*?)>/, "")
#        content = content.gsub(/<\/head>/, "")
#
#        topic.summary = summary
#        topic.content = content
#        topic.save!
#      
#        full_directory = "#{RAILS_ROOT}/public/imgfiles/#{topic.id}/"
#        directory = "/imgfiles/#{topic.id}/"
#        Dir.mkdir(full_directory)
#        
#        cs = content.scan(/src="(.*?)"/)
#        if cs.length>0
#          tmp_arr = []
#          cs.each do |h|
#            image_file = h[0].to_s
#            puts image_file
#            name = Time.now.strftime("%Y%m%d%H%M%S") + rand(100).to_s + "." + image_file.split(".").last
#            path = File.join(full_directory, name)
#            File.open(path, "wb") { |f| f.write(open(image_file).read) }
#            puts directory + name
#            tmp_arr << directory + name
#            content = content.gsub(image_file, directory + name)
#          end
#          
#          topic.content = content
#          topic.cover_file_name = tmp_arr[0].to_s
#        end
#        topic.save!
#        
#        post.topic_id = topic.id
#        post.is_get = 1
#        post.save!
#      rescue Exception => e
#        ActiveRecord::Rollback
#        record_error(e)
#      end
#    end
#  end
#  

#  
#  