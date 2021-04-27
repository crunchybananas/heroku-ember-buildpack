class TestFetcher < MTest::Unit::TestCase
  include Buildpack::Shell

  Fetcher = Buildpack::Fetcher

  def setup
    @fetcher = Fetcher.new("https://codon-buildpacks.s3.amazonaws.com/buildpacks")
  end

  def test_fetch
    filename = "nodejs.tgz"

    mktmpdir do |dir|
      @fetcher.fetch("heroku/#{filename}", filename)
      assert_true File.exist?(filename), "Could not find #{filename}"

      IO.popen("file #{filename}") do |io|
        data = io.read
        assert_true data.include?("gzip compressed data"), "gzip file not detected: #{data}"
      end
    end
  end

  def test_unpack
    filename = "nodejs.tgz"

    mktmpdir do |dir|
      @fetcher.fetch("heroku/#{filename}", filename)
      @fetcher.unpack(filename)

      assert_true File.exist?("bin/detect"), "bin/detect not found"
    end
  end
end

MTest::Unit.new.run
