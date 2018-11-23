require 'dru/commands/runner'

RSpec.describe Dru::Commands::Runner do
  it "executes `runner` command successfully" do
    output = StringIO.new
    options = {}
    command = Dru::Commands::Runner.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
