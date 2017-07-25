# Factree
[![Gem Version](https://badge.fury.io/rb/factree.svg)](https://rubygems.org/gems/factree)
[![Build Status](https://travis-ci.org/ConsultingMD/factree.svg?branch=master)](https://travis-ci.org/ConsultingMD/factree)

Have a complicated decision to make? Factree will guide you through it step by step, identifying exactly which questions you need to answer along the way in order to reach a conclusion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factree

## Usage

*For details, check out the [API documentation](http://www.rubydoc.info/gems/factree).*

### Finding paths through a decision function

Factree provides tools for making choices based on a set of facts that are not yet known. You write a decision function that takes a set facts and returns a conclusion. Factree will run your function and make sure it has all of the facts it needs to complete. If any facts are missing, Factree will tell you what's needed to continue.

For example, say I want to pick an animal based on its attributes. First I'll write a function to make the decision.

```ruby
decide = ->(facts) do
  return conclusion :turtle unless facts[:mammal?]

  if facts[:herbivore?]
    conclusion :rabbit
  else
    conclusion :dog
  end
end
```

Then I'll pass that function to {Factree.find_path `find_path`} without any facts.

```ruby
path = Factree.find_path &decide

path.complete?
#=> false

path.required_facts
#=> [:mammal?]
```

`find_path` will run my `decide` function until it reaches a conclusion or asks for a fact that is unknown. In this case, my function checks `facts[:mammal?]` right off the bat, and since I didn't provide that fact, `find_path` stopped right there. The path through my decision tree was incomplete.

Thankfully, `find_path` keeps track of all of the facts that are requested as it makes its way through a decision function. If it has to stop because a fact is unknown, the fact's name will be included in {Path.required_facts `required_facts`}. You can check `required_facts` to see exactly what's required to progress through the function.

Let's give `find_path` another try, this time with `mammal?: false`.

```ruby
path = Factree.find_path mammal?: false, &decide

path.complete?
#=> true

path.conclusion
#=> :turtle
```

This time `find_path` had all of the facts it needed to reach a conclusion, so it returned a complete path.

Supplying different values for facts may lead to a different path through the decision function, changing the facts that are required. For example, if `mammal?` is true, then we'll also need `herbivore?` to get to a conclusion.

```ruby
path = Factree.find_path mammal?: true, &decide

path.complete?
#=> false

path.required_facts
#=> [:mammal?, :herbivore?]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ConsultingMD/factree.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
