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
      context 'and does not contain a dru command' do
        context 'and does not contain an alias command' do
          let(:argv) { ['-e', 'test', 'unknown-command'] }

          it 'does not change argv attribute' do
            is_expected.to eq(argv)
          end
        end

        context 'and contains an alias command' do
          let(:argv) { ['-e', 'test', 'alias-command'] }
          let(:dru_alias) { OpenStruct.new({ 'alias-command' => 'run alias command' }) }
          let(:expected_argv) { ['-e', 'test', '--', 'run', 'alias', 'command'] }

          before do
            allow(Dru).to receive(:config).and_return(double(:config, alias: dru_alias))
          end

          it { is_expected.to eq(expected_argv) }
        end
      end

      context 'and contains a dru command' do
        let(:argv) { ['-e', 'test', 'attach'] }
        let(:expected_argv) { ['attach', '-e', 'test'] }

        it { is_expected.to eq(expected_argv) }
      end
    end

    context 'when argv contains a docker compose command' do
      context 'and does not contain a dru command' do
        let(:argv) { ['-e', 'test', 'exec', '-v'] }
        let(:expected_argv) { ['-e', 'test', '--', 'exec', '-v'] }

        it { is_expected.to eq(expected_argv) }
      end

      context 'and contains a dru command' do
        context 'and dru command appears before docker compose command' do
          let(:argv) { ['-e', 'test', 'attach', '-v', 'exec'] }
          let(:expected_argv) { ['attach', '-e', 'test', '-v', 'exec'] }

          it { is_expected.to eq(expected_argv) }
        end

        context 'and dru command appears after docker compose command' do
          let(:argv) { ['-e', 'test', 'exec', '-v', 'attach'] }
          let(:expected_argv) { ['-e', 'test', '--', 'exec', '-v', 'attach'] }

          it { is_expected.to eq(expected_argv) }
        end
      end
    end
  end
end
