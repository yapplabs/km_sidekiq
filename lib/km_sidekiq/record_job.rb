require 'km_sidekiq/api_client'
require 'sidekiq'

class KmSidekiq
  class RecordJob
    include Sidekiq::Worker
    sidekiq_options :queue => :km

    def perform(identifier, event_name, properties, timestamp)
      ApiClient.new.record(identifier, event_name, properties, timestamp.to_i)
    end
  end
end
