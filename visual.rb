require 'pry'


journies = Marshal::load File.read('/Users/will/Desktop/journies.bin')

processed = Hash.new

journies.each do |j|
  if (j[:start] - j[:finish]).abs < (60 * 60 * 20) && j[:start].hour >=9 && j[:finish].hour <= 21
    num = (j[:start].hour * 60 + j[:start].min) / 5
    num = num.to_i * 5
    processed[num] ||= Hash.new
    
    processed[num]["#{j[:from]}|#{j[:to]}"] ||= 0
    processed[num]["#{j[:to]}|#{j[:from]}"] ||= 0
    processed[num]["#{j[:from]}|#{j[:to]}"] += 1
    processed[num]["#{j[:to]}|#{j[:from]}"] += 1
  end
end

binding.pry
