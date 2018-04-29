class CineplexShowtimes::CLI

  def call
    showtime_list
    menu
    goodbye
  end

  def showtime_list
    @showtimes = CineplexShowtimes::Showtimes.showtimes
    @showtimes.each.with_index(1) {|movie, index| puts "#{i}. #{movie.name}"}
  end

  def menu
    input = ""
    while input != "exit"
      puts "Enter the number of the movie you would like to know more about, type 'list' to display the list of showtimes again or type 'exit'"
      input = gets.strip.downcase

      if input.to_i > 0
        showtime = @showtimes[input.to_i - 1]
        puts "#{showtime.name}"
      elsif input == "list"
        showtime_list
      else
        puts "Unrecognized command, please enter 'list' or 'exit'"
      end
    end
  end

  def goodbye
    puts "Thank you for using the Cineplex Showtimes gem, have yourself a great day!"
  end

end