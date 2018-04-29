class CineplexShowtimes::Showtimes
  attr_accessor :movie, :runtime, :time, :rating, :rating_description, :synopsis

  def self.showtimes
    self.scrape_showtimes
  end

  def self.scrape_showtimes
    showtimes = []

    showtimes << self.scrape_silvercity
    showtimes << self.scrape_odeon

    showtimes
  end

  def self.scrape_silvercity
    date = DateTime.now.strftime("%m/%d/%Y")
    domain = "https://www.cineplex.com"
    html = Nokogiri::HTML(open("https://www.cineplex.com/Showtimes/any-movie/cineplex-odeon-devonshire-mall-cinemas?Date=#{date}"))
    showtimes = {}  

    html.css(".showtime-card").each do |movie_object|      
      synopsis_link = movie_object.css(".movie-details-link-click").attribute("href").value            
      showtimes = {
        :movie => movie_object.css(".h3 a").text.strip,
        :runtime => movie_object.css(".h3 span").text.gsub("| ", ""),
        :time => movie_object.css(".showtime--list a").text.gsub(" ", "").gsub("\n", "").split("\r").reject(&:empty?).sort,
        :rating => movie_object.css(".movie-header-details p meta").attribute("content").value,
        :rating_description => movie_object.css(".movie-header-details p:first-child").text.strip,
        :synopsis => Nokogiri::HTML(open("#{domain}#{synopsis_link}")).css(".md-movie-info div:first-child p").text
      }
    end
    showtimes
  end

  def self.scrape_odeon

  end

end