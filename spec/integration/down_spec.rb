RSpec.describe "`dru down` command", type: :cli do
  it "executes `dru help down` command successfully" do
    output = `dru help down`
    expected_output = <<-OUT
Usage:
  dru down

Options:
  -h, [--help], [--no-help]        # Display usage information
  -e, [--environment=ENVIRONMENT]  # Environment

Stops containers and removes containers, networks, volumes, and images created by `up`.
    OUT

    expect(output).to eq(expected_output)
  end
end
