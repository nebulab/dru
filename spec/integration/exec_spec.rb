RSpec.describe "`dru exec` command", type: :cli do
  it "executes `dru help exec` command successfully" do
    output = `dru help exec`
    expected_output = <<-OUT
Usage:
  dru exec

Options:
  -h, [--help], [--no-help]        # Display usage information
  -c, [--container=CONTAINER]      # Container name
                                   # Default: app
  -e, [--environment=ENVIRONMENT]  # Environment

Execute a command in a running container.
    OUT

    expect(output).to eq(expected_output)
  end
end
