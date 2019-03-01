require 'dru/config'
require 'tempfile'

RSpec.describe Dru::Config do
  let(:instance) { described_class.new(druconfig: config_file_path) }
  let(:config_file) { Tempfile.new('.druconfig') }
  let(:config_file_path) { config_file.path }

  after do
    config_file.close
    config_file.unlink
  end

  describe '#docker_projects_folder' do
    subject { instance.docker_projects_folder }

    context "when .druconfig doesn't exist" do
      let(:config_file_path) { 'wrong_path' }

      it { is_expected.to eq described_class::DOCKER_PROJECTS_FOLDER }
    end

    context "when .druconfig exists" do
      context "when .druconfig doesn't have the key" do
        it { is_expected.to eq described_class::DOCKER_PROJECTS_FOLDER }
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

    context "when .druconfig doesn't exist" do
      let(:config_file_path) { 'wrong_path' }

      it { expect(subject.to_h).to eq described_class::ALIAS }
    end

    context "when .druconfig exists" do
      context "when .druconfig doesn't have the key" do
        it { expect(subject.to_h).to eq described_class::ALIAS }
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
