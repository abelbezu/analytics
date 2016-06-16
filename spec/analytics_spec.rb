require 'spec_helper'

describe Analytics do
  describe Analytics::Models do
    it "has a Session model" do
      Analytics::Models::Session
    end
    it "has a SessionEvent model" do
      Analytics::Models::SessionEvent
    end
  end
  describe Analytics::Services do
    it "has an AuditService class" do
      Analytics::Services::AuditService
    end
    it "has a QueryService class" do
      Analytics::Services::QueryService
    end
  end
  describe Analytics::Workers do
    it "has a SessionEventProcessor worker class" do
      Analytics::Workers::SessionEventProcessor
    end
  end
  it "defaults to active" do
    Analytics.active?.should == true
  end
  it "can be made inactive" do
    Analytics.active = false
    Analytics.active?.should == false
    Analytics.active = true
    Analytics.active?.should == true
  end
end