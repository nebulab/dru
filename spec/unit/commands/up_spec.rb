require 'dru/commands/up'
require 'dru/commands/Attach'

RSpec.describe Dru::Commands::Up do
  subject { Dru::Commands::Up.new(options: options) }

  let(:options) { {} }
  let(:attach_command) { double(:attach_command, execute: nil) }

  before do
    allow(Dru::Commands::Attach).to receive(:new).and_return(attach_command)
  end

  after do
    subject.execute(output: StringIO.new)
  end

  context 'when not in detached mode' do
    it 'calls the attach command' do
      expect(subject).to receive(:run_docker_compose_command).with('up', '-d')
      expect(attach_command).to receive(:execute)
    end
  end

  context 'when in detached mode' do
    let(:options) { { detach: true } }

    it "returns after starting the stack" do
      expect(subject).to receive(:run_docker_compose_command).with('up', '-d')
      expect(attach_command).not_to receive(:execute)
    end
  end
end
