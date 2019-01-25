require 'dru/commands/docker_compose'

RSpec.describe Dru::Commands::DockerCompose do
  subject { Dru::Commands::DockerCompose.new(command: command, options: options) }

  let(:command) { ['exec', 'app', 'ls'] }
  let(:options) { {} }

  after do
    subject.execute(output: StringIO.new)
  end

  context 'when command is set' do
    let(:parameters) { [*command, tty: true] }

    it 'executes docker-compose with the given command' do
      is_expected.to receive(:run_docker_compose_command).with(*parameters)
    end
  end

  context 'when command is not set' do
    let(:command) { nil }

    it 'executes docker-compose without the given command' do
      is_expected.to receive(:run_docker_compose_command).with({ tty: true })
    end
  end
end
