RSpec.describe "`dru attach` command", type: :cli do
  it "executes `dru help attach` command successfully" do
    output = `dru help attach`
    expected_output = <<-OUT
Usage:
  dru attach

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
