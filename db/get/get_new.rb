
require 'open-uri'
require 'iconv'
	
posts = Array.new()

urls = []
urls << "http://clothing.lady8844.com/clothing/star/index.html"
urls << "http://clothing.lady8844.com/clothing/fashion/index.html"
urls << "http://clothing.lady8844.com/clothing/school/index.html"
urls << "http://clothing.lady8844.com/streetsnap/index.html"
urls << "http://clothing.lady8844.com/clothing/accessories/index.html"
urls << "http://clothing.lady8844.com/clothing/bags/index.html"
urls << "http://clothing.lady8844.com/clothing/shoes/index.html"

BEGINDATE = "2011-04-01"

begin
  #for url in urls
    url = urls[0]
    puts url
    puts "========================================================================="
    gets = open(url).read
    i = 0    
    gets.scan(/<a target="_blank" href="(.*?).html" title="(.*?)">(.*?)<\/a><span class="date">(.*?)<\/span>/) do |a, b, c, d|
      post = Hash.new
      sub_url = a.to_s + ".html"
      post["sub_url"] = sub_url
      post["title"] = b.to_s.force_encoding('UTF-8').gsub('&', "_")
      post["date"] = d.to_s.force_encoding('UTF-8').gsub('[', "").gsub(']', "")
      if post["date"]>=BEGINDATE
        puts i.to_s + "_" + sub_url
        i += 1
        posts << post
      end
    end  
  #end	
	posts.reverse!
rescue
ensure
	f = File.new("get_new.xml","w:UTF-8")
	f.puts "<articles>"
	for node in posts
		f.puts "\t<article>"
			f.puts "\t\t<url>" + node["sub_url"] + "</url>"
			f.puts "\t\t<title>" + node["title"].to_s + "</title>"
			f.puts "\t\t<date>" + node["date"] + "</date>"
		f.puts "\t</article>"
	end
	f.puts "</articles>"
	f.close
end
