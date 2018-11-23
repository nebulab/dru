RSpec.describe "`dru exec` command", type: :cli do
  it "executes `dru help exec` command successfully" do
    output = `dru help exec`
    expected_output = <<-OUT
Usage:
  dru exec [CONTAINER] COMMAND

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
