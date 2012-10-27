require 'rubygems'
require "bundler/setup"

require 'plist'

class ITunes
  attr_reader :library, :parse_time

  def initialize (path=nil)
    @path = path.nil? \
      ? File.join(Dir::home, '/Music/iTunes/iTunes Music Library.xml') \
      : path

    parse
    build_artist_hash
    calculate_average_plays
  end


  private
  def parse
    start_time = Time.now.to_f
    @library = Plist::parse_xml(@path)
    @parse_time = Time.now.to_f - start_time
  end


  private
  def build_artist_hash
    @artist_hash = {}
    @library['Tracks'].values.collect do |track|
      artist = track['Artist']
      next if not artist

      if @artist_hash[artist].nil?
        @artist_hash[artist] = {
          :name => artist,
          :songs_count => 1,
          :play_count => 0,
          :average_plays => nil
        }
      else
        @artist_hash[artist][:songs_count] += 1
        @artist_hash[artist][:play_count] += (track['Play Count'] or 0)
      end
    end
  end


  private
  def calculate_average_plays ()
    @artist_hash.each_value { |artist|
      artist[:average_plays] = artist[:play_count].to_f / artist[:songs_count]
    }
  end


  public
  def artists
    @artist_hash
  end


  public
  def artists_by_play_count
    artists.values.sort {|a,b| b[:average_plays] <=> a[:average_plays]}
  end
end
