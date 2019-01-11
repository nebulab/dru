require 'dru/commands/exec'

RSpec.describe Dru::Commands::Exec do
  subject { Dru::Commands::Exec.new(command: command, options: options) }

  let(:command) { ['command'] }
  let(:container_command) { command }

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

    let(:parameters) { ['exec', container, *container_command, tty: true] }

    context 'and command is set' do
      it 'executes docker-compose exec on the container with the given command' do
        expect(subject).to receive(:run_docker_compose_command).with(*parameters)
      end
    end

    context 'and command is not set' do
      let(:command) { nil }
      let(:container_command) { [] }

      it 'executes docker-compose exec on the container with the given command' do
        expect(subject).to receive(:run_docker_compose_command).with(*parameters)
      end
    end
  end
end
