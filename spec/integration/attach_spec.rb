RSpec.describe "`dru attach` command", type: :cli do
  it "executes `dru help attach` command successfully" do
    output = `dru help attach`
    expected_output = <<-OUT
Usage:
  dru attach

Options:
  -h, [--help], [--no-help]        # Display usage information
  -c, [--container=CONTAINER]      # Container name
                                   # Default: app
  -e, [--environment=ENVIRONMENT]  # Environment

Attach local standard input, output, and error streams to a running container
    OUT

    expect(output).to eq(expected_output)
  end
end
