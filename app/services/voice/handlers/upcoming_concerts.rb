class Voice::Handlers::UpcomingConcerts < Voice::Handlers::Base
  def call request
    user = user_for request

    concert = user.concerts.upcoming.first
    artists = concert.artists.map(&:name)

    month = concert.at.strftime '%B'
    day   = concert.at.strftime('%d').to_i.ordinalize

    text = "Your next concert is #{artists.to_sentence} at #{concert.venue.name} on #{month} #{day}."


    if tickets = user.tickets_for(concert)
      text += tickets.description + ". "
    end


    others = user.concerts.in_month(concert.at).count
    if others > 0
      text += " You have #{pluralize others, 'other concert'} in #{month}."
    end


    simple_response text
  end
end
