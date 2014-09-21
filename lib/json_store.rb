require 'oj'
require 'lock_method'
require 'json_select'


# JsonStore is a simple key/value database in which key/values are stored in json format
# The basic concept is to pull data into an in memory map and then set or get data and push the data to file.
# You can also merge in 2 different ways to decide how you want to use the data coming from file or the map
# file locking is handled by the lock_method gem to prevent concurrent access when reading and writing
class JsonStore

  # Creates a new store at the path/filename provided to the constructor
  # e.g. db = JsonStore.new('path/to/some/file.json')
  def initialize(db)
    @db = db
    @map = {}
    @json_opts = Oj.default_options
  end

  # Sets data into the memory map by key/value
  # e.g db.set('name','Kingsley')
  def set(key, value)
    @map[key] = value
  end

  # Gets data from the memory map by key
  # e.g. db.get('name')
  def get(key)
    @map[key]
  end

  # Removes the data from memory map by key
  # e.g. db.remove('name')
  def remove(key)
   @map.delete(key)
  end

  # Writes the in memory data to file by replacing file
  def write
   write_data
  end

  # Returns the whole memory map
  def all
    @map
  end

  # Replaces the memory map with some json directly
  def set_json(json)
    @map = Oj.load(json)
  end

  # Sets the Oj json parser options by overriding defaults. See Oj josn parser docs for more details.
  def set_json_opts(options)
   @json_opts.merge!(options)
  end

  # Lists the Oj json parser options that have been set
  def get_json_opts
    @json_opts
  end

  #�Clears the memory map
  def clear
    @map = {}
  end

  # Returns the whole memory map as a json string
  def all_as_json
    Oj.dump(@map,@json_opts)
  end

  # Uses the ruby gem for JSONSelect to search basic json. (doesn't work on ruby objects stored as json by Oj :object mode)
  # See the JSONSelect website / json_select ruby gem docs for more details
  def search(selector, kind=:matches)
    JSONSelect(selector).send(kind, @map)
  end

  # Gets data from the memory map by key but as a json string
  def get_as_json(key)
    Oj.dump(@map[key],@json_opts)
  end

  # Pulls data from file into the memory map - replacing the memory map with the data from file.
  def pull
    begin
      @map = read_data
    rescue LockMethod::Locked
      sleep 0.5
      pull
    end
  end

  # Pushes the data in the memory map to file
  def push
    begin
      write_data
    rescue LockMethod::Locked
      sleep 0.5
      push
    end
  end

  # Merges the data in 2 ways
  # 1. db.merge(:into_remote) is the default and will merge data from the memory map into data from file and assign the result to the memory map
  # 2. db.merge(:into_local) will merge data from file into the memory map and assign the result to the memory map.
  # into_remote will essentially load the memory map data into the file data thus overwriting the file data with the memory map data where the keys match
  # into_local will essentially merge the file data into the memory map thus overwriting the memory map data with the file data where the keys match
  def merge(direction=:into_remote)
    begin
      @map = direction == :into_local ? @map.merge(read_data) : read_data.merge(@map)
    rescue LockMethod::Locked
      sleep 0.5
      merge(direction)
    end
  end

  # Get the path to the datastore json file
  def db_path
    @db
  end

  private

  def as_lock
    'json_store'
  end

  def read_data
    data = {}
    if File.exists?(@db)
      f = File.open(@db)
      begin
      data = Oj.load(f)
      rescue => e
       puts "WARNING: #{e}"
      end
    end
    data
  end

  lock_method :read_data

  def write_data
    f = File.new(@db, 'w')
    f.write(Oj.dump(@map,@json_opts))
    f.close
  end

  lock_method :write_data


end