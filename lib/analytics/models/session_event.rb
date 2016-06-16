module Analytics
  module Models
    class SessionEvent < ActiveRecord::Base
      # attr_accessible :proctor_id, :proctor_name, :severity, :timestamp, :event_type
      belongs_to :session, :class_name => 'Analytics::Models::Session'
    end
  end
end