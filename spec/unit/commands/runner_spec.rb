require 'dru/commands/runner'

RSpec.describe Dru::Commands::Runner do
  subject { Dru::Commands::Runner.new(command, options) }

  let(:container_command) { 'command' }
  let(:command) { [container_command] }

  let(:container) { 'container' }
  let(:options) { { container: container } }

  context 'when container is not set' do
    let(:container) { nil }

    it 'raises the MissingContainerError exception' do
      expect { subject }.to raise_error(Dru::Command::MissingContainerError)
    end
  end

  context 'when container is set' do
    after do
      subject.execute(output: StringIO.new)
    end

    let(:parameters) { ['run', '--rm', '--entrypoint', 'sh -c', container, container_command, tty: true] }

    context 'and command is set' do
      it 'executes docker-compose run on the container with the given command' do
        expect(subject).to receive(:run_docker_compose_command).with(*parameters)
      end
    end

    context 'and command is not set' do
      let(:command) { nil }
      let(:container_command) { '' }

      it 'executes docker-compose run on the container with the given command' do
        expect(subject).to receive(:run_docker_compose_command).with(*parameters)
      end
    end
  end
end
