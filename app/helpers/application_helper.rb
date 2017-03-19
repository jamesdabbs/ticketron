module ApplicationHelper
  def ago time
    return unless time
    "#{time_ago_in_words time} ago"
  end
end
