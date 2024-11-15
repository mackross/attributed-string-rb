# AttributedString

An attributed string implementation for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'attributed-string', github: 'mackross/attributed-string-rb', branch: 'main'
```


## Usage

🚧 This gem is a work in progress and the API may change before 1.0.

```ruby
  using AttributedString::Refinements
  hello_world1 = AttributedString.new('Hello, World!',  color: :red, font: 'Helvetica' )
  hello_world2 = 'Hello, World!'.to_attr_s(color: :red, font: 'Helvetica')
  puts hello_world1 == hello_world2 # true
```
