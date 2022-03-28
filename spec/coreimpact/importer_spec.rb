require 'spec_helper'

module Dradis::Plugins
  describe 'Qualys upload plugin' do
    let(:xml) { 'spec/fixtures/files/example.xml' }

    before(:each) do
      # Stub template service
      templates_dir = File.expand_path('../../../templates', __FILE__)
      expect_any_instance_of(Dradis::Plugins::TemplateService)
        .to receive(:default_templates_dir).and_return(templates_dir)

      plugin = Dradis::Plugins::Coreimpact

      @content_service = Dradis::Plugins::ContentService::Base.new(
        logger: Logger.new(STDOUT),
        plugin: plugin
      )

      @importer = Dradis::Plugins::Coreimpact::Importer.new(
        content_service: @content_service
      )

      # Stub dradis-plugins methods
      #
      # They return their argument hashes as objects mimicking
      # Nodes, Issues, etc
      allow(@content_service).to receive(:create_node) do |args|
        obj = OpenStruct.new(args)
        obj.define_singleton_method(:set_property) { |*| }
        obj.define_singleton_method(:set_service) { |*| }
        obj
      end
      allow(@content_service).to receive(:create_issue) do |args|
        OpenStruct.new(args)
      end
      allow(@content_service).to receive(:create_evidence) do |args|
        OpenStruct.new(args)
      end
    end

    it 'creates nodes' do
      expect(@content_service).to receive(:create_node).with(
        hash_including(label: '10.0.10.41')
      ).once

      expect(@content_service).to receive(:create_node).with(
        hash_including(label: '10.0.10.53')
      ).once

      @importer.import(file: xml)
    end

    it 'creates issues' do
      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include 'OpenSSL ChangeCipherSpec Message Vulnerability Checker'
        expect(args[:text]).to include 'CVE-2014-0224'
        expect(args[:text]).to include 'OpenSSL before 0.9.8za, 1.0.0 before 1.0.0m, and 1.0.1 before 1.0.1h does not properly restrict processing of ChangeCipherSpec messages'
        OpenStruct.new(args)
      end.once

      expect(@content_service).to receive(:create_issue) do |args|
        expect(args[:text]).to include 'SNMP Identity Verifier'
        expect(args[:text]).to include 'CVE-1999-0516'
        expect(args[:text]).to include 'An SNMP community name is guessable.'
        OpenStruct.new(args)
      end.once

      @importer.import(file: xml)
    end

    it 'creates evidence' do
      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include "#[AgentDeployed]#\nfalse\n\n#[TriedToInstallAgent]#\nfalse\n\n#[Port]#\n443\n"
        expect(args[:issue].text).to include 'OpenSSL ChangeCipherSpec Message Vulnerability Checker'
        expect(args[:node].label).to eq '10.0.10.41'
      end.once

      expect(@content_service).to receive(:create_evidence) do |args|
        expect(args[:content]).to include "#[AgentDeployed]#\nfalse\n\n#[TriedToInstallAgent]#\nfalse\n\n#[Port]#\n161\n"
        expect(args[:issue].text).to include 'SNMP Identity Verifier'
        expect(args[:node].label).to eq '10.0.10.53'
      end.once

      @importer.import(file: xml)
    end
  end
end
