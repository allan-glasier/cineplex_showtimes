class CineplexShowtimes::Showtimes
  attr_accessor :movie, :runtime, :time, :rating, :rating_description, :synopsis  

  @@showtimes = []

  def self.showtimes
    self.scrape_showtimes
    binding.pry
  end

    def self.scrape_showtimes
    date = DateTime.now.strftime("%m/%d/%Y")
    domain = "https://www.cineplex.com"
    html = Nokogiri::HTML(open("https://www.cineplex.com/Showtimes/any-movie/cineplex-odeon-devonshire-mall-cinemas?Date=#{date}"))    

    html.css(".showtime-card").each do |movie_object|      
      synopsis_link = movie_object.css(".movie-details-link-click").attribute("href").value            
        showtime = self.new         
        showtime.movie = movie_object.css(".h3 a").text.strip,
        showtime.runtime = movie_object.css(".h3 span").text.gsub("| ", ""),
        showtime.time = movie_object.css(".showtime--list a").text.gsub(" ", "").gsub("\n", "").split("\r").reject(&:empty?),
        showtime.rating = movie_object.css(".movie-header-details p meta").attribute("content").value,
        showtime.rating_description = movie_object.css(".movie-header-details p:first-child").text.strip,
        showtime.synopsis = Nokogiri::HTML(open("#{domain}#{synopsis_link}")).css(".md-movie-info div:first-child p").text
        @@showtimes << showtime      
    end
    @@showtimes       
  end
end