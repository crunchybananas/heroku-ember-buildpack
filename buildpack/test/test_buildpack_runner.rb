class TestBuildpackRunner < MTest::Unit::TestCase
  include Buildpack::Shell

  BuildpackRunner = Buildpack::BuildpackRunner

  def test_run
    output = StringIO.new.instance_eval do
      extend Buildpack::Messaging
    end
    error = StringIO.new.instance_eval do
      extend Buildpack::Messaging
    end
    buildpack = BuildpackRunner.new(output, error, "ddollar/null")

    mktmpdir do |dir|
      release, export = buildpack.run(dir, dir, dir)
      assert_equal Hash.new, release, "release should be a new hash: #{release}"
      assert_nil export, "export is not nil: #{export}"
      assert_true output.string.include?("Fetching buildpack ddollar/null")
      assert_true output.string.include?("-----> Nothing to do.")
    end
  end
end

MTest::Unit.new.run
