require 'vpim/vpim'
require 'vpim/icalendar'
module ActsAsIcal
        def set_ical(ical)
          if ical.is_a? String
            ical = Vpim::Icalendar.decode(ical)[0]
          end
          self.raw_icalendar = ical.encode
        end
        def get_ical
          Vpim::Icalendar.decode(raw_icalendar)[0]
        end
        def events
          get_ical.events.to_a
        end
        def locations
          get_ical.events.to_a.map{|e| e.location}
        end
        private
        def rrule_to_s
        end
end
module Vpim
  class Icalendar
    class Vevent
      def instances(options = {})
        ranges = occurrences.map{|t| (t .. t + duration)}
        ranges.reject!{|r| r.begin > options[:range].end or r.end < options[:range].begin} if options[:range]
        ranges = ranges[0..options[:limit] -1] if options[:limit]
        return ranges
      end

      def weekly_ranges
        return [] unless rrule.weekly?
        ocs = occurences(dtstart + 7.days)
        ocs.map{|o| o .. o + duration}
      end

      def self.compact(vevents)
        by_loc = vevents.group_by(&:location)
        by_loc.map{|a| compact_times(a[1])}.flatten
      end
      def self.compact_times(vevents)
        vevents  #So maybe this can work eventually
      end
      def to_s(options = {})
        options[:show_location] ? location_string = ', ' + location : location_string = ''
        time_string + location_string
      end
      def time_string(strftime_options = {})
        strftime_options[:time] = strftime_options[:time] || "%I:%M%p"
        strftime_options[:date] = strftime_options[:date] || "%A, %B %d"
        time_i = dtstart.strftime(strftime_options[:time])
        time_f = dtend.strftime(strftime_options[:time])
        date_i = dtstart.strftime(strftime_options[:date])
        date_f = dtend.strftime(strftime_options[:date])

        days_string = rrule.to_s
        if days_string
          return days_string + " from #{time_i} to #{time_f}"
        end
        if same_day?
          return date_i + ", " + time_i + " to " + time_f
        else
          return date_i + " to " + date_f
        end
      end
      def same_day?
        dtstart.strftime("%A, %B %d") == dtend.strftime("%A, %B %d")
      end
    end
  end
  class Rrule
    def to_s(strftime_options = {})
      strftime_options[:date] = strftime_options[:date] || "%A"
      return "daily" if @freq == "DAILY"
      if @freq == "WEEKLY"
        if @by['BYDAY']
          return @by['BYDAY']
        else
          return @dtstart.strftime(strftime_options[:date]) + "s"
        end
      end
      return nil
    end
    def weekly?
      @freq == "WEEKLY"
    end
  end
end

