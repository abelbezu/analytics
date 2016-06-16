module Analytics
  module Services
    class AuditService
      def self.find_or_create_session(params)
        session_params = params.select{|k,v| [:session_id, :customer_name, :customer_id, :customer_client_name, :customer_client_id, :exam_code, :session_duration, :subject_id, :customer_subject_id, :customer_client_subject_id].include? k}
        session = Analytics::Models::Session.where(session_params).first_or_create

        # update reservation, which may or may not have changed
        session.reservation = params[:reservation] and session.save if params[:reservation]

        session
      end

      # For a given set of session event data, find or create session and create a session event for it
      def self.create_session_event_audit(params)
        session = find_or_create_session params
        session_event_hash = params.select{|k,v| [:severity, :timestamp, :event_type, :proctor_id, :proctor_name].include? k}

        session.session_events.create session_event_hash
      end
    end
  end
end