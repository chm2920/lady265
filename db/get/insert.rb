
require 'active_model'

include ActiveModel::Serialization

xml = "D:/cygwin/home/Cminor/program/workspace/lady265/public/data/star.xml"

puts Hash.from_xml(xml).length

__End__

require "mysql" 
require "time"
require 'rexml/document'

titles = []
contents = []
created_ats = []

xml_data = File.open("dtxw/yunyingzhuandi.xml", "r:utf-8")
puts "= loading"
doc = REXML::Document.new(xml_data)

doc.elements.each('bjsubway/yunyingzhuandi/wenzhangliebiao/timu') do |ele|
	#puts ele.text #.force_encoding('UTF-8')
	titles << ele.text.force_encoding('UTF-8')
end

doc.elements.each('bjsubway/yunyingzhuandi/wenzhangliebiao/neirong') do |ele|
   contents << ele.text.force_encoding('UTF-8')
end

doc.elements.each('bjsubway/yunyingzhuandi/wenzhangliebiao/shijian') do |ele|
   created_ats << ele.text.force_encoding('UTF-8')
end


puts '= loaded'

0.upto titles.length-1 do |i|
	puts i
	begin 
		title = titles[i]
		content = contents[i].gsub("'", """")
		created_at = Time.parse(created_ats[i])
		
		puts "============= insert into node ============"
		dbh = Mysql.real_connect("localhost", "root", "", "drupal") 
		sql = "set names utf8;"
		res = dbh.query(sql)
		sql = "insert into node(vid, type, language, title, uid, status, created, changed)"
		sql += " values(0, 'article', 'zh_hans', '#{title}', 3, 1, UNIX_TIMESTAMP('#{created_at}' + INTERVAL 8 HOUR), UNIX_TIMESTAMP('#{created_at}' + INTERVAL 8 HOUR))"
		#puts sql
		res = dbh.query(sql)
		puts res
		puts "\n============= get nid ============"
		sql = "SELECT LAST_INSERT_ID()"
		puts sql
		res = dbh.query(sql)
		nid = 0
		while row = res.fetch_row do 
			printf "%s", row[0]
			nid = row[0]
		end
		dbh.close if dbh 
		puts "\n============= insert into node_revisions ============"
		dbh = Mysql.real_connect("localhost", "root", "", "drupal") 
		sql = "set names utf8"
		res = dbh.query(sql)
		sql = "insert into node_revisions(nid, uid, title, body, teaser, log, timestamp)"
		sql += " values(#{nid}, 3, '#{title}', '#{content}', '#{content}', '', UNIX_TIMESTAMP('#{created_at}' + INTERVAL 8 HOUR))"
		puts sql
		res = dbh.query(sql)
		puts res
		puts "\n============= get vid ============"
		sql = "SELECT LAST_INSERT_ID()"
		puts sql
		res = dbh.query(sql)
		vid = 0
		while row = res.fetch_row do 
			printf "%s", row[0]
			vid = row[0]
		end
		dbh.close if dbh 
		puts "\n============= update node vid ============"
		sql = "update node set vid = #{vid} where nid = #{nid}"
		puts sql
		dbh = Mysql.real_connect("localhost", "root", "", "drupal") 
		res = dbh.query(sql)
		puts res
		dbh.close if dbh 
		puts "\n============= insert into node_comment_statistics ============"
		sql = "insert into node_comment_statistics(nid, last_comment_timestamp, last_comment_uid)"
		sql += " values(#{nid}, UNIX_TIMESTAMP('#{created_at}' + INTERVAL 8 HOUR), 3)"
		puts sql
		dbh = Mysql.real_connect("localhost", "root", "", "drupal") 
		res = dbh.query(sql)
		puts res
		dbh.close if dbh 
		puts "\n============= insert into term_node ============"
		sql = "insert into term_node(nid, vid, tid)"
		sql += " values(#{nid}, #{vid}, 55)"
		puts sql
		dbh = Mysql.real_connect("localhost", "root", "", "drupal") 
		res = dbh.query(sql)
		puts res
		puts "success"
	rescue Mysql::Error => e 
		puts "Error code: #{e.errno}" 
		puts "Error message: #{e.error}" 
		puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate") 
	ensure 
		dbh.close if dbh 
	end
		
end
