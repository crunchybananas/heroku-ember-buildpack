RSpec.describe "detect" do
  it "detects an ember app" do
    output, _, status = run_bin("detect", fixtures("github-issues-demo"))

    expect(status).to be_success
    expect(output.chomp).to eq("emberjs")
  end

  it "detects it's not an ember app" do
    _, _, status = run_bin("detect", fixtures("not-static"))

    expect(status).not_to be_success
  end
end
