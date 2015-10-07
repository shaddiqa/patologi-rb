module ApplicationHelper
  # Usage:
  # better_date(Time.now) -> "Today, 10:30am"
  # better_date(Time.now.yesterday) -> "Yesterday, 10:30 am"
  # better_date(Time.now - 1.week) -> "31 July 2015 - 10:30 am"
  # better_date(Time.now - 1.week,  seconds: true) -> "31 July 2015 - 10:30:22 am"
  # better_date(Time.now - 1.week,  long_format: "%d/%m/%Y %H:%M") -> "17/07/2015, 22:30"
  # better_date(Time.now - 1.week,  time_format: "%H:%M") -> "31 July 2015 - 22:30"
  # better_date(Time.now,           time_format: "%H:%M") -> "Today, 22:30"
  # better_date(Time.now.yesterday, time_format: "%H:%M") -> "Yesterday, 22:30"
  def better_date(date, options = {})
    if options[:time_format]
      time_format = options[:time_format]
    else
      time_format = options[:seconds] ? "%I:%M:%S %P" : "%I:%M %P"
    end

    long_format = options[:long_format] || "%B %d %Y - #{time_format}"

    if date.today?
      date.strftime("Today, #{time_format}")
    elsif date > Time.now.beginning_of_day - 1.day && date < Time.now.beginning_of_day
      date.strftime("Yesterday, #{time_format}")
    else
      date.strftime(long_format)
    end
  end
end
