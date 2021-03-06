# PLEASE NOTE - This project is not being actively maintained at the moment - I am taking a break - not sure when I will return.

# json_store

[![Build Status](https://travis-ci.org/kingsleyh/json_store.svg?branch=master)](https://travis-ci.org/kingsleyh/json_store)
[![Gem Version](https://badge.fury.io/rb/json_store.svg)](http://badge.fury.io/rb/json_store)
[![json_store downloads](http://www.gemetric.me/images/json_store.gif?1)](https://rubygems.org/gems/json_store)


Very simple key/value in memory database using json

## Install

```ruby
gem install json_store
```

## Usage

```ruby
require 'json_store'

db = JsonStore.new('names.db')
db.pull
db.set(:name,'Kingsley')
p db.get(:name # Kingsley)
db.merge
db.push

# if removing items use write instead of merge and push
db.pull
db.remove(:name)
db.write # write replaces file with in memory data
```

* Peristing more complex things like custom objects

```ruby

class Person

  def initialize(first,last)
    @first = first
    @last = last
  end

  def first
    @first
  end

  def last
    @last
  end

end

db = JsonStore.new('people')
db.pull
db.set(:person,Person.new('Kingsley','Hendrickse'))
db.push
p db.get(:person).first # Kingsley

```

There are only a handful of commands:

* pull
* push
* merge
* set
* get
* get_as_json
* search
* all
* all_as_json
* clear
* set_json_opts
* get_json_opts

The basic concept is that you create new db with the JsonStore.new and if the db is already a valid json file you can do pull to populate the in memory map. If no file exists then
one will be created.

* When you want to add to the db - you use set(key,value)
* When you want to push your data to file there are a couple of options - push or merge then push

## Merge and Push

calling push will replace the db on file with the current content of the local map. Calling merge will merge the file db with the current in memory map after which you can call push
to store the data. If you are happy to replace the db file with the content of your local map just use push. If you think there might be changes to the db file that you want before
overwriting the file - then call merge to get them and then ovewrite with push.

Merge has 2 possibilities - :into_local and :into_remote - the default is :into_remote  e.g.

```ruby
 db.merge(:into_local)
```

* :into_local will read the file content and then merge it into the local map - overwriting local changes with ones from file where the key is the same
* :into_remote will read the local map into the data from file - thus keeping any local changes and overwriting file items where the key is the same

## Get and Search

There are 2 ways to find data:

* Get
* Search

Get just finds a value by key e.g.

```ruby
   db.set(:name,'Kingsley')
   db.get(:name) # Kingsley
```

Search uses the json select gem (https://github.com/fd/json_select) and (http://jsonselect.org/#overview) to provide advanced searching capability. If you persist custom ruby objects however this
searching method will not work as it will only work with the standard json types. But then you can just use regular ruby to find things e.g. take, select, reject, find. sort_by etc

Read the documentation in the links above for a better idea how to use it - here is a simple example:

```ruby
  db.set(:names,[{id:1,name:'Kingsley'},{id:2,name:'Kostas'}])
  db.search('.names .name') # ['Kingsley','Kostas']
  db.search('.names .name',:match) # "Kingsley"
  db.search('.names object:last-child .name',:match) # "Kostas"
```

Search takes 2 parameters:  the selector and a match kind - which is set to :matches by default. The options are:

* :matches - returns an array of data - is the default
* :match - returns only the first match
* :test - returns true or false if there is a match

## Persisting Objects

When persisting objects - such as the Person class mentioned earlier - the default method of serialization used by Oj is :object. Which means it will expand the object into json format with an entry
containg an O to denote it's an object. Oj has several other notations for Array etc.

But if you want to have nicer json so you can use it elsewhere as a feed for example - you might prefer to use the :compat mode which looks for a to_json method on the object and uses that
to serialize it. So you can add your own to_json method. Please note that when retrieving data again it will be as hash/array data not the ruby custom object initially created -
because the :compat mode will force serialization to be the standard supported json - e.g. hash/arrays. If you want to persist objects and retrieve them then stick with the default
serialization. Here is an example of using compat:

```ruby
class Car

  attr_reader :doors,:wheels

  def initialize(doors,wheels)
   @doors = doors
   @wheels = wheels
  end

  def to_json
    puts %Q{ { "doors":#{@doors},"wheels",#{@wheels}} }
  end

end

db = JsonStore.new('cars')
db.set_json_opts(mode: :compat,indent: 2)
db.set(:cars,[Car.new(4,4),Car.new(2,3])
p db.all_as_json

```

## Contributing to json_store
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Kingsley Hendrickse. See LICENSE.txt for
further details.

