require 'dru/commands/attach'

RSpec.describe Dru::Commands::Attach do
  subject { Dru::Commands::Attach.new(service: service, options: { detach_keys: detach_keys }) }

  let(:service) { 'service' }
  let(:container_id) { 'container_id' }
  let(:detach_keys) { 'ctrl-s' }

  before do
    allow(subject).to receive(:container_name_to_id).with(service).and_return(container_id)
  end

  after do
    subject.execute(output: StringIO.new)
  end

  it "executes docker attach on the container" do
    expect(subject).to receive(:run_docker_command).with(described_class::ATTACH_COMMAND, "--detach-keys=#{detach_keys}", container_id)
  end
end
