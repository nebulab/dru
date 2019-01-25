RSpec.describe "`dru docker_compose` command", type: :cli do
  it "executes `dru help docker_compose` command successfully" do
    output = `dru help docker_compose`
    expected_output = <<-OUT
Usage:
  dru docker_compose

Options:
  -h, [--help], [--no-help]        # Display usage information
  -e, [--environment=ENVIRONMENT]  # Environment

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
