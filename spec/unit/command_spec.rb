require 'dru/command'
require 'tty/command/result'

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

  describe '#override_docker_compose' do
    subject { dru_command.override_docker_compose }

    context 'when environment option is not set' do
      let(:environment) { nil }

      context 'and the docker-compose.override.yml file exists' do
        before do
          allow(File).to receive(:exist?).and_return(true)
        end

        it { is_expected.to eq("#{dru_command.project_configuration_path}/docker-compose.override.yml") }
      end

      context 'and the docker-compose.override.yml file doesn\'t exist' do
        it { is_expected.to be_nil }
      end
    end

    context 'when environment option is set' do
      let(:environment) { 'test' }

      context 'and the docker-compose.test.yml file exists' do
        before do
          allow(File).to receive(:exist?).and_return(true)
        end

        it { is_expected.to eq("#{dru_command.project_configuration_path}/docker-compose.#{environment}.yml") }
      end

      context 'and the docker-compose.test.yml file doesn\'t exist' do
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#docker_compose_paths' do
    subject { dru_command.docker_compose_paths }

    let(:default_path) { '/a/path' }

    before do
      allow(dru_command).to receive(:default_docker_compose).and_return(default_path)
      allow(dru_command).to receive(:override_docker_compose).and_return(override_path)
    end

    context 'when override file doesn\'t exist' do
      let(:override_path) { nil }

      it { is_expected.to eq(['-f', default_path]) }
    end

    context 'when override file exists' do
      let(:override_path) { '/an/override/path' }

      it { is_expected.to eq(['-f', default_path, '-f', override_path]) }
    end
  end

  describe '#run' do
    subject { dru_command.run(command, options) }

    let(:tty_command) { double(:tty_command, run!: result) }
    let(:result) { TTY::Command::Result.new(0, 'out', 'err') }
    let(:command) { 'ls -l' }
    let(:options) { Hash[color: true, printer: :null] }

    it 'calls TTY::Command#run! with command and options' do
      allow(dru_command).to receive(:command).and_return(tty_command)
      expect(tty_command).to receive(:run!).with(command, options.merge(in: '/dev/tty', err: '/dev/tty'))
      subject
    end

    context 'when command exit code is zero' do
      it 'returns a TTY::Command::Result object' do
        is_expected.to be_a(TTY::Command::Result)
      end
    end

    context 'when command exit code is non-zero' do
      let(:command) { 'ls -ERROR' }

      it 'raises Dru::CLI::Error' do
        expect { subject }.to raise_error(Dru::CLI::Error)
      end
    end
  end

  describe '#run_docker_compose_command' do
    let(:docker_compose_paths) { ['-f', 'docker-compose.yml'] }
    let(:docker_compose_project_name) { 'app' }

    before do
      allow(dru_command).to receive(:docker_compose_paths).and_return(docker_compose_paths)
      allow(dru_command).to receive(:docker_compose_project_name).and_return(docker_compose_project_name)
    end

    it 'calls #run with given arguments' do
      expect(dru_command).to receive(:run).with(Dru::DOCKER_COMPOSE_COMMAND, '-p', 'app', *docker_compose_paths, 'ps', '--services', printer: :null)
      dru_command.run_docker_compose_command('ps', '--services', printer: :null)
    end
  end

  describe '#run_docker_command' do
    it 'calls #run with given arguments' do
      expect(dru_command).to receive(:run).with(Dru::DOCKER_COMMAND, 'attach', 'container', printer: :null)
      dru_command.run_docker_command('attach', 'container', printer: :null)
    end
  end

  describe '#container_name_to_id' do
    let(:result) { TTY::Command::Result.new(0, "out\n", 'err') }
    let(:stripped_output) { 'out' }

    it 'calls #run_docker_compose_command with default params and custom container name' do
      expect(dru_command).to receive(:run_docker_compose_command).with('ps', '-q', 'db', only_output_on_error: true).and_return(result)
      expect(dru_command.container_name_to_id('db')).to eq(stripped_output)
    end
  end

  describe '#docker_compose_project_name' do
    subject { dru_command.docker_compose_project_name }

    let(:project_name) { 'app' }

    before do
      allow(dru_command).to receive(:project_name).and_return(project_name)
    end

    context 'when environment option is not set' do
      let(:environment) { nil }

      it { is_expected.to eq('app') }
    end

    context 'when environment option is set' do
      let(:environment) { 'test' }

      it { is_expected.to eq('app_test') }
    end
  end
end
