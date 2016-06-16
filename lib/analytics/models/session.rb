module Analytics
  module Models
    class Session < ActiveRecord::Base
      # corresponding session_id in the primary database
      # attr_accessible :session_id

      # # ids corresponding to which subject this session belongs to in primary database, customer database, and customer_client database
      # attr_accessible :subject_id, :customer_subject_id, :customer_client_subject_id

      # # ids and handles to which customer and customer client this session belongs to in primary database
      # attr_accessible :customer_name, :customer_id, :customer_client_name, :customer_client_id

      # # session specific data
      # attr_accessible :session_duration, :exam_code, :reservation
      
      has_many :session_events, :class_name => 'Analytics::Models::SessionEvent'
    end
  end
end