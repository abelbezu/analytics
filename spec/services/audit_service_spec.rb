require 'spec_helper'

describe Analytics::Services::AuditService do
  describe "find_or_create_session" do
    it "creates a session if one doesn't exist" do
      hash = { :session_id => 713, :customer_name => "nano", :customer_id => 15, :customer_client_name => 'technology', :customer_client_id => 5, :exam_code => 'is_pretty_cool', :session_duration => 60 }
      s = Analytics::Models::Session.where(hash).first
      s.should == nil
      s = Analytics::Services::AuditService.find_or_create_session hash
      s.session_id.should == 713
    end
    it "returns an existing session if it already exists" do
      hash = { :session_id => 714, :customer_name => "public", :customer_id => 4, :customer_client_name => 'address', :customer_client_id => 18, :exam_code => 'system', :session_duration => 60 }
      a = Analytics::Services::AuditService.find_or_create_session hash
      b = Analytics::Services::AuditService.find_or_create_session hash
      a.should == b
    end
    it "updates reservation for an existing session" do
      hash = { :session_id => 714, :customer_name => "public", :customer_id => 4, :customer_client_name => 'address', :customer_client_id => 18, :exam_code => 'system', :session_duration => 60, :reservation => Time.now.to_i - 1000 }
      a = Analytics::Services::AuditService.find_or_create_session hash
      hash[:reservation] = Time.now.to_i
      b = Analytics::Services::AuditService.find_or_create_session hash
      a.id.should == b.id
      a.reservation.should_not == b.reservation
    end
  end
  describe "create_session_event_audit" do
    it "creates a session if one does not exist and creates a session event for it" do
      Analytics::Models::Session.find_by_customer_name("pearson") == nil
      s = Analytics::Services::AuditService.create_session_event_audit :session_id => 1, :customer_name => "pearson", :customer_id => 2, :customer_client_name => 'avaya', :customer_client_id => 5, :exam_code => 'abc-123', :session_duration => 60, :severity => 1, :timestamp => Time.now.to_i, :event_type => 8
      Analytics::Models::Session.find_by_customer_name("pearson").class.should == Analytics::Models::Session
    end
  end
end