require 'spec_helper'
# require 'sidekiq/testing'

describe Analytics::Workers::SessionEventProcessor do
  describe "perform" do
    it "takes a hash of parameters and delegates creation of Session and SessionEvent instances to Analytics::Services::AuditService" do
      hash = { :session_id => 19, :customer_name => "basil", :customer_id => 5, :customer_client_name => 'cilantro', :customer_client_id => 9, :exam_code => 'thyme', :session_duration => 60, :severity => 3, :timestamp => Time.now.to_i, :event_type => 1 }
      event = Analytics::Workers::SessionEventProcessor.new.perform hash
      event.session.customer_name.should == "basil"
      event.event_type.should == 1
      event.proctor_name.should == nil
    end
    it "takes a hash of parameters including optional proctor info and delegates creation of Session and SessionEvent instances to Analytics::Services::AuditService" do
      hash = { :session_id => 19, :customer_name => "basil", :customer_id => 5, :customer_client_name => 'cilantro', :customer_client_id => 9, :exam_code => 'thyme', :session_duration => 60, :severity => 3, :timestamp => Time.now.to_i, :event_type => 1, :proctor_name => "paprika", :proctor_id => 15 }
      event = Analytics::Workers::SessionEventProcessor.new.perform hash
      event.session.customer_name.should == "basil"
      event.event_type.should == 1
      event.proctor_name.should == "paprika"
    end
  end
  describe "perform_async" do
    it "should try to create a sidekiq job when Analytics.active? is true" do
      hash = { :session_id => 19, :customer_name => "basil", :customer_id => 5, :customer_client_name => 'cilantro', :customer_client_id => 9, :exam_code => 'thyme', :session_duration => 60, :severity => 3, :timestamp => Time.now.to_i, :event_type => 1, :proctor_name => "paprika", :proctor_id => 15 }
      # If redis is running on localhost, this will work. if it is not, it will fail.
      Analytics::Workers::SessionEventProcessor.perform_async(hash).class.should == String
    end
    it "should not try to create a sidekiq job when Analytics.active? is true" do
      Analytics.active = false
      hash = { :session_id => 19, :customer_name => "basil", :customer_id => 5, :customer_client_name => 'cilantro', :customer_client_id => 9, :exam_code => 'thyme', :session_duration => 60, :severity => 3, :timestamp => Time.now.to_i, :event_type => 1, :proctor_name => "paprika", :proctor_id => 15 }
      Analytics::Workers::SessionEventProcessor.perform_async(hash).should == false
      Analytics.active = true
    end
  end
end