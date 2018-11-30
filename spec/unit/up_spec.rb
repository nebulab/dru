require 'dru/commands/up'

RSpec.describe Dru::Commands::Up do
  it "executes `up` command successfully" do
    output = StringIO.new
    options = {}
    command = Dru::Commands::Up.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
