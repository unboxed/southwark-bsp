module DateTimeHelper
  def short_date_format(date_time)
    date_time && I18n.l(date_time, format: "%-d %B %Y")
  end

  def date_time_format(date_time)
    date_time && I18n.l(date_time, format: "%d-%m-%Y %H:%M")
  end
end
