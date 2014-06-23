require 'rspec'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/json_store'

describe JsonStore do

  it 'should populate the memory map from file on pull' do
    db = JsonStore.new(File.dirname(__FILE__) + '/test_data/test1.json')
    db.pull
    expect(db.all).to eq({'name' => 'Kingsley'})
  end

  it 'should create new db if none already exists during push' do
    db = create_new_db('test2.json')
    expect(File.exists?(db.db_path)).to eq(true)
  end

  it 'should replace file with memory map on push overwriting same keys in file with map data' do
    db = create_new_db('test2.json')
    expect(db.all).to eq({name: 'Kingsley'})
    db.set(:name, 'Kostas')
    db.set(:slot, 'PM')
    db.push
    db.pull
    expect(db.all).to eq({name: 'Kostas', slot: 'PM'})
  end

  it 'should merge memory map changes into file on merge into_remote' do
    db = create_new_db('test2.json')
    expect(db.all).to eq({name: 'Kingsley'})
    db.set(:name, 'Kostas')
    db.set(:slot, 'PM')
    db.merge
    expect(db.all).to eq({name: 'Kostas', slot: 'PM'})
  end

  it 'should merge file changes into memory map on merge into_local' do
    db = create_new_db('test2.json')
    expect(db.all).to eq({name: 'Kingsley'})
    db.set(:name, 'Kostas')
    db.set(:slot, 'PM')
    db.merge(:into_local)
    expect(db.all).to eq({name: 'Kingsley', slot: 'PM'})
  end

  it 'should get value by by key of stored items' do
    db = JsonStore.new(File.dirname(__FILE__) + '/test_data/test1.json')
    db.pull
    expect(db.get('name')).to eq('Kingsley')
  end

  it 'should return json on get_as_json' do
    db = JsonStore.new(File.dirname(__FILE__) + '/test_data/test1.json')
    db.pull
    expect(db.get_as_json('name')).to eq('"Kingsley"')
  end

  it 'should return json on all_as_json' do
    db = JsonStore.new(File.dirname(__FILE__) + '/test_data/test1.json')
    db.pull
    expect(db.all_as_json).to eq('{"name":"Kingsley"}')
  end

  it 'should search basic json structure using json select' do
    db = create_new_db('test2.json', {people: [{first_name: 'Kingsley', last_name: 'Hendrickse'}, {first_name: 'Kostas', last_name: 'Mamalis'}]})
    expect(db.search('.people .first_name')).to eq(['Kingsley', 'Kostas'])
    expect(db.search('.people .first_name', :match)).to eq('Kingsley')
    expect(db.search('.people .first_name', :test)).to eq(true)
  end

  it 'should be able to store a more complex object' do
    class Person;
      attr_accessor :first_name, :last_name;

      def initialize(name)
        ; d = name.split(' '); @first_name = d.first; @last_name = d.last;
      end

      ;
    end
    db = create_new_db('test2.json', {people: [Person.new('Kingsley Hendrickse'), Person.new('Kostas Mamalis')]})
    expect(db.get(:people).map { |person| person.first_name }).to eq(['Kingsley', 'Kostas'])
  end

  it 'should clear the in memory map' do
    db = create_new_db('test2.json')
    db.clear
    expect(db.all).to eq({})
  end

  it 'should work with simple scenario' do
    db = create_new_db('test2.json')
    data = {day: 'Mon', year: '2014'}
    db.set(:date, data)
    db.push
    expect(db.get(:date)).to eq(data)
    db2 = JsonStore.new(File.dirname(__FILE__) + '/test_data/test2.json')
    db2.pull
    db2.set(:slot, 'PM')
    db2.push
    db.merge
    expect(db.all).to eq(name: 'Kingsley', date: {day: 'Mon', year: '2014'}, slot: 'PM')
  end

  it 'should lock to prevent concurrent access' do
    t1 = Thread.new {
      20.times{
      db = create_new_db('test3.json')
      db.set(:slot, "1_PM")
      db.merge
      db.push
      }
    }
    t2 = Thread.new {
      20.times {
      db = create_new_db('test3.json')
      db.set(:slot, "2_PM")
      db.merge
      db.push
      }
    }
    t2.join
    t1.join
    db2 = JsonStore.new(File.dirname(__FILE__) + '/test_data/test3.json')
    db2.pull
    expect(db2.get(:slot)).to match(/PM/)

  end

  private

  def create_new_db(path, content={name: 'Kingsley'})
    file_path = File.dirname(__FILE__) + "/test_data/#{path}"
    FileUtils.rm_rf(file_path)
    db = JsonStore.new(file_path)
    db.set(content.keys.first, content[content.keys.first])
    db.push
    db
  end

end