$:.push File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'km_sidekiq/record_job'

describe "KmSidekiq::RecordJob" do
  before do
    stub_request(:any, %r{http://trk.kissmetrics.com.*})
    KmSidekiq.configure do |config|
      config.key = "abc123"
    end
  end
  describe "perform" do
    subject do
      KmSidekiq::RecordJob.new
    end
    it "should hit the KM API" do
      timestamp = Time.now.to_i
      subject.perform("identifier", "eventName", { :foo => 'bar', :baz => 'bay'}, timestamp)
      expected_api_hit = "http://trk.kissmetrics.com/e?_d=1&_k=abc123&_n=eventName&_p=identifier&_t=#{timestamp}&baz=bay&foo=bar"
      WebMock.should have_requested(:get, expected_api_hit)
    end
    it "should succceed with no properties" do
      timestamp = Time.now.to_i
      subject.perform("identifier", "eventName", nil, timestamp)
      expected_api_hit = "http://trk.kissmetrics.com/e?_d=1&_k=abc123&_n=eventName&_p=identifier&_t=#{timestamp}"
      WebMock.should have_requested(:get, expected_api_hit)
    end
    it "should raise an error when no identity is provided" do
      timestamp = Time.now.to_i
      lambda {
        subject.perform(nil, "eventName", { :foo => 'bar', :baz => 'bay'}, timestamp)
      }.should raise_error(KmSidekiq::Error)
    end
    it "should raise an error when an invalid timestamp is provided" do
      timestamp = Time.now.to_i * 1000 # common mistake is providing milliseconds instead of seconds
      lambda {
        subject.perform("identifier", "eventName", { :foo => 'bar', :baz => 'bay'}, timestamp)
      }.should raise_error(KmSidekiq::Error)
    end
    it "should round off any decimal in timestamp" do
      now = Time.now
      timestamp_float = now.to_f
      timeStamp_int = now.to_i
      subject.perform("identifier", "eventName", { :foo => 'bar', :baz => 'bay'}, timestamp_float)
      expected_api_hit = "http://trk.kissmetrics.com/e?_d=1&_k=abc123&_n=eventName&_p=identifier&_t=#{timeStamp_int}&baz=bay&foo=bar"
      WebMock.should have_requested(:get, expected_api_hit)
    end
  end
end
