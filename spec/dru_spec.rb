RSpec.describe Dru do
  it "has a version number" do
    expect(Dru::VERSION).not_to be nil
  end

  describe '.config' do
    subject { described_class.config }

    it { is_expected.to be_a(Dru::Config) }

    it 'sets the default dru config file path' do
      expect(Dru::Config.instance).to receive(:config_file_path=).with(Dru::DRUCONFIG)
      subject
    end
  end
end
