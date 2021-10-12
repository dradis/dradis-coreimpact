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
    # <property type="container" key="Modules">
    #   <property type="container" key="<Title>">
    #     <property type="bool" key="agent_deployed">false</property>
    #     <property type="string" key="description">
    #       Some description.
    #     </property>
    #     <property type="string" key="port">443</property>
    #     <property type="bool" key="tried_to_install_agent">false</property>
    #   </property>
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
