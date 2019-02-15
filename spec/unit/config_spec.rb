require 'dru/config'
require 'tempfile'

RSpec.describe Dru::Config do
  it { expect { described_class.new }.to raise_error(NoMethodError) }

  let(:instance) { described_class.instance }
  let(:config_file) { Tempfile.new('.druconfig') }
  let(:config_file_path) { config_file.path }

  after do
    config_file.close
    config_file.unlink
  end

  describe '#config_file_path=' do
    before do
      instance.instance_variable_set(:@configs, {})
      instance.config_file_path = config_file_path
    end

    it { expect(instance.config_file_path=(config_file_path)).to eq(config_file_path) }

    it { expect(instance.config_file_path).to eq(config_file_path) }

    it { expect(instance.instance_variable_get(:@configs)).to be_nil }
  end

  describe '#docker_projects_folder' do
    subject { instance.docker_projects_folder }

    before { instance.config_file_path = config_file_path }

    context "when .druconfig doesn't exist" do
      let(:config_file_path) { 'wrong_path' }

      it { is_expected.to eq described_class::DEFAULT['docker_projects_folder'] }
    end

    context "when .druconfig exists" do
      context "when .druconfig doesn't have the key" do
        it { is_expected.to eq described_class::DEFAULT['docker_projects_folder'] }
      end

      context "when .druconfig have the key" do
        let(:docker_projects_folder) { '/tmp/.nebulab_projects' }

        before do
          config_file.write("docker_projects_folder: #{docker_projects_folder}")
          config_file.rewind
        end

        it { is_expected.to eq docker_projects_folder }
      end
    end
  end

  describe '#alias' do
    subject { instance.alias }

    before { instance.config_file_path = config_file_path }

    context "when .druconfig doesn't exist" do
      let(:config_file_path) { 'wrong_path' }

      it { expect(subject.to_h).to eq described_class::DEFAULT['alias'] }
    end

    context "when .druconfig exists" do
      context "when .druconfig doesn't have the key" do
        it { expect(subject.to_h).to eq described_class::DEFAULT['alias'] }
      end

      context "when .druconfig have the key" do
        let(:alias_name) { 'alias_name' }
        let(:alias_command) { 'run a command' }

        before do
          config_file.write("alias:\n  #{alias_name}: #{alias_command}")
          config_file.rewind
        end

        it { expect(subject[alias_name]).to eq alias_command }
      end
    end
  end
end
