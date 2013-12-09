require 'km_sidekiq/api_client'
require 'sidekiq'

class KmSidekiq
  class SetJob
    include Sidekiq::Worker
    sidekiq_options :queue => :km

    def perform(identifier, properties, timestamp)
      ApiClient.new.set(identifier, properties, timestamp.to_i)
    end
  end
end
