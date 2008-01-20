module LiveTimer

  # Display a time in hours:mins:sec format
  def nice_time(seconds)
    seconds = seconds.to_i
    return '0' unless seconds > 0
    hours   = seconds / 1.hour
    seconds = seconds % 1.hour
    minutes = seconds / 1.minute
    seconds = seconds % 1.minute
    (hours > 0 ? "#{hours}:" : '0:') + ('%02d:%02d' % [minutes, seconds])
  end

  # Show a live-updating timer that works on time-passed-since
  def nice_timer_for(status)
    if status.followup.nil?
      (@content_for_dom_loaded ||= "")
      @content_for_dom_loaded += "new PeriodicalExecuter(function() { timerIncrement('timer_#{dom_id(status)}') }, 1);"
    end # no status followup
    "<span style=\"display:none\" id=\"timer_#{dom_id status}\">#{status.created_at.to_f}</span><span class=\"timer\">#{nice_time(status.accurate_time)}</span>"
  end

end