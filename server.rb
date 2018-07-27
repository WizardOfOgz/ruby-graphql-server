require "socket"

port = ENV["PORT"] || 4444
server = TCPServer.new(port)

puts "Listening on port #{ port }..."

# Loop to handle incoming requests sequentially.
while session = server.accept
  request = session.gets

  puts request # Log the incoming request

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "\r\n"
  session.print "OK\r\n"

  session.close
end
