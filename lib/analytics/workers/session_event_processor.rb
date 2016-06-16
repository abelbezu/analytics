module Analytics
  module Workers
    class SessionEventProcessor
      include Sidekiq::Worker

      def self.perform_async(*args)
        return super if Analytics.active?
        false
      end
      
      # SessionEventProcessor.perform *requires* a hash with keys:
      #     "session_id", "customer_name", "customer_id", "customer_client_name", "customer_client_id", "exam_code",
      #     "session_duration", "reservation", "severity", "timestamp", "event_type", "subject_id", "customer_subject_id", and "customer_client_subject_id"
      # with optional parameters:
      #     "proctor_id", "proctor_name"
      #
      # NB! When updating the parameters required by this method (through the AuditService), be sure to
      # update the corresponding sidekiq call in proctorserv (app/models/session_event.rb#save_as_audit) to pass those parameters
      #
      # It will find or create a session based on the parameters and create an associated session event for it.
      def perform(params)
        params.symbolize_keys!

        event = Analytics::Services::AuditService.create_session_event_audit params
        Sidekiq.logger.info "Processed session event #{event.id} with params: #{params}"
        event
      end
    end
  end
end