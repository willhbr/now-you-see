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

locations = load_and_cache(config['locations_path'], config['loc_bin_path']) do |row|
  {
    id: row[0].to_i,
    title: row[1],
    lat: row[2].to_f,
    long: row[3].to_f
  }
end

first_date = nil


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
  if last == nil
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
end

# CSV.open("/Users/will/Desktop/journies.csv", "wb") do |csv|
#   journies.each do |j|
#     csv << [j[:from], j[:to], j[:start], j[:finish]]
#   end
# end

db = SQLite3::Database.new "/Users/will/Desktop/journies.db"
db.execute "CREATE TABLE journies (`to`, `from`, `start`, `finish`);"

journies.each do |j|
  db.execute "INSERT INTO journies VALUES ('#{j[:from]}', '#{j[:to]}', '#{j[:start]}', '#{j[:finish]}')"
end

binding.pry
