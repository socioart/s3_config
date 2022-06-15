# S3Config

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_config'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install s3_config

## Usage

    config = YAML.load_file("#{Rails.root}/config/s3.yml").fetch(Rails.env)
    s3_config = S3Config.load(config)

    s3_config.create_client # returns instance of Aws::S3::Client

    # for carrierwave
    CarrierWave.configure do |c|
      c.fog_credentials = s3_config.to_fog_credentials
      c.fog_directory = config.bucket
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/s3_config.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
