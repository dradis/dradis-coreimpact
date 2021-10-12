module Coreimpact
  class Module
    # Accepts an XML node from Nokogiri::XML.
    def initialize(xml_module)
      @xml = xml_module
    end

    # List of supported tags. They can be attributes, simple descendans or
    # collections (e.g. <bid/>, <cve/>, <xref/>)
    def supported_fields
      [:agent_deployed, :port, :tried_to_install_agent]
    end

    # This allows external callers (and specs) to check for implemented
    # properties
    def respond_to?(method, include_private = false)
      return true if supported_fields.include?(method.to_sym)

      super
    end

    # Example XML:
    # <property type="container" key="Modules" readonly="0" eraseable="1" priority="0">
    # 	<property type="container" key="OpenSSL ChangeCipherSpec Message Vulnerability Checker" readonly="0" eraseable="1" priority="0">
    # 		<property type="bool" key="agent_deployed" readonly="0" eraseable="1" priority="0">false</property>
    # 		<property type="string" key="description" readonly="0" eraseable="1" priority="0">OpenSSL before 0.9.8za, 1.0.0 before 1.0.0m, and 1.0.1 before 1.0.1h does not properly restrict processing of ChangeCipherSpec messages, which allows man-in-the-middle attackers to trigger use of a zero-length master key in certain OpenSSL-to-OpenSSL communications, and consequently hijack sessions or obtain sensitive information, via a crafted TLS handshake, aka the &#0034;CCS Injection&#0034; vulnerability.</property>
    # 		<property type="string" key="port" readonly="0" eraseable="1" priority="0">443</property>
    # 		<property type="bool" key="tried_to_install_agent" readonly="0" eraseable="1" priority="0">false</property>
    # 	</property>
    # </property>
    def method_missing(method, *args)
      # We could remove this check and return nil for any non-recognized tag.
      # The problem would be that it would make tricky to debug problems with
      # typos. For instance: <>.potr would return nil instead of raising an
      # exception
      unless supported_fields.include?(method)
        super
        return
      end

      @xml.at_xpath("//property[@key='#{method}']").text || 'n/a'
    end
  end
end
