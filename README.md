# Factree
[![Gem Version](https://badge.fury.io/rb/factree.svg)](https://rubygems.org/gems/factree)
[![Build Status](https://travis-ci.org/ConsultingMD/factree.svg?branch=master)](https://travis-ci.org/ConsultingMD/factree)
[![YARD Docs](https://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/gems/factree)

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

Factree provides tools for making choices based on a set of facts that are not yet known. You write a decision function that takes a set facts and returns a conclusion. Factree will run your function and make sure it has all of the facts it needs to complete. If any are missing, Factree will tell you what's needed to continue.

For example, say I want to pick an animal based on its attributes. First I'll write a function to make the decision.

```ruby
include Factree::DSL

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
path = find_path &decide

path.complete?
#=> false

path.required_facts
#=> [:mammal?]
```

`find_path` will run my `decide` function until it reaches a conclusion or asks for a fact that is unknown. In this case, my function checks `facts[:mammal?]` right off the bat, and since I didn't provide that fact, `find_path` stopped there. The path through my decision tree was incomplete.

Thankfully, `find_path` keeps track of all of the facts that are requested as it makes its way through a decision function. If it has to stop because a fact is unknown, the fact's name will be included in {Path.required_facts `required_facts`}. You can check `required_facts` to see exactly what's required to progress through the function.

Let's give `find_path` another try, this time with `mammal?: false`.

```ruby
path = find_path mammal?: false, &decide

path.complete?
#=> true

path.conclusion
#=> :turtle
```

This time `find_path` had all of the facts it needed to reach a conclusion, so it returned a complete path.

Supplying different values for facts may lead to a different path through the decision function, changing the facts that are required. For example, if `mammal?` is true, then we'll also need `herbivore?` to get to a conclusion.

```ruby
path = find_path mammal?: true, &decide

path.complete?
#=> false

path.required_facts
#=> [:mammal?, :herbivore?]
```

### Using `Factree::DSL`

Including {Factree::DSL `Factree::DSL`} in your code isn't mandatory. It just makes certain methods (like `find_path` and `conclusion`) easier to access. You can call the same methods on the {Factree `Factree`} module.

```ruby
Factree.find_path **facts, &decide

# is the same as

include Factree::DSL
find_path **facts, &decide
```

### Supplying facts

Factree is designed to work with decision functions that depend on many different facts. The {Factree::FactSource FactSource} mixin can help you organize them. A fact source class also provides a place for you to distill complex data into simple values, allowing you to keep your decision functions concise and readable.

Here's an example of a fact source that supplies a set of facts to help select a car for a buyer.

```ruby
class DriverFactSource
  include Factree::FactSource

  def initialize(person)
    @person = person
    freeze
  end

  def_fact(:needs_fast_car?) { @person.name == 'Ricky Bobby' }

  def_fact(:needs_cheap_car?) { @person.account_balance < 500.00 }

  def_fact(:needs_extra_seats?) do
    unknown if @person.family_size == :unknown

    @person.family_size > 4
  end
end
```

Our DriverFactSource is just a class with some method-like fact definitions. Let's instantiate it for a person and see how it works.

```ruby
Person = Struct.new(:name, :account_balance, :family_size)
tom = Person.new("Tom", 10_000.00, :unknown)
source = DriverFactSource.new(tom)
```

The source's primary job is to crank out a set of facts that can be fed into `find_path`.

```ruby
source.to_h
#=> {:needs_fast_car?=>false, :needs_cheap_car?=>false}
```

Two of the facts we defined are included, but you might have noticed that `:needs_extra_seats?` is missing. Since we're dealing with facts that might not be known, FactSource provides an easy way to conditionally omit those facts. Just call {Factree::FactSource#unknown `#unknown`} instead of returning a value, and the fact will be omitted from the collection returned by {Factree::FactSource#to_h `#to_h`}. Attempting to {Factree::FactSource#fetch `#fetch`} it will raise an error.

```ruby
source.fetch(:needs_extra_seats?)
# Factree::FactSource::UnknownFactError: unknown fact: needs_extra_seats?
```

### Organizing your decision functions

It's recommended that you define your decision functions in their own modules, particularly when they're large or complex. For example:

```ruby
module Decisions
  def self.decide_something(facts)
    # ...
  end
end
```

A method reference can be used to pass your decision function to `#find_path`.

```ruby
find_path **facts, &Decisions.method(:decide_something)
```

#### Splitting up large functions

Factree comes with a tool for splitting big decisions into separate functions to simplify them and make them independently testable. Take this cheese choice, for example.

```ruby
def choose_cheese(facts)
  if facts[:soft?]
    return conclusion :brie unless facts[:blue?]
    return conclusion :gorgonzola if facts[:cows_milk?]
    conclusion :brie
  else
    return conclusion :pecorino_toscano unless facts[:cows_milk?]
    return conclusion :emmental if facts[:holes?]
    conclusion :gruyere
  end
end
```

Say I wanted to split up my choice into separate functions for soft and hard cheeses. I can use {Factree.decide_between_alternatives `decide_between_alternatives`} to accomplish that.

```ruby
def choose_soft_cheese(facts)
  return unless facts[:soft?]

  return conclusion :brie unless facts[:blue?]
  return conclusion :gorgonzola if facts[:cows_milk?]
  conclusion :roquefort
end

def choose_hard_cheese(facts)
  return if facts[:soft?]

  return conclusion :pecorino_toscano unless facts[:cows_milk?]
  return conclusion :emmental if facts[:holes?]
  conclusion :gruyere
end

def choose_cheese(facts)
  decide_between_alternatives facts,
    method(:choose_soft_cheese),
    method(:choose_hard_cheese)
end
```

`decide_between_alternatives` will try each decision function in order. If the first returns `nil`, it will try the second, and so on, until a conclusion or an unknown fact is reached.

By splitting up my decision method into two separate ones, I've made them independently testable. They can also be reordered, and I've eliminated a level of nesting inside of a conditional statement.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Pull requests are welcome on GitHub at https://github.com/ConsultingMD/factree.

This library is pretty mature and not under active development, but we're happy
to discuss Github issues. Any active work will be tracked using a Grand Rounds
internal Jira project ("COREX" at the moment).

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
