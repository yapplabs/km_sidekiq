$:.push File.expand_path('../lib', __FILE__)
require 'km_sidekiq'
require 'rspec-sidekiq'

describe "KmSidekiq" do
  before do
    Time.stub(:now => Time.now)
    @prior_timestamp = Time.now.to_i-(60 * 60 * 24)
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
    it "should queue an AliasJob with current time" do
      KmSidekiq.alias("identifier1", "identifier2")
      KmSidekiq::AliasJob.should have_enqueued_job("identifier1",
                                              "identifier2",
                                              @timestamp
                                              )
    end
  end
  describe "set" do
    it "should queue a SetJob with current time" do
      KmSidekiq.set("identifier", {:some_prop => 'some_val'})
      KmSidekiq::SetJob.should have_enqueued_job("identifier",
                                            {'some_prop' => 'some_val'},
                                            @timestamp
                                            )
    end
  end
  describe "record" do
    it "should queue a RecordJob with current time" do
      KmSidekiq.record("identifier", "myEventName", {:some_prop => 'some_val'})
      KmSidekiq::RecordJob.should have_enqueued_job("identifier",
                                               "myEventName",
                                               {'some_prop' => 'some_val'},
                                               @timestamp
                                               )
    end
  end
  describe "alias" do
    it "should queue an AliasJob with arbitrary timestamp" do
      KmSidekiq.alias("identifier1", "identifier2", @prior_timestamp)
      KmSidekiq::AliasJob.should have_enqueued_job("identifier1",
                                              "identifier2",
                                              @prior_timestamp
                                              )
    end
  end
  describe "set" do
    it "should queue a SetJob with arbitrary timestamp" do
      KmSidekiq.set("identifier", {:some_prop => 'some_val'}, @prior_timestamp)
      KmSidekiq::SetJob.should have_enqueued_job("identifier",
                                            {'some_prop' => 'some_val'},
                                            @prior_timestamp
                                            )
    end
  end
  describe "record" do
    it "should queue a RecordJob with arbitrary timestamp" do
      KmSidekiq.record("identifier", "myEventName", {:some_prop => 'some_val'}, @prior_timestamp)
      KmSidekiq::RecordJob.should have_enqueued_job("identifier",
                                               "myEventName",
                                               {'some_prop' => 'some_val'},
                                               @prior_timestamp
                                               )
    end
  end
end
