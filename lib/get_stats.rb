total_hits_by_ip = {}
File.open('log/production.log') do |file|
  for line in file
    if /Processing\s.*\(for/ =~ line
      ip = line.split.select{ |word| /\d+\.\d+\.\d+\.\d+/ =~ word }.first
      total_hits_by_ip[ip] = (total_hits_by_ip[ip]||0) + 1
    end
  end
end

puts "total users: #{total_hits_by_ip.size}"
total_hits_by_ip.sort{|a, b| b[1] <=> a[1]}.each do |elem|
  puts "#{elem[0]} : #{elem[1]}"
end
