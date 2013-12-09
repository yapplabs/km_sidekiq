# KmSidekiq

An interface for interacting with the KISSmetrics API via Sidekiq. Keeps all direct interactions with the KISSMetrics API out of your requests.

[![Build Status](https://secure.travis-ci.org/yapplabs/km_sidekiq.png)](http://travis-ci.org/yapplabs/km_sidekiq)

## Installation

Add this line to your application's Gemfile:

    gem 'km_sidekiq'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install km_sidekiq

Configure your API key:

    KmSidekiq.configure do |config|
      config.key = '<YOUR-KISSMETRICS-API-KEY>'
    end

## Usage

    KmSidekiq.alias(anonymous_id, user.id)
    KmSidekiq.record(user.id, 'signed_up', { :source => 'contest' })
    KmSidekiq.set(user.id, { :gender => 'F' })

## Running specs

    $ bundle exec rspec spec/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`); don't forget the specs!
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

KmResque originally written by Luke Melia. Adapted by Ray Cohen and Stefan Penner for Sidekiq. Inspiration from delayed_kiss and km-delay.

## License

km_sidekiq is available under the terms of the MIT License http://www.opensource.org/licenses/mit-license.php
