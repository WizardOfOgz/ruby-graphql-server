$:.unshift File.dirname(__FILE__)
require 'bundler/setup'
require "socket"
require "json"
require "graphql"
require "schema"

def parse_headers(session)
  # Thanks StackOverflow
  {}.tap do |headers|
    while line = session.gets                           # Collect HTTP headers
      line = line.split(' ', 2)
      break if line[0] == ""                            # Blank line means no more headers
      headers[line[0].chop] = line[1].strip             # Hash headers by type
    end
  end
end


### Start server

port = ENV["PORT"] || 4444
socket = TCPServer.new(port)

puts "Listening on port #{ port }..."

# Loop to handle incoming requests sequentially.
while session = socket.accept
  request = session.gets
  puts "\n#{ request }"  # Log the incoming request

  headers = parse_headers(session)
  puts "Headers:\n#{ headers.map{|k,v| "#{ k }: #{ v }"  }.join("\n") }"

  # Read the request body
  content_length = headers["Content-Length"].to_i
  body = session.read(content_length)

  # We only accept JSON
  params = JSON.parse(body)

  # Run the query
  query = params["query"]
  puts "Processing GraphQL document:\n#{ query }"
  result = Schema.execute(query)

  puts result.to_json

  # Response
  session.print "HTTP/1.1 200 OK\r\n"
  session.print "Content-Type: application/json\r\n"
  session.print "\r\n"
  session.print result.to_json
  puts "\n=> Completed 200 OK"

  session.close
end
