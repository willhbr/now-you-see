require 'pry'


journies = Marshal::load File.read('/Users/will/Desktop/journies.bin')

processed = Hash.new

journies.each do |j|
  if (j[:start] - j[:finish]).abs < (60 * 60 * 20)
    num = (j[:start].hour * 60 + j[:start].min) / 5
    num = num.to_i * 5
    processed[num] ||= Hash.new
    
    processed[num]["#{j[:from]}|#{j[:to]}"] ||= 0
    processed[num]["#{j[:to]}|#{j[:from]}"] ||= 0
    processed[num]["#{j[:from]}|#{j[:to]}"] += 1
    processed[num]["#{j[:to]}|#{j[:from]}"] += 1
  end
end

sorted = Hash.new

processed.each do |k, v|
  processed[k] = v.map { |a, b| [b, a] }.sort { |la, lb| la[0] <=> lb[0] }
end


binding.pry
