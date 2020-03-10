module Dradis
  module Plugins
    module Coreimpact
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Plugins::Coreimpact

        include ::Dradis::Plugins::Base
        description 'Processes CORE Impact XML output'
        provides :upload
      end
    end
  end
end
