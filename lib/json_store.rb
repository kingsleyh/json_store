require 'oj'
require 'lock_method'
require 'json_select'

class JsonStore

  def initialize(db)
    @db = db
    @map = {}
    @json_opts = Oj.default_options
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

  def set_json_opts(options)
   @json_opts.merge!(options)
  end

  def get_json_opts
    @json_opts
  end

  def clear
    @map = {}
  end

  def all_as_json
    Oj.dump(@map,@json_opts)
  end

  def search(selector, kind=:matches)
    JSONSelect(selector).send(kind, @map)
  end

  def get_as_json(key)
    Oj.dump(@map[key],@json_opts)
  end

  def pull
    begin
      @map = read_data
    rescue LockMethod::Locked
      sleep 0.5
      pull
    end
  end

  def push
    begin
      write_data
    rescue LockMethod::Locked
      sleep 0.5
      push
    end
  end

  def merge(direction=:into_remote)
    begin
      @map = direction == :into_local ? @map.merge(read_data) : read_data.merge(@map)
    rescue LockMethod::Locked
      sleep 0.5
      merge(direction)
    end
  end

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
      f = File.read(@db)
      data = Oj.load(f) unless f.empty?
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