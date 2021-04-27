RSpec.describe "version" do
  it "works with the short form" do
    output, _, status = run_bin("-v")

    expect(status).to be_success
    expect(output.chomp).to eq("0.0.1")
  end

  it "works with the long form" do
    output, _, status = run_bin("--version")

    expect(status.success?).to be true
    expect(output.chomp).to eq("0.0.1")
  end
end
