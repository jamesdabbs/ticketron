module ApplicationHelper
  def ago dt
    return unless dt
    "#{time_ago_in_words dt} ago"
  end

  def day dt
    dt.strftime '%B %d'
  end

  def songkick_path concert
    "https://songkick.com/concerts/#{concert.songkick_id}"
  end

  def status_icon status
    {
      Tickets::Order    => 'eye-open',
      Tickets::ByMail   => 'envelope',
      Tickets::InHand   => 'thumbs-up',
      Tickets::Print    => 'print',
      Tickets::WillCall => 'ok'
    }.fetch status
  end
end
