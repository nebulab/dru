require 'dru/commands/exec'

RSpec.describe Dru::Commands::Exec do
  it "executes `exec` command successfully" do
    output = StringIO.new
    options = {}
    command = Dru::Commands::Exec.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
