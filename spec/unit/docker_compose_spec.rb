require 'dru/commands/docker_compose'

RSpec.describe Dru::Commands::DockerCompose do
  it "executes `docker_compose` command successfully" do
    output = StringIO.new
    options = {}
    command = Dru::Commands::DockerCompose.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
