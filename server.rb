require "socket"
require "json"

port = ENV["PORT"] || 4444
server = TCPServer.new(port)

puts "Listening on port #{ port }..."

data = {
  users: %w[Bob Fred Mary]
}

# Loop to handle incoming requests sequentially.
while session = server.accept
  request = session.gets

  puts request # Log the incoming request

  # Response
  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: application/json\r\n"
  session.print "\r\n"
  session.print data.to_json

  session.close
end
