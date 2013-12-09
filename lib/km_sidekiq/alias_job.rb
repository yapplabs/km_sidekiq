require 'km_sidekiq/api_client'
require 'sidekiq'

class KmSidekiq
  class AliasJob
    include Sidekiq::Worker
    sidekiq_options :queue => :km

    def perform(identifier1, identifier2, timestamp)
      ApiClient.new.alias(identifier1, identifier2, timestamp.to_i)
    end
  end
end
