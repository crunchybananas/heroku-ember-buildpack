module Buildpack
  module Shell
    def system(command)
      output = nil

      IO.popen(command) do |io|
        output = io.read
      end

      [output, $?]
    end

    def pipe(command, output_io = @output_io)
      IO.popen(command) do |io|
        while data = io.read(1)
          output_io.print data
        end
      end

      $?
    end

    def pipe_exit_on_error(command, output_io = @output_io, error_io = @error_io)
      status = pipe(command, output_io)
      if status.success?
        status
      else
        error_io.puts "Error running: #{command}" if error_io
        exit 1
      end
    end

    def command_success?(command)
      _, status = system(command)
      status.success?
    end

    def mktmpdir(name = "fetcher")
      tmpfile = Tempfile.new(name)
      dir = tmpfile.path
      tmpfile.unlink

      FileUtilsSimple.mkdir_p(dir)
      yield dir
    ensure
      FileUtilsSimple.rm_rf(dir) if File.exist?(dir)
    end
  end
end
