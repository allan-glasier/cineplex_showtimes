class CineplexShowtimes::Showtimes
  attr_accessor :movie, :runtime, :time, :rating, :rating_description, :synopsis  

  @@showtimes = []

  def self.showtimes
    self.scrape_showtimes    
  end

    # scrapes showtimes & movie data from cineplex website
    def self.scrape_showtimes
    # sets date to pass into html method below
    date = DateTime.now.strftime("%m/%d/%Y")
    # sets domain to be used when looking up synopsis
    domain = "https://www.cineplex.com"
    # sets html to the list of showtimes for the current day
    html = Nokogiri::HTML(open("https://www.cineplex.com/Showtimes/any-movie/cineplex-odeon-devonshire-mall-cinemas?Date=#{date}"))    
    #iterate over each showtime grabbing the details of each and putting it into array
    html.css(".showtime-card").each do |movie_object|      
      synopsis_link = movie_object.css(".movie-details-link-click").attribute("href").value            
        showtime = self.new
        # grabs movie title     
        showtime.movie = movie_object.css(".h3 a").text.strip,
        # grabs movie runtime
        showtime.runtime = movie_object.css(".h3 span").text.gsub("| ", ""),
        # grabs showtimes, clears extra space from return object, converts time to date objects, sorts array, converts back to strings
        showtime.time = movie_object.css(".showtime--list a").text.gsub(" ", "").gsub("\n", "").split("\r").reject(&:empty?).collect{|t| Time.parse(t)}.sort.collect{|t| t.strftime("%I:%M%p")},
        # grabs movie rating
        showtime.rating = movie_object.css(".movie-header-details p meta").attribute("content").value,
        # grabs description of rating
        showtime.rating_description = movie_object.css(".movie-header-details p:first-child").text.strip,
        # goes into movie's page and grabs the synopsis
        showtime.synopsis = Nokogiri::HTML(open("#{domain}#{synopsis_link}")).css(".md-movie-info div:first-child p").text
        # throw the collected showtime into array of all showtimes
        @@showtimes << showtime      
    end
    # returns array
    @@showtimes       
  end
end