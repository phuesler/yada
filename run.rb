require 'sinatra'
require 'eventmachine'

# disable sinatra's autorun. We'll start it up
# in a separat thread later on
disable :run

class WebApp < Sinatra::Base

  # send the message to all connected clients
  def self.send_event(event = {:event => 'message', :data => 'test'})
    connections.each do |c|
      c << "event: #{event[:event]}\n"
      c << "data: #{event[:data]}\n\n"
    end
  end

  def self.connections
    @connections ||= []
  end

  get '/evented' do
    content_type 'text/event-stream'
    stream(:keep_open) do |out|
      WebApp.connections << out
    end
  end
end


class Handler < EM::Connection
  def receive_data(data)
    puts "Received event: #{data.inspect}"
    parsed_data = data.chomp.split(":") || 0
    if parsed_data.size == 2
      WebApp.send_event :event => parsed_data[0], :data => parsed_data[1]
    else
      puts "Could not parse data"
    end
  end
end

class UdpServer

  HOST = '127.0.0.1'
  PORT = '3333'

  def self.run
     EM::open_datagram_socket(HOST, PORT, Handler)
  end
end


# Start up sinatra and 
if __FILE__ == $PROGRAM_NAME
  EM.run do
    WebApp.run!
    UdpServer.run
    Signal.trap("INT")  { EventMachine.stop }
    Signal.trap("TERM") { EventMachine.stop }
  end
end
