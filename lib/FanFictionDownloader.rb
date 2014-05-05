require_relative "./FanFictionDownloader/version"

module FanFictionDownloader
  
	class FIMNetGetter

		require 'json'
		require 'httpclient'

		attr_reader :title, :author, :description, :id, :cover_image, :chapter_titles, :chapter_contents, :images

		attr_accessor :url
		
		def initialize(s)
			@title, @author, @description, @id, @cover_image = ''
			@chapter_titles = []
			@chapter_contents = []
			@images = []
			@url = s
		end
		
		def get_information

			@id =@url[/\d+/]
			json = JSON.parse(open("http://www.fimfiction.net/api/story.php?story=#{@id}").read)
			
			@title = json["story"]["title"]
			
			@author = json["story"]["author"]["name"]

			@description = json["story"]["description"]

			if json['story']['image'] != nil
			  @cover_image = json['story']['image']
			end

			if json['story']['full_image'] != nil
			  @cover_image = json['story']['full_image']
			end
			
			for i in json['story']['chapters']
			  @chapter_titles[@chapter_titles.length] = json['story']['chapters'][@chapter_titles.length]['title']
			end
		end

		def get_story
			page = open(%Q[http://www.fimfiction.net/download_story.php?story=#{@id}&html])
		
			for i in page
				if i.start_with?("<p") && @chapter_titles.length > 0
					#Gets the images, if there are any, and replaces the urls to point to local files of the same name
					#i.e. 'www.site.com/image.png' becomes 'image.png'.
					while i.include?("<img src=\"http")
						# start = i.index("<img src=\"http") + 10
						# stop = i.index("\"",start)

						# url = i.slice(start,stop-start)
						# file = url.slice(url.rindex("/")+1,url.length)
						# replace = url[0,url.rindex("/")+1]

						# download(url,file)

						# @files[@files.length] = file

						# i.sub! url,file
						break
					end

					while i.include? "<img src=\"http"
						

					end

					#To make the content look pretier in an epub. In my opinion anyway.
					while i.include?("<center>")
			  			i.sub! "<center>",%Q[<div style="text-align:center;display:block">]
			  			i.sub! "</center>","</div>"
					end

				@chapter_contents[@chapter_contents.length] = i
		 		 end
			end
	  	end
	end
end
