require 'em-websocket'

module Yada
  class Server
    def self.run
      EventMachine.run {
        @channel = EM::Channel.new

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|

         timer = EventMachine::PeriodicTimer.new(5) do
          @channel.push 'yada yada yada'
         end

          ws.onopen {
            sid = @channel.subscribe{|msg| ws.send msg}

            ws.onclose {
              @channel.unsubscribe(sid)
            }

          }
        end

        puts "Server started"
      }
   end
  end
end

Yada::Server.run
