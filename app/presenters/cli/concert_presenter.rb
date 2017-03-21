require 'colorize'

class Cli::ConcertPresenter
  attr_reader :concert

  def initialize concert
    @concert = concert
  end

  def description
    artists    = concert.artists.map { |a| a.name }
    delimeters = [','] * (artists.count - 1)
    delimeters[-1] = 'and'
    delimeters[0]  = 'with'

    title = artists.zip(delimeters.map { |d| d.light_black }).flatten.compact.join(' ')

    "#{title} #{'@'.light_blue} #{concert.venue.name} #{'on'.light_black} #{concert.at.strftime('%b %d')}"
  end
end
