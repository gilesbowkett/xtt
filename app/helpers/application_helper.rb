# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include LiveTimer
  
  def box(type, name, &block)
    type = type.to_s
    box = OpenStruct.new
    box.name= name
    yield box
    render :file => "/components/#{type}_box", :locals => {:box => box}
  end
  
  def gravatar_for(user)
    image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.hexdigest user.email}&rating=R&size=48", :alt => h(user.login), :class => 'thumbnail fn'
  end
  
  def first_in_collection?(collection, index)
    collection.size == (index  + 1)
  end
  
  def update_button
    tag(:input, {:type => 'image', :src => '/images/btns/ghost.gif', :class => 'btn'})
  end
  
  def save_button
    tag(:input, {:type => 'image', :src => '/images/btns/ghost.gif', :class => 'btn save'})
  end
  
  def link_to_status(status)
    ret = ""
    ret << (status.project ? link_to(h(status.project.name), status.project) + ": " : "Out: ")
    ret << link_to(h(status.message), status)
    ret
  end
  
  def start_time_for(status)
    js_time status.created_at
  end
  
  def finish_time_for(status)
    js_time status.finished_at
  end

  @@default_jstime_format = "%d %b, %Y %I:%M %p"
  def js_datetime(time, rel = :datetime)
    content_tag('abbr', content_tag('span', time.utc.strftime(@@default_jstime_format), :class => :timestamp, :rel => rel, :title => time.utc.strftime(@@default_jstime_format)), :title => time.iso8601, :class => 'published')
  end
  
  def js_time_ago_in_words(time)
    js_datetime time, :words
  end
  
  def js_time(time)
    js_datetime time, :time
  end
  
  def js_day(time)
    js_datetime time, :day
  end
  
  def js_day_name(time)
    js_datetime time, :dayName
  end
  
  def display_flash(key)
    return nil if flash[key].blank?
    content_tag(:div, content_tag(:div, h(flash[key]), :class => 'mblock-cnt'), :class => 'mblock', :id => key.to_s.downcase)
  end
  
  def number_to_running_time(seconds)
    seconds = seconds.to_i
    is_negative = seconds < 0
    seconds = seconds.abs
    return '0' unless seconds > 0
    hours   = seconds / 1.hour
    seconds = seconds % 1.hour
    minutes = seconds / 1.minute
    seconds = seconds % 1.minute
    (is_negative ? '-' : '') + (hours > 0 ? "#{hours}:" : '') + ('%02d:%02d' % [minutes, seconds])
  end  
end
