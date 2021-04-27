module Buildpack
  module Messaging
    def topic(message)
      self.puts "-----> #{message}"
    end
  end
end
