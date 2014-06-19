require 'oj'
require 'lock_method'
require 'json_select'

class JsonStore

  def initialize(db)
    @db = db
    @map = {}
  end

  def set(key, value)
    @map[key] = value
  end

  def get(key)
    @map[key]
  end

  def all
    @map
  end

  def all_as_json
    Oj.dump(@map)
  end

  def search(selector,kind=:matches)
    JSONSelect(selector).send(kind,@map)
  end

  def get_as_json(key)
    Oj.dump(@map[key])
  end

  def pull
    begin
      @map = read
    rescue LockMethod::Locked
      sleep 0.5
      pull
    end
  end

  def push
    begin
      write
    rescue LockMethod::Locked
      sleep 0.5
      push
    end
  end

  def merge(direction=:into_remote)
    begin
      direction == :into_local ? @map.merge!(read) : read.merge!(@map)
    rescue LockMethod::Locked
      sleep 0.5
      merge(direction)
    end
  end

  def as_lock
    'json_store'
  end

  private

  def read
    data = {}
    if File.exists?(@db)
      f = File.read(@db)
      data = Oj.load(f) unless f.empty?
    end
    data
  end

  lock_method :read

  def write
    File.open(@db, 'w') { |f| f.write(Oj.dump(@map)) }
  end

  lock_method :write

  def keep_trying

  end

end