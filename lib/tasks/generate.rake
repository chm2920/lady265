# coding: utf-8

desc "generate xml"
task(:generate_xml => :environment) do
  topics = Topic.find(:all, :conditions => "created_at >= '2011-04-01'", :order => "id desc")
  f = File.new("public/xml/topics.xml","w:UTF-8")
# f.puts "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  f.puts "<topics>"
  for topic in topics
    f.puts "\t<topic>"
      f.puts "\t\t<category_id>" + topic["category_id"].to_s + "</category_id>"
      f.puts "\t\t<title>" + topic["title"].to_s + "</title>"
      f.puts "\t\t<content><![CDATA[" + topic["content"].to_s + "]]></content>"
      f.puts "\t\t<summary><![CDATA[" + topic["summary"] + "]]></summary>"
      f.puts "\t\t<pub_from>" + topic["pub_from"] + "</pub_from>"
      f.puts "\t\t<editor>" + topic["editor"] + "</editor>"
      f.puts "\t\t<cover_file_name>" + topic["cover_file_name"] + "</cover_file_name>"
      f.puts "\t\t<created_at>" + topic["created_at"].strftime("%Y-%m-%d") + "</created_at>"
    f.puts "\t</topic>"
  end
  f.puts "</topics>"
  f.close
  
  posts = Post.find(:all, :conditions => "created_at >= '2011-04-01'", :order => "id desc")
  f = File.new("public/xml/posts.xml","w:UTF-8")
# f.puts "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  f.puts "<posts>"
  for post in posts
    f.puts "\t<post>"
      f.puts "\t\t<category_id>" + post["category_id"].to_s + "</category_id>"
      f.puts "\t\t<topic_id>" + post["topic_id"].to_s + "</topic_id>"
      f.puts "\t\t<title>" + post["title"].to_s + "</title>"
      f.puts "\t\t<url>" + post["url"] + "</url>"
      f.puts "\t\t<created_at>" + post["created_at"].strftime("%Y-%m-%d") + "</created_at>"
    f.puts "\t</post>"
  end
  f.puts "</posts>"
  f.close
end