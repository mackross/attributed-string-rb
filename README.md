# AttributedString

An attributed string implementation for Ruby.

An attributed string contains key-value pairs known as attributes that specify additional information related to ranges of characters within the string. Attributed strings support any key-value pair, but are often used for: 

- Rendering attributes such as font, color,  and other details.
- Attributes for inline-attachments such as images, videos, files, etc. 
- Semantic attributes such as link URLs or tool-tip information
- Language attributes to support automatic gender agreement or verb agreement. 
- Accessibility attributes that provide information for assistive technologies
- Custom attributes you define

You will typically need to create a presenter for an attributed string, as the default shows no attribute information and inspect shows all attributes. 

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
