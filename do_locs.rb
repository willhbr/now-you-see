
require 'json'

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

locations = load_and_cache(config['locations_path'], config['loc_bin_path']) do |row|
  {
    id: row[0].to_i,
    title: row[1],
    lat: row[2].to_f,
    long: row[3].to_f
  }
end

locs_by_id = Hash.new

locations.each do |loc|
  locs_by_id[loc[:id]] = loc
end

File.write('locations.json', locs_by_id.to_json)
