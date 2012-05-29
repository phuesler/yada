desc 'send test data'
task :send_test_data do
  require 'socket'

  socket = UDPSocket.new
  host = "127.0.0.1"
  port = "3333"
  events = ["message", "login", "loginError"]

  while true do
    random_index = rand(0..2)
    random_value = rand(0..1000)
    socket.send "#{events[random_index]}:#{random_value}", 0, host, port
    sleep(1)
  end
end
