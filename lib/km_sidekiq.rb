require "km_sidekiq/version"
require "km_sidekiq/configuration"
require "km_sidekiq/alias_job"
require "km_sidekiq/set_job"
require "km_sidekiq/record_job"

class KmSidekiq
  class Error < RuntimeError; end
  def self.configure(&block)
    yield configuration
  end
  def self.configuration
    @configuration ||= Configuration.new
  end
  def self.alias(identifier1, identifier2, timestamp=Time.now.to_i)
    Sidekiq::Client.enqueue(AliasJob, identifier1, identifier2, timestamp)
  end
  def self.set(identifier, properties, timestamp=Time.now.to_i)
    Sidekiq::Client.enqueue(SetJob, identifier, properties, timestamp)
  end
  def self.record(identifier, eventName, properties, timestamp=Time.now.to_i)
    Sidekiq::Client.enqueue(RecordJob, identifier, eventName, properties, timestamp)
  end
end
