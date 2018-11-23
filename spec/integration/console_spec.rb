RSpec.describe "`dru console` command", type: :cli do
  it "executes `dru help console` command successfully" do
    output = `dru help console`
    expected_output = <<-OUT
Usage:
  dru console

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
