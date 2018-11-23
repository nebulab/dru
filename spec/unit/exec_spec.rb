require 'dru/commands/exec'

RSpec.describe Dru::Commands::Exec do
  it "executes `exec` command successfully" do
    output = StringIO.new
    container = nil
    command = nil
    options = {}
    command = Dru::Commands::Exec.new(container, command, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
