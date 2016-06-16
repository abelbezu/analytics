module Analytics
  module Services
    class QueryService

      # specify an action (method and arguments with optional block) to perform on each session's session_events association and return the mapped values for each session
      # - Handles eager loading
      # - takes a block to send to the method if necessary
      #
      # Number of session events per session
      # QueryService.session_events_per_session(:length)
      # --> [12, 16, 1, 32] # of session events for each session
      #
      # List of session events with severity 3 for each session
      # QueryService.session_events_per_session(:select){|event| event.severity == 3}
      #
      # Count of session events with severity 3 for each session
      # QueryService.session_events_per_session(:select){|event| event.severity == 3}.map{|events| events.length}
      #
      # Average count of session events with severity 3 by session
      # counts = QueryService.session_events_per_session(:select){|event| event.severity == 3}.map{|events| events.length}
      # counts.reduce(:+).to_f / counts.length
      #
      # Percentage of sessions with ≥ severity 3 event
      # "#{QueryService.session_events_per_session(:select){|event| event.severity == 3}.select{|events| events.length > 0}.length * 100 / Session.count}%"
      #
      # List of sessions that a proctor has created a severity 1 event for
      # QueryService.session_events_per_session(:select){|event| event.proctor_id == 0 and event.severity == 1}.select{|events| events.length > 0}.map{|events| events.first.session}
      #
      # Average severity for session events by session
      # Analytics::Services::QueryService.session_events_by_sessions(:average, :severity).map{|s| s.to_f}
      def self.session_events_per_session(method, *args, &block)
        Analytics::Models::Session.includes(:session_events).all.map{|session| session.session_events.send method, *args, &block}
      end

      # specify an action (method and arguments) to perform on each session's session_events association and specify a block to map for each association
      # - handles eager loading
      # 
      # Get the mapped number of sessions events with severity 3 for each session
      # QueryService.session_events_by_sessions(:where, :severity => 3){|events| events.length}
      #
      # Get the average number of severity 3 session events events for each session
      # counts = QueryService.session_events_by_sessions(:where, :severity => 3){|events| events.length}
      # counts.reduce(:+).to_f / counts.length
      def self.session_events_by_sessions(method, *args, &block)
        session_events_per_session(method, *args).map &block
      end

      # Get the count of session events that match a set of criteria for each session
      #
      # Get number of session events with severity 3 for each session
      # QueryService.session_events_per_session_count(:select){|event| event.severity == 3}
      #
      # Get number of session events made by a specific proctor for each session
      # QueryService.session_events_per_session_count(:select){|event| event.proctor_id == 0}
      # - or -
      # QueryService.session_events_per_session_count(:select){|event| event.proctor_name == "foo"}
      #
      # Get number of severtiy 1 session events for a specific proctor
      # QueryService.session_events_per_session_count(:select){|event| event.proctor_id == 0 and event.severity == 1}
      def self.session_events_per_session_count(method, *args, &block)
        session_events_per_session(method, *args, &block).map{|events| events.length}
      end

      # Get the average count of session events that match a set of criteria for each session
      # method, args, and block are passed to session_events_per_session
      #
      # Example: Get Average count of session events with severity 3 per session
      # QueryService.session_events_per_session_count_average(:select){|event| event.severity == 3}
      # 
      # -- or prettier, but much more expensive:
      #    QueryService.session_events_per_session_count_average(:where, :severity => 3)
      def self.session_events_per_session_count_average(method, *args, &block)
        events = session_events_per_session(method, *args, &block).map{|events| events.length}
        events.reduce(:+).to_f / events.length
      end

      # Get a hash of session_id => Array of session_events for a specific proctor_id
      # -> session_id is a proctorserve session_id, not an analytics session_id
      def self.session_events_by_session_for_proctor(proctor_id)
        events = Analytics::Models::SessionEvent.includes(:session).where :proctor_id => proctor_id
        events_by_session = {}
        events.each { |event| (events_by_session[event.session.session_id] ||= []) << event }
        events_by_session
      end

      # Get the average distance between two session event types on a per session basis
      #
      # Average distance between session event types 2 and 3
      # QueryService.average_distance_between_session_event_types_per_session 2, 3
      # --> 19755.66 (made up data)
      def self.average_distance_between_session_event_types_per_session(type_a, type_b)
        timestamps = session_events_by_sessions(:where, :event_type => [type_a, type_b]).select do |events|
          types = events.map{|event| event.event_type}
          types.include? type_a and types.include? type_b
        end.map do |events|
          {:a => events.select{|event| event.event_type == type_a}.first, :b => events.select{|event| event.event_type == type_b}.first}
        end.map do |events|
          events[:b].timestamp - events[:a].timestamp
        end
        (timestamps.reduce(:+).to_f / timestamps.length).abs
      end
      
    end
  end
end