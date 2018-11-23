require 'dru/commands/attach'

RSpec.describe Dru::Commands::Attach do
  it "executes `attach` command successfully" do
    output = StringIO.new
    container = nil
    options = {}
    command = Dru::Commands::Attach.new(container, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
