# i18n-dot_lookup

[![Travis-CI](https://travis-ci.org/fnando/i18n-dot_lookup.png)](https://travis-ci.org/fnando/i18n-dot_lookup)
[![Code Climate](https://codeclimate.com/github/fnando/i18n-dot_lookup/badges/gpa.svg)](https://codeclimate.com/github/fnando/i18n-dot_lookup)
[![Test Coverage](https://codeclimate.com/github/fnando/i18n-dot_lookup/badges/coverage.svg)](https://codeclimate.com/github/fnando/i18n-dot_lookup/coverage)
[![Gem](https://img.shields.io/gem/v/i18n-dot_lookup.svg)](https://rubygems.org/gems/i18n-dot_lookup)
[![Gem](https://img.shields.io/gem/dt/i18n-dot_lookup.svg)](https://rubygems.org/gems/i18n-dot_lookup)

Ever wanted to get properties from an object, like `%{user.name}`? Now you can!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'i18n-dot_lookup'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n-dot_lookup

## Usage

```ruby
require 'i18n-dot_lookup'
require 'ostruct'

# You don't need to do this, but can use it to test on your console.
I18n.backend.store_translations :en, {hello: 'hello %{user.name}'}

# The user object will probably come from your database
I18n.t :hello, user: OpenStruct.new(name: 'john')
#=> hello john
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/i18n-dot_lookup. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

