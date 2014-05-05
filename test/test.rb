require '../lib/FanFictionDownloader'
require 'nokogiri'

fic = FanFictionDownloader::FIMNetGetter.new 'http://www.fimfiction.net/story/104188/valkyrie'

fic.get_information

fic.get_story


