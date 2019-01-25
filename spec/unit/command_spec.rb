require 'dru/command'

RSpec.describe Dru::Command do
  subject(:dru_command) { described_class.new }

  let(:environment) { nil }
  let(:options) { { environment: environment } }

  before { dru_command.options = options }

  describe '#environment' do
    subject { dru_command.environment }

    context 'when options is nil' do
      let(:options) { nil }

      it { is_expected.to be_nil }
    end

    context 'when environment option is not set' do
      let(:environment) { nil }

      it { is_expected.to be_nil }
    end

    context 'when environment option is set' do
      let(:environment) { 'test' }

      it { is_expected.to eq(environment) }
    end
  end

  describe '#environment_docker_compose' do
    subject { dru_command.environment_docker_compose }

    context 'when environment option is not set' do
      let(:environment) { nil }

      it { is_expected.to be_nil }
    end

    context 'when environment option is set' do
      let(:environment) { 'test' }

      it { is_expected.to eq("#{dru_command.project_configuration_path}/docker-compose.#{environment}.yml") }
    end
  end

  describe '#docker_compose_paths' do
    subject { dru_command.docker_compose_paths }

    let(:default_path) { '/a/path' } 

    before do
      allow(dru_command).to receive(:default_docker_compose).and_return(default_path)
      allow(dru_command).to receive(:environment_docker_compose).and_return(environment_path)
    end

    context 'when environment option is not set' do
      let(:environment_path) { nil }

      it { is_expected.to eq(['-f', default_path]) }
    end

    context 'when environment option is set' do
      let(:environment_path) { '/an/environment/path' }

      it { is_expected.to eq(['-f', default_path, '-f', environment_path]) }
    end
  end

  describe '#run_docker_compose_command' do
    let(:command) { double(:command) }
    let(:docker_compose_paths) { ['-f', 'docker-compose.yml'] }
    let(:docker_compose_command) { Dru::DOCKER_COMPOSE_COMMAND }

    before do
      allow(dru_command).to receive(:docker_compose_paths).and_return(docker_compose_paths)
    end

    context 'when options and args are not set' do
      it 'calls #command without options and #run without arguments' do
        expect(dru_command).to receive(:command).with({}).and_return(command)
        expect(command).to receive(:run).with(docker_compose_command, *docker_compose_paths)
        dru_command.run_docker_compose_command
      end
    end

    context 'when options is not set and args is set' do
      it 'calls #command without options and #run with arguments' do
        expect(dru_command).to receive(:command).with({}).and_return(command)
        expect(command).to receive(:run).with(docker_compose_command, *docker_compose_paths, 'ls', '-l')
        dru_command.run_docker_compose_command('ls', '-l')
      end
    end

    context 'when tty option is false' do
      context 'when options is set and args is not set' do
        it 'calls #command with options and #run without arguments' do
          expect(dru_command).to receive(:command).with(tty: false).and_return(command)
          expect(command).to receive(:run).with(docker_compose_command, *docker_compose_paths)
          dru_command.run_docker_compose_command(tty: false)
        end
      end

      context 'when options and args are set' do
        it 'calls #command with options and #run with arguments' do
          expect(dru_command).to receive(:command).with(tty: false).and_return(command)
          expect(command).to receive(:run).with(docker_compose_command, *docker_compose_paths, 'ls', '-l')
          dru_command.run_docker_compose_command('ls', '-l', tty: false)
        end
      end
    end

    context 'when tty option is true' do
      context 'when options is set and args is not set' do
        it 'calls #command with options and #run without arguments' do
          expect(dru_command).to receive(:system).with(docker_compose_command, *docker_compose_paths)
          dru_command.run_docker_compose_command(tty: true)
        end
      end

      context 'when options and args are set' do
        it 'calls #command with options and #run with arguments' do
          expect(dru_command).to receive(:system).with(docker_compose_command, *docker_compose_paths, 'ls', '-l')
          dru_command.run_docker_compose_command('ls', '-l', tty: true)
        end
      end
    end
  end

  describe '#container_name_to_id' do
    let(:result) { %w[output error] }

    it 'calls #run_docker_compose_command with default params' do
      expect(dru_command).to receive(:run_docker_compose_command).with('ps', '-q', 'app', printer: :null).and_return(result)
      expect(dru_command.container_name_to_id).to eq('output')
    end

    it 'calls #run_docker_compose_command with default params and custom container name' do
      expect(dru_command).to receive(:run_docker_compose_command).with('ps', '-q', 'db', printer: :null).and_return(result)
      expect(dru_command.container_name_to_id('db')).to eq('output')
    end
  end
end
