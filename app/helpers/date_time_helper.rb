module DateTimeHelper
  def short_date_format(date_time)
    date_time && I18n.l(date_time, format: "%-d %B %Y")
  end
end
