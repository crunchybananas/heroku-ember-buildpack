require 'tmpdir'
require 'fileutils'
require 'yaml'

RSpec.describe "compile" do
  let(:cache_dir) { Dir.mktmpdir("cache") }
  let(:env_dir)   { Dir.mktmpdir("env") }
  let(:build_dir) { Dir.mktmpdir("build") }

  before do
    FileUtils.cp_r(fixtures(app), build_dir)
  end

  after do
    [cache_dir, env_dir, build_dir].each do |dir|
      FileUtils.rm_rf(dir)
    end
  end

  context "standard ember app" do
    let(:app) { "super-rentals" }

    it "should use all three buildpacks" do
      output, _, status = run_bin("compile", "#{build_dir}/#{app}", cache_dir, env_dir)

      expect(status).to be_success
      expect(output).to include("NPM_CONFIG_PRODUCTION=false")
      expect(output).to include("Fetching buildpack heroku/nodejs")
      expect(output).to include("Fetching buildpack heroku/ember-cli-deploy")
      expect(output).to include("Fetching buildpack heroku/static")

      yaml = YAML.load_file("#{build_dir}/#{app}/tmp/heroku-buildpack-release.yml")
      expect(yaml["default_process_types"]["web"]).to eq("bin/boot")
    end
  end

  context "fastboot ember app" do
    let(:app) { "ember-api-docs" }

    it "should not use the static buildpack" do
      output, _, status = run_bin("compile", "#{build_dir}/#{app}", cache_dir, env_dir)

      expect(status).to be_success
      expect(output).to include("NPM_CONFIG_PRODUCTION=false")
      expect(output).to include("Fetching buildpack heroku/nodejs")
      expect(output).to include("Fetching buildpack heroku/ember-cli-deploy")
      expect(output).not_to include("Fetching buildpack heroku/static")

      yaml = YAML.load_file("#{build_dir}/#{app}/tmp/heroku-buildpack-release.yml")
      expect(yaml["default_process_types"]["web"]).to include("fastboot")
    end
  end
end
