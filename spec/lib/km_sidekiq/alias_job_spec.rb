$:.push File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'km_sidekiq/alias_job'

describe "KmSidekiq::AliasJob" do
  before do
    stub_request(:any, %r{http://trk.kissmetrics.com.*})
    KmSidekiq.configure do |config|
      config.key = "abc123"
    end
  end
  describe "perform" do
    subject do
      KmSidekiq::AliasJob.new
    end
    it "should hit the KM API" do
      timestamp = Time.now.to_i
      subject.perform("identifier1", "identifier2", timestamp)
      expected_api_hit = "http://trk.kissmetrics.com/a?_d=1&_k=abc123&_n=identifier2&_p=identifier1&_t=#{timestamp}"
      WebMock.should have_requested(:get, expected_api_hit)
    end
    it "should round off any decimal in timestamp" do
      now = Time.now
      timestamp_float = now.to_f
      timeStamp_int = now.to_i
      subject.perform("identifier1", "identifier2", timestamp_float)
      expected_api_hit = "http://trk.kissmetrics.com/a?_d=1&_k=abc123&_n=identifier2&_p=identifier1&_t=#{timeStamp_int}"
      WebMock.should have_requested(:get, expected_api_hit)
    end
  end
end
