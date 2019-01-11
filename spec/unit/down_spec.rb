require 'dru/commands/down'

RSpec.describe Dru::Commands::Down do
  it "executes `down` command successfully" do
    output = StringIO.new
    options = {}
    command = Dru::Commands::Down.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
