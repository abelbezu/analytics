require 'spec_helper'

TOTAL_NUM = 200

describe Analytics::Services::QueryService do
  before :all do
    [*1..TOTAL_NUM].each do
      Analytics::Services::AuditService.create_session_event_audit :severity => (Random.new.rand * 4).floor, :timestamp => Time.now.to_i + Random.new.rand * 100000, :event_type => (Random.new.rand * 16).floor, :proctor_id => (Random.new.rand * 4).floor, :proctor_name => (Random.new.rand * 4).floor > 1 ? "foo" : "bar", :session_id => (Random.new.rand * 40).floor, :customer_name => "customer", :customer_id => 15, :customer_client_name => "cusomter_client", :exam_code => "exam_code", :session_duration => 60, :reservation => Time.now.to_i
    end
  end

  describe "session_events_per_session" do
    it "takes a method, with an optional splat of arguments, and optional block" do
      Analytics::Services::QueryService.session_events_per_session(:count)
      Analytics::Services::QueryService.session_events_per_session(:where, :event_type => 3)
      Analytics::Services::QueryService.session_events_per_session(:select){|event| event.severity == 3}
    end
    it "reaches every session event" do
      Analytics::Services::QueryService.session_events_per_session(:count).reduce(:+).should == TOTAL_NUM
    end
  end

  describe "session_events_by_sessions" do
    it "takes a method, with an optional splat of arguments, and an optional map block" do
      Analytics::Services::QueryService.session_events_by_sessions(:where, :severity => 3){|events| events.length}
      Analytics::Services::QueryService.session_events_by_sessions(:class)
      Analytics::Services::QueryService.session_events_by_sessions(:where, :severity => 3)
    end
    it "sends a method and arguments to each session's session_events relation and maps the results using the block provided" do
      Analytics::Services::QueryService.session_events_by_sessions(:where, :severity => 3){|events| events.length}.should =~ Analytics::Models::Session.all.map{|session| session.session_events.where(:severity => 3).count}
    end
  end

  describe "session_events_per_session_count" do
    it "takes a method, with an optional splat of arguments, and optional block" do
      Analytics::Services::QueryService.session_events_per_session_count(:select){|event| event.severity == 3}.should =~ Analytics::Services::QueryService.session_events_per_session_count(:where, :severity => 3)
    end

    it "returns an array of the counts of session events for each session that meet a certain criteria" do
       Analytics::Services::QueryService.session_events_per_session_count(:where, :severity => 1).should =~ Analytics::Models::Session.all.map{|session| session.session_events.where(:severity => 1).count}
    end
  end

  describe "session_events_per_session_count_average" do
    it "takes a method, with an optional splat of arguments, and optional block" do
      Analytics::Services::QueryService.session_events_per_session_count_average(:select){|event| event.severity == 3}.should == Analytics::Services::QueryService.session_events_per_session_count_average(:where, :severity => 3)
    end

    it "returns the average count of the number of session events for each session that meet a certain criteria" do
      sev_1_events = Analytics::Models::Session.all.map{|session| session.session_events.where(:severity => 1).count}
      average = sev_1_events.reduce(:+).to_f / sev_1_events.length
      Analytics::Services::QueryService.session_events_per_session_count_average(:select){|event| event.severity == 1}.should == average
    end
  end

  describe "session_events_by_session_for_proctor(proctor_id)" do
    it "takes a proctor_id and returns a hash of session_ids mapped to arrays of associated session events with a given proctor" do
      sessions = Analytics::Services::QueryService.session_events_by_session_for_proctor(0)
      sessions.class.should == Hash
      sessions.map{|session, events| events}.flatten.should =~ Analytics::Models::SessionEvent.where(:proctor_id => 0)
    end
  end

  describe "average_distance_between_session_event_types_per_session(type_a, type_b)" do
    it "takes two types and returns the average distance between them for each session whose session events contain both" do
      average = Analytics::Services::QueryService.average_distance_between_session_event_types_per_session(0, 1)
      average.class.should == Float

      events_by_session = {}
      zeros = Analytics::Models::SessionEvent.where :event_type => 0
      ones = Analytics::Models::SessionEvent.where :event_type => 1
      (zeros | ones).each do |event|
        events_by_session[event.session_id] ||= {}
        events_by_session[event.session_id][event.event_type] ||= []
        events_by_session[event.session_id][event.event_type] << event
      end
      events_by_session.select! do |session, events|
        types = events.map{|type, events| events.first.event_type}
        types.include? 0 and types.include? 1
      end
      diffs_by_session = events_by_session.map{|session, events| events[0].first.timestamp - events[1].first.timestamp}
      average.should == (diffs_by_session.reduce(:+).to_f / diffs_by_session.length).abs
    end
  end

  it "has events" do
    Analytics::Models::SessionEvent.count.should == TOTAL_NUM
  end

end