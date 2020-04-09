module Dradis::Plugins::Coreimpact
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file XML
      logger.info { "Parsing CORE Impact output file... #{params[:file]}" }
      @doc = Nokogiri::XML( file_content )
      logger.info { 'Done.' }

      if @doc.xpath('/entities').empty?
        logger.error "ERROR: no '<entities>' root element present in the provided "\
                     "data. Are you sure you uploaded a CORE Impact file?"
        return false
      end

      @doc.xpath('/entities/entity[@class="host"]').each do |xml_entity|
        add_host(xml_entity)
      end
    end

    private
    def add_host(xml_entity)
      label = xml_entity.at_xpath('./property[@key="display_name"]').text
      node  = content_service.create_node(label: label, type: :host)

      logger.info{ "\tHost: #{label}" }
      logger.info{ "\t\t#{xml_entity.at_xpath('./property[@key="ip"]').text}"}
      logger.info{ "\t\t#{xml_entity.at_xpath('./property[@type="os"]/property[@key="entity name"]').text}"}

      node.set_property(:ip, xml_entity.at_xpath('./property[@key="ip"]').text)
      node.set_property(:os, xml_entity.at_xpath('./property[@type="os"]/property[@key="entity name"]').text)

      # port and service info
      add_ports(xml_entity, node)

      # vulns and exposures
      xml_entity.xpath('./property[@key="Vulnerabilities"]/property[@type="container"]').each do |xml_container|
        add_vulnerability(xml_container, node)
      end

      node.save
    end

    def add_ports(xml_entity, node)
      xml_entity.xpath('./property[@type="ports"]').each do |xml_ports|
        protocol = xml_ports['key'].split('_').first

        xml_ports.xpath('./property[@type="port"]').each do |xml_port|
          node.set_service(
            port: xml_port['key'],
            protocol: protocol,
            source: :coreimpact,
            state: (xml_port.text == 'listen') ? :open : xml_port.text
          )
        end
      end
    end

    def add_vulnerability(xml_container, node)
      plugin_id = xml_container['key']
      issue_text = template_service.process_template(template: 'issue', data: xml_container)
      issue = content_service.create_issue(text: issue_text, id: plugin_id)

      evidence_content = template_service.process_template(template: 'evidence', data: xml_container)
      content_service.create_evidence(issue: issue, node: node, content: evidence_content)
    end
  end
end
