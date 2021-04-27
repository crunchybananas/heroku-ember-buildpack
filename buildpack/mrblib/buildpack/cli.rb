module Buildpack
  module Commands; end

  class CLI
    include Commands

    USAGE = <<USAGE
EmberJS Buildpack

Usage:
  buildpack detect <build-dir>
  buildpack compile <build-dir> <cache-dir> <env-dir>
  buildpack release <build-dir>
  buildpack test-compile <build-dir> <cache-dir> <env-dir>
  buildpack test <build-dir> <env-dir>
  buildpack (-v | --version)
  buildpack (-h | --help)
USAGE
    def initialize(argv, output_io, error_io)
      @options   = Docopt.parse(USAGE, argv)
      @output_io = output_io.instance_eval do
        extend Buildpack::Messaging
      end
      @error_io  = error_io.instance_eval do
        extend Buildpack::Messaging
      end
    end

    def run
      if Version.detect(@options)
        Version.new(@output_io, @error_io).run
      elsif Detect.detect(@options)
        Detect.new(@output_io, @error_io, @options["<build-dir>"]).run
      elsif Compile.detect(@options)
        Compile.new(@output_io, @error_io, @options["<build-dir>"], @options["<cache-dir>"], @options["<env-dir>"]).run
      elsif Release.detect(@options)
        Release.new(@output_io, @error_io, @options["<build-dir>"]).run
      elsif TestCompile.detect(@options)
        TestCompile.new(@output_io, @error_io, @options["<build-dir>"], @options["<cache-dir>"], @options["<env-dir>"]).run
      elsif Test.detect(@options)
        Test.new(@output_io, @error_io, @options["<build-dir>"], @options["<env-dir>"]).run
      else
        Help.new(@output_io, @error_io).run
      end
    end
  end
end
