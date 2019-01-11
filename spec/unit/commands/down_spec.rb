require 'dru/commands/down'

RSpec.describe Dru::Commands::Down do
  subject { Dru::Commands::Down.new }

  after do
    subject.execute(output: StringIO.new)
  end

  it "executes docker-compose down" do
    expect(subject).to receive(:run_docker_compose_command).with('down')
  end
end
