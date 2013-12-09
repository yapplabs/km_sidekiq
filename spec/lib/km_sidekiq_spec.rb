$:.push File.expand_path('../lib', __FILE__)
require 'km_sidekiq'
require 'rspec-sidekiq'

Sidekiq::Testing.fake!

describe "KmSidekiq" do
  before do
    Time.stub(:now => Time.now)
    @timestamp = Time.now.to_i
  end
  describe "configuring" do
    it "should capture the API key" do
      KmSidekiq.configure do |config|
        config.key = "foo"
      end
      KmSidekiq.configuration.key.should == "foo"
    end
  end
  describe "alias" do
    it "should queue an AliasJob" do
      KmSidekiq.alias("identifier1", "identifier2")
      KmSidekiq::AliasJob.should have_enqueued_job("identifier1",
                                              "identifier2",
                                              @timestamp
                                              )
    end
  end
  describe "set" do
    it "should queue an SetJob" do
      KmSidekiq.set("identifier", {:some_prop => 'some_val'})
      KmSidekiq::SetJob.should have_enqueued_job("identifier",
                                            {'some_prop' => 'some_val'},
                                            @timestamp
                                            )
    end
  end
  describe "record" do
    it "should queue an RecordJob" do
      KmSidekiq.record("identifier", "myEventName", {:some_prop => 'some_val'})
      KmSidekiq::RecordJob.should have_enqueued_job("identifier",
                                               "myEventName",
                                               {'some_prop' => 'some_val'},
                                               @timestamp
                                               )
    end
  end
end
