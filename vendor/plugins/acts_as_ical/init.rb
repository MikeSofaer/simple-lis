require 'acts_as_ical'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Icalendar)
