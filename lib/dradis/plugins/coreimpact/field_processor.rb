module Dradis
  module Plugins
    module Coreimpact
      class FieldProcessor < Dradis::Plugins::Upload::FieldProcessor

        def post_initialize(args={})
          @core_vuln = ::Coreimpact::Vulnerability.new(data)
        end

        def value(args={})
          field = args[:field]

          # fields in the template are of the form <foo>.<field>, where <foo>
          # is common across all fields for a given template (and meaningless).
          _, name = field.split('.')

          @core_vuln.try(name) || 'n/a'
        end
      end
    end
  end
end
