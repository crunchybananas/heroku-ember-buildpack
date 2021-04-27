RSpec.describe "help" do
  it "runs help" do
    output, _, status = run_bin("-h")

    expect(status).to be_success
    expect(output).to include("Usage:")
  end
end
