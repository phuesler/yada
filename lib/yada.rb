require 'em-websocket'

module Yada
  class Server
    class UdpConnection < EventMachine::Connection
      
      MESSAGE_DELIMITER = "\r\n"

      def initialize(*args)
        @server = args[0]
        super *args
      end

      def receive_data(data)
        if data && data.size > 0
          @server.channel.push("#{data}#{MESSAGE_DELIMITER}")
        end
      end
    end

    def self.run
      new.run
    end

    def run
      EventMachine.run {
        @channel = EM::Channel.new

        EventMachine::open_datagram_socket("127.0.0.1", 3000, UdpConnection, self)

        EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |ws|

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

    def channel
      @channel
    end
  end
end

Yada::Server.run
