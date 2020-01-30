# MBDB.rb

Read `.mbdb` files using Ruby.

The `.mbdb` file extension is associated with the Apple iTunes, the standard manage application for iOS devices. A `.mbdb` file contains a list of files, that are stored in the backup of the iOS device. The MB database was introduced in iTunes 9.2.

## Project Outlines

The project outlines as described in my blog post about [Open Source Software Collaboration](https://blog.fox21.at/2019/02/21/open-source-software-collaboration.html).

- The main purpose of this library is to provide an interface to Apple's MB database format using Ruby.
- The features should not go beyond Apple's features and functions. So the features of this software are limited to those of Apple.
- This list is open. Feel free to request features.

## Install

The preferred method of installation is via RubyGems.org:  
<https://rubygems.org/gems/mbdb>

```bash
gem install mbdb
```

or via `Gemfile`:

```ruby
gem 'mbdb', '~>0.1'
```

Use it in your sources:

```ruby
require 'mbdb'
```

## Project Links

- [Gem](https://rubygems.org/gems/mbdb)
