# coding: utf-8

desc "import xml"
task(:import_xml => :environment) do
  name = "topics.xml"
  directory = "#{RAILS_ROOT}/"
  path = File.join(directory, name)
  
  xml_data = File.open(path, "r:utf-8")
  result = ""
  xml_data.each_line do |line|
    result += line
  end
  hsh = Hash.from_xml(result)
  for topic in hsh["topics"]["topic"]
    t = Topic.new
    t.category_id = topic["category_id"]
    t.title = topic["title"]
    t.content = topic["content"]
    t.summary = topic["summary"]
    t.pub_from = topic["pub_from"]
    t.editor = topic["editor"]
    t.cover_file_name = topic["cover_file_name"]
    t.created_at = topic["created_at"]
    t.hits = 0
    t.save
  end
end