module ApplicationHelper
  def anti_language(key)
    key.split('.')[1..-1].join('.')
  end
  def cart_image
    count = current_cart.total_count
    if count > 0
      if count < 10
        image_tag "my_cart_#{count}.png"
      else
        image_tag 'my_cart_9p.png'
      end 
    else
      image_tag 'my_cart_e.png'
    end
  end
  def concatenate_or_skip(s1,s2,skip=nil)
    return skip if s1.nil?
    return skip if s2.nil?
    s1 + s2
  end
  def class_selection(s)
    #if s.instance_of? Symbol
    #  t(s) == @selection ? "selected" : ''
    #elsif s.instance_of? String
      s == @selection ? "selected" : ''
    #end
  end
  def get_html_language; english? ? :en : :fa end
  def listed_categories(categories)
    return if categories.empty?
    content_tag(:ul,categories.map{|cat,subcat|
      content_tag(:li,link_to(cat.name?(get_language),cat),:class=>class_selection(cat.name?(get_language))) + (subcat.present? ? content_tag(:li,listed_categories(subcat)) : '')
    }.join.html_safe,:class=>'nested_category')
  end

  def present(object,klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object,self)
    yield presenter if block_given?
    presenter
  end

  def jtime_ago_in_words(from_time, include_seconds = false)
    jdistance_of_time_in_words(from_time, Time.now, include_seconds)
  end 

  def jdistance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    I18n.with_options :locale => options[:locale], :scope => :'datetime.distance_in_words' do |locale|
      case distance_in_minutes
        when 0..1
          return distance_in_minutes == 0 ?
                 locale.t(:less_than_x_minutes, :count => 1) :
                 locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds

          case distance_in_seconds
            when 0..4   then locale.t :less_than_x_seconds, :count => 5
            when 5..9   then locale.t :less_than_x_seconds, :count => 10
            when 10..19 then locale.t :less_than_x_seconds, :count => 20
            when 20..39 then locale.t :half_a_minute
            when 40..59 then locale.t :less_than_x_minutes, :count => 1
            else             locale.t "x_minutes.one",           :count => 1
          end

        when 2..44           then locale.t "x_minutes.other",      :count => distance_in_minutes
        when 45..89          then locale.t "about_x_hours.one",  :count => 1
        when 90..1439        then locale.t "about_x_hours.other",  :count => (distance_in_minutes.to_f / 60.0).round
        when 1440..2519      then locale.t :x_days,         :count => 1
        when 2520..43199     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
        when 43200..86399    then locale.t :about_x_months, :count => 1
        when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
        else
          fyear = from_time.year
          fyear += 1 if from_time.month >= 3
          tyear = to_time.year
          tyear -= 1 if to_time.month < 3
          leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
          minute_offset_for_leap_year = leap_years * 1440
          # Discount the leap year days when calculating year distance.
          # e.g. if there are 20 leap year days between 2 dates having the same day
          # and month then the based on 365 days calculation
          # the distance in years will come out to over 80 years when in written
          # english it would read better as about 80 years.
          minutes_with_offset         = distance_in_minutes - minute_offset_for_leap_year
          remainder                   = (minutes_with_offset % 525600)
          distance_in_years           = (minutes_with_offset / 525600)
          if remainder < 131400
            if distance_in_years == 1
              locale.t("about_x_years.one",  :count => 1)
            else
              locale.t("about_x_years.other",  :count => distance_in_years)
            end
          elsif remainder < 394200
            locale.t(:over_x_years,   :count => distance_in_years)
          else
            locale.t(:almost_x_years, :count => distance_in_years + 1)
          end
      end
    end
  end
end
