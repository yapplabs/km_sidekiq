$:.push File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'km_sidekiq/set_job'

describe "KmSidekiq::SetJob" do
  before do
    stub_request(:any, %r{http://trk.kissmetrics.com.*})
    KmSidekiq.configure do |config|
      config.key = "abc123"
    end
  end
  describe "perform" do
    subject do
      KmSidekiq::SetJob.new
    end
    it "should hit the KM API" do
      timestamp = Time.now.to_i
      subject.perform("identifier", { :foo => 'bar', :baz => 'bay'}, timestamp)
      expected_api_hit = "http://trk.kissmetrics.com/s?_d=1&_k=abc123&_p=identifier&_t=#{timestamp}&baz=bay&foo=bar"
      WebMock.should have_requested(:get, expected_api_hit)
    end
    it "should round off any decimal in timestamp" do
      now = Time.now
      timestamp_float = now.to_f
      timeStamp_int = now.to_i
      subject.perform("identifier", { :foo => 'bar', :baz => 'bay'}, timestamp_float)
      expected_api_hit = "http://trk.kissmetrics.com/s?_d=1&_k=abc123&_p=identifier&_t=#{timeStamp_int}&baz=bay&foo=bar"
      WebMock.should have_requested(:get, expected_api_hit)
    end
  end
end
