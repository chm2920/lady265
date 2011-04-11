# coding: utf-8  

desc "get_missing_imgs"
task(:get_missing_imgs => :environment) do  
	4922.upto 5061 do |i|
		topic = Topic.find(i)
		content = topic.content
		content.scan(/src="(.*?)"/) do |a|
      path = "public" + a[0].to_s  
			if File.exist?(path)
			else
        puts i
				puts path
        `git checkout 4668fcc3 #{path}`
			end
		end
	end
end