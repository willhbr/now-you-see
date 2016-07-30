require 'json'
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


data = data.select { |item| item[:userid] == data[0][:userid] }.select do |item|
  unless first_date
    first_date = item[:date].to_date
  end
  first_date == item[:date].to_date
end

binding.pry
