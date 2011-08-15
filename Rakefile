require 'bundler'
Bundler::GemHelper.install_tasks

desc 'send test data'
task :send_test_data do
  require 'socket'
  require 'JSON'
  socket = UDPSocket.new
  test_data = { 
      :type => 'counter',
      :name => 'usersOnline',
      :value => 1,
      :expiresInSeconds => 60
  }
  while(true)
   socket.send(JSON.generate(test_data), 0, '127.0.0.1', 3000)
   sleep(3)
  end
end
