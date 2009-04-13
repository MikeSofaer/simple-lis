require 'vpim/vpim'
require 'vpim/icalendar'
module ActiveRecord
  module Acts #:nodoc:
    module Icalendar #:nodoc:
      module ClassMethods
        def acts_as_ical
          include ActiveRecord::Acts::Icalendar::InstanceMethods
        end
      end

      module InstanceMethods
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
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end

