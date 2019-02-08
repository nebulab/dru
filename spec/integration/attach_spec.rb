RSpec.describe "`dru attach` command", type: :cli do
  it "executes `dru help attach` command successfully" do
    output = `dru help attach`
    expected_output = <<-OUT
Usage:
  dru attach [OPTIONS] SERVICE

Options:
  -h, [--help], [--no-help]        # Display usage information
      [--detach-keys=DETACH_KEYS]  # Override the key sequence for detaching a container
                                   # Default: ctrl-d
  -e, [--environment=ENVIRONMENT]  # Environment

Attach local standard input, output, and error streams to a running service
    OUT

    expect(output).to eq(expected_output)
  end
end
