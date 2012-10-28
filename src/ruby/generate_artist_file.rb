require File.expand_path(File.dirname(__FILE__) + '/itunes')

iTunes = ITunes.new
puts iTunes.artists_by_play_count.collect {|artist| artist[:name]}
