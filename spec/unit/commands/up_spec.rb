require 'dru/commands/up'

RSpec.describe Dru::Commands::Up do
  subject { Dru::Commands::Up.new(options) }

  let(:options) { {} }
  let(:container_id) { 'container_id' }
  let(:docker_attach_command) { "#{described_class::DOCKER_ATTACH_COMMAND} #{container_id}" }

  before do
    allow(subject).to receive(:container_name_to_id).and_return(container_id)
  end

  after do
    subject.execute(output: StringIO.new)
  end

  context 'when not in detached mode' do
    context 'when ctrl-d is pressed' do
      it "doesn't execute docker-compose down" do
        expect(subject).to receive(:run_docker_compose_command).with('up', '-d')
        expect(subject).to receive(:system).with(docker_attach_command).and_return(false)
        expect(subject).not_to receive(:run_docker_compose_command).with('down')
      end
    end

    context 'when ctrl-c is pressed' do
      it 'executes docker-compose down' do
        expect(subject).to receive(:run_docker_compose_command).with('up', '-d')
        expect(subject).to receive(:system).with(docker_attach_command).and_return(true)
        expect(subject).to receive(:run_docker_compose_command).with('down')
      end
    end
  end

  context 'when in detached mode' do
    let(:options) { { detach: true } }

    it "returns after starting the stack" do
      expect(subject).to receive(:run_docker_compose_command).with('up', '-d')
      expect(subject).not_to receive(:system)
      expect(subject).not_to receive(:run_docker_compose_command).with('down')
    end
  end
end
