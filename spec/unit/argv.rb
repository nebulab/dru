require 'dru/argv'

RSpec.describe Dru::Argv do
  subject(:dru_argv) { described_class.new(argv) }

  describe '#parse' do
    subject { dru_argv.parse }

    context 'when argv is empty' do
      let(:argv) { [] }

      it { is_expected.to eq(argv) }

      it 'does not change argv attribute' do
        subject
        expect(dru_argv.argv).to eq([])
      end
    end

    context 'when argv does not contain a docker compose command' do
      let(:argv) { ['-e', 'test', 'attach'] }

      it { is_expected.to eq(argv) }

      it 'does not change argv attribute' do
        subject
        expect(dru_argv.argv).to eq(['-e', 'test', 'attach'])
      end
    end

    context 'when argv contains a docker compose command' do
      let(:argv) { ['-e', 'test', 'run', '-v'] }
      let(:expected_argv) { ['-e', 'test', '--', 'run', '-v'] }

      it { is_expected.to eq(expected_argv) }

      it 'does not change argv attribute' do
        subject
        expect(dru_argv.argv).to eq(['-e', 'test', 'run', '-v'])
      end
    end
  end
end
