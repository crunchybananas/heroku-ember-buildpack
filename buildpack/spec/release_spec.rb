require 'tmpdir'

RSpec.describe "release" do
  context "when release.yml is found" do

    it "returns existing yaml" do
      yaml = <<YAML
---
default_process_types:
  web: bin/start
YAML

      Dir.mktmpdir do |dir|
        FileUtils.mkdir_p("#{dir}/tmp")
        File.open("#{dir}/tmp/heroku-buildpack-release.yml", "w") do |file|
          file.print yaml
        end
        output, _, status = run_bin("release", dir)

        expect(status).to be_success
        expect(output).to eq(yaml)
      end
    end
  end

  context "when there is no release.yml" do
    it "returns empty yaml" do
      Dir.mktmpdir do |dir|
        output, _, status = run_bin("release", dir)

        expect(status).to be_success
        expect(output.chomp).to eq "--- {}"
      end
    end
  end
end
