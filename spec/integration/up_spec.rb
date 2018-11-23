RSpec.describe "`dru up` command", type: :cli do
  it "executes `dru help up` command successfully" do
    output = `dru help up`
    expected_output = <<-OUT
Usage:
  dru up

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
