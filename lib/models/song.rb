class Song
  attr_accessor :artist, :genre, :name

  extend Memorable::ClassMethods
  include Memorable::InstanceMethods

  extend Sluggable::ClassMethods
  include Sluggable::InstanceMethods

  extend Listable
  extend Findable

  reset_all

  def self.new_from_params(params)
    self.new.tap do |s|
      s.name = params[:song_name]
      s.genre = Genre.find_or_create_by_name(params[:genre_name])
      Artist.find_or_create_by_name(params[:artist_name]).add_song(s)
    end
  end

  def youtube
    YoutubeSearch.search("#{self.artist.name} #{self.name}").first
  end

  def url
    "#{self.name}.html"
  end

  def self.action(index)
    self.all[index-1].play
  end

  def play
    puts "playing #{self.title}, enjoy!"
  end

  def title
    "#{self.artist.name} - #{self.name} [#{self.genre.name}]"
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self
  end

end
