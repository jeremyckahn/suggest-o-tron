require File.expand_path(File.dirname(__FILE__) + '/itunes')

iTunes = ITunes.new
artists = iTunes.artists_by_play_count.collect {|artist| artist[:name]}
output_filepath = \
  File.expand_path(File.dirname(__FILE__) + '../../../gen/artists.txt')

File.open(output_filepath, 'w') do |output|
  artists.each {|artist| output.puts artist}
end
