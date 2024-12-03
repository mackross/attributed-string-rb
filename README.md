# AttributedString

An attributed string implementation for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'attributed-string', github: 'instruct-rb/attributed-string', branch: 'main'
```


## Usage

🚧 This gem is a work in progress and the API may change before 1.0.

```ruby
  using AttributedString::Refinements
  hello_world1 = AttributedString.new('Hello, World!',  color: :red, font: 'Helvetica' )
  hello_world2 = 'Hello, World!'.to_attr_s(color: :red, font: 'Helvetica')
  puts hello_world1 == hello_world2 # true
```

## Attachments

```ruby
  hello_world = AttributedString.new('Hello, World!')
  hello_world.add_attachment("any ruby object", position: string.length)
  puts hello_world # => "Hello, World! "
  puts hello_world.attachments # => ["any ruby object"]
  hello_world[-1..-1] = ''
  puts hello_world.attachments # => []
```
