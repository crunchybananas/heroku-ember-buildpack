module Buildpack::Commands
  class Help
    def initialize(output_io, error_io)
      @output_io = output_io
      @error_io  = error_io
    end

    def run
      @output_io.puts Buildpack::CLI::USAGE
    end
  end
end
