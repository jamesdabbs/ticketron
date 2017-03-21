module ApplicationHelper
  def ago dt
    return '' unless dt
    time_ago_in_words(dt) + ' ago'
  end

  def icon name
    "<span class='glyphicon glyphicon-#{name}'></span>".html_safe
  end
end
