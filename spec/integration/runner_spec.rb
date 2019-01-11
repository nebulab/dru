RSpec.describe '`dru run` command', type: :cli do
  it 'executes `dru help run` command successfully' do
    output = `dru help run`
    expected_output = <<-OUT
Usage:
  dru run

Options:
  -h, [--help], [--no-help]        # Display usage information
  -c, [--container=CONTAINER]      # Container name
                                   # Default: app
  -e, [--environment=ENVIRONMENT]  # Environment

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
