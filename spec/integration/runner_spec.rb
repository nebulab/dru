RSpec.describe "`dru runner` command", type: :cli do
  it "executes `dru help runner` command successfully" do
    output = `dru help runner`
    expected_output = <<-OUT
Usage:
  dru runner

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
