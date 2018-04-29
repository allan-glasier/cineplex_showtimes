class CineplexShowtimes::CLI

  def call
    get_showtime_list
    showtime_list
    menu    
  end

  # initializes scraper and returns the showtimes array
  def get_showtime_list    
    @showtimes = CineplexShowtimes::Showtimes.showtimes    
  end

  # displays showtime array to CLI
  def showtime_list        
    puts " "
    @showtimes.each.with_index(1) {|showtime, index| puts "#{index}. #{showtime.movie[0]}"}
  end

  # displays menu in CLI
  def menu
    input = ""
    while input != "exit"
      puts "\nEnter the number of the movie you would like to know more about, type 'list' to display the list of showtimes again or type 'exit'\n "
      input = gets.strip.downcase
      
      if input.to_i > 0 
        showtime = @showtimes[input.to_i - 1]
        puts " "
        puts <<~DOC
          #{showtime.movie[0]} | #{showtime.runtime} 
           
          Rated: "#{showtime.rating}" for #{showtime.rating_description}
          
          Showtimes: #{showtime.time.sort.join(", ")}

          Synopsis:
          #{showtime.synopsis}
        DOC
      elsif input == "list"
        showtime_list
      elsif input == "exit"
        goodbye      
      else
        puts "\nUnrecognized command, please enter 'list' or 'exit'\n "
      end      
    end
  end

  # farewell message when closing the program
  def goodbye
    puts "\n Thank you for using the Cineplex Showtimes gem, have yourself a great day!\n "
  end

end