# json_store

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
p db.get(:name)
db.merge
db.push
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

Search uses the json select gem (https://github.com/fd/json_select) and (http://jsonselect.org/#overview) to provide advanced searching capability.

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

