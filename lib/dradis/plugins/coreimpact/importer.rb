module Dradis::Plugins::Coreimpact
  class Importer < Dradis::Plugins::Upload::Importer
    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params={})

      file_content = File.read( params[:file] )

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing CORE Impact output file..." }
      @doc = Nokogiri::XML( file_content )
      logger.info { 'Done.' }

      unless @doc.xpath('/entities').empty?
        logger.error "ERROR: no '<entities>' root element present in the provided "\
                     "data. Are you sure you uploaded a CORE Impact file?"
        return false
      end

      @doc.xpath('/entitties/entity').each do |xml_entity|
        # magic...
      end
    end
  end
end
