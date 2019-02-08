require 'dru/commands/attach'

RSpec.describe Dru::Commands::Attach do
  subject { Dru::Commands::Attach.new(options: options) }

  let(:container) { 'container' }
  let(:options) { { container: container } }

  context 'when container is not set' do
    let(:container) { nil }

    it 'raises the MissingContainerError exception' do
      expect { subject }.to raise_error(Dru::Command::MissingContainerError)
    end
  end

  context 'when container is set' do
    let(:container_id) { 'container_id' }
    let(:docker_attach_command) { "#{described_class::DOCKER_ATTACH_COMMAND} #{container_id}" }

    before do
      allow(subject).to receive(:container_name_to_id).and_return(container_id)
    end

    after do
      subject.execute(output: StringIO.new)
    end

    it "executes docker attach on the container" do
      expect(subject).to receive(:system).with(docker_attach_command)
    end
  end
end
