# coding: utf-8  
module StartHelper
  
  def show_nav_list(cur, categories)
    nav_list = "<li class='first"
    if cur=="index" || cur.nil?
      nav_list += " current'><a href='/'>首页</a></li>"
    else
      nav_list += "'><a href='/'>首页</a></li>"
    end
    categories.each do |c|
      if cur==c.alias
        nav_list += "<li class='current'><a href='/c/#{c.alias}'>#{c.name}</a></li>"
      else
        nav_list += "<li><a href='/c/#{c.alias}'>#{c.name}</a></li>"
      end
    end
    simple_format(nav_list).gsub("<p>", "").gsub("</p>", "")
  end
  
  def topic_show_page(topic, page_count, page)
    id = topic.id
    date = topic.created_at.strftime("%Y%m%d")
    if page==1
      links = "<a href='#{date}_#{id}.html' class='current'>1</a>"
    else
      links = "<a href='#{date}_#{id}.html'>1</a>"
    end    
    2.upto page_count do |i|
      if page==i
        p_link = "<a href='#{date}_#{id}_#{i}.html' class='current'>#{i}</a>"
      else
        p_link = "<a href='#{date}_#{id}_#{i}.html'>#{i}</a>"
      end
      links += p_link
    end
    simple_format links
  end
  
  def show_content(content)
    content = content.gsub(/<strong>爱美网猜你喜欢的文章<\/strong>(.*?)<\/p>(.*?)<\/p>/m, "")
    content = content.gsub(/<strong>爱美网猜你喜欢的文章<\/strong>(.*?)<\/p>/m, "")
    simple_format content
  end
  
end
