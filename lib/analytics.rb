require_relative "analytics/version"

module Analytics
  @@active = true

  def self.active?
    @@active
  end

  def self.active=(active)
    @@active = active
  end

  module Models
    autoload :Session,      "analytics/models/session"
    autoload :SessionEvent, "analytics/models/session_event"
  end

  module Services
    autoload :AuditService, "analytics/services/audit_service"
    autoload :QueryService, "analytics/services/query_service"
  end

  module Workers
    autoload :SessionEventProcessor, "analytics/workers/session_event_processor"
  end

end