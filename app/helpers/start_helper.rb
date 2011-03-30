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
  
end
