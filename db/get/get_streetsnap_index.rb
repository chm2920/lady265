
require 'open-uri'
require 'iconv'
  
error_url = Array.new()
posts = Array.new() 
begin
    url = "http://clothing.lady8844.com/streetsnap/index.html"
    puts url
    puts "========================================================================="
    gets = open(url).read
    i = 0
    
    gets.scan(/<a href="(.*?).html" target="_blank">(.*?)<\/a><\/td>(.*?)\n(.*?)<td widht="20%">(.*?)<\/td>/) do |a, b, c, d, e|
      post = Hash.new
      sub_url = a.to_s + ".html"
      post["sub_url"] = sub_url
      puts i.to_s + "_" + sub_url
      post["title"] = b.to_s.force_encoding('UTF-8').gsub('&', "_")
      post["date"] = e.to_s.force_encoding('UTF-8')
#     begin
#       get_content = open(sub_url).read    
#       get_content.scan(/<td class="pad_lrtb28 f14_black1 line_h28">(.*?)<\/td>/m) do |content|
#         hsh["content"] = content[0].to_s.force_encoding('UTF-8')
#       end
#     rescue
#       puts 'error'
#       error_url << sub_url
#       hsh["content"] = ""
#     else
#     end
      posts << post
      i += 1
    end 
  
  posts.reverse!
rescue
ensure
  f = File.new("streetsnap_index.xml","w:UTF-8")
# f.puts "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
  f.puts "<articles>"
  for node in posts
    f.puts "\t<article>"
      f.puts "\t\t<url>" + node["sub_url"] + "</url>"
      f.puts "\t\t<title>" + node["title"].to_s + "</title>"
      #f.puts "\t\t<content><![CDATA[" + node["content"].to_s + "]]></content>"
      f.puts "\t\t<date>" + node["date"] + "</date>"
    f.puts "\t</article>"
  end
  f.puts "</articles>"
  f.close
end

puts error_url.join("\n")

__END__


s = "\xe2"
s = s.sub(2, 2)
puts s.to_i

__END__

string = "\xe2\x80\x9c\xe9\xa6\x96\xe5\xb1\x8a\xe5\x85\xa8\xe5\x9b\xbd\xe5\x9f"
chars = string.scan(/..../)
chars.each {|char| print char.to_i(16).chr}

__END__

#get_content = Iconv.conv("UTF-8//IGNORE", "GB2312//IGNORE", get_content)