RSpec.describe "`dru docker_compose` command", type: :cli do
  it "executes `dru help docker_compose` command successfully" do
    output = `dru help docker_compose`
    expected_output = <<-OUT
Usage:
  dru docker-compose

Options:
  -e, [--environment=ENVIRONMENT]  # Environment

Run docker-compose
    OUT

    expect(output).to eq(expected_output)
  end
end
