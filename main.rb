require 'json'
require 'sqlite3'
require 'time'
require 'csv'
require 'pry'

def load_and_cache(data_path, cer_path, &block)
  if File.exists? cer_path
    data = Marshal::load File.read(cer_path)
    puts "Loaded cached data: #{cer_path}"
  else
    data = CSV.read(data_path)

    data = data[1..-1].map(&block)
    cereal = Marshal::dump data
    File.write(cer_path, cereal)
    puts "Wrote some shit from #{data_path}"
  end
  return data
end

config = JSON.parse File.read('config.json')

data = load_and_cache(config['data_path'], config['bin_path']) do |row|
  {
    date: Time.parse(row[1]),
    userid: row[2].to_i,
    pos: row[3].to_i
  }
end

data = data.sort { |a, b| a[:date] <=> b[:date] }

last_locations = Hash.new

folded = Array.new

data.each do |item|
  if last_locations[item[:userid]] != item[:pos]
    folded.push item
  end
  last_locations[item[:userid]] = item[:pos]
end

journies = Array.new
last_locations = Hash.new

folded.each do |item|
  last, time = last_locations[item[:userid]]
  if last == nil || time.day != item[:date].day
    last_locations[item[:userid]] = [item[:pos], item[:date]]
    next
  end

  journey = {
    to: item[:pos],
    from: last,
    start: time,
    finish: item[:date]
  }
  journies.push(journey)

  last_locations[item[:userid]] = [item[:pos], item[:date]]
end

File.write('/Users/will/Desktop/journies.bin', Marshal::dump(journies))

