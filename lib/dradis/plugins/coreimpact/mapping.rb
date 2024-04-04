module Dradis::Plugins::Coreimpact
  module Mapping
    DEFAULT_MAPPING = {
      evidence: {
        'AgentDeployed' => '{{ coreimpact[evidence.agent_deployed] }}',
        'Description' => '{{ coreimpact[evidence.description] }}',
        'Port' => '{{ coreimpact[evidence.port] }}',
        'TriedToInstallAgent' => '{{ coreimpact[evidence.tried_to_install_agent] }}'
      },
      issue: {
        'Title' => '{{ coreimpact[issue.title] }}',
        'AgentDeployed' => '{{ coreimpact[issue.agent_deployed] }}',
        'CVE' => '{{ coreimpact[issue.cve] }}',
        'Description' => '{{ coreimpact[issue.description] }}',
        'Port' => '{{ coreimpact[issue.port] }}',
        'TriedToInstallAgent' => '{{ coreimpact[issue.tried_to_install_agent] }}'
      }
    }.freeze

    SOURCE_FIELDS = {
      evidence: [
        'evidence.agent_deployed',
        'evidence.description',
        'evidence.tried_to_install_agent',
        'evidence.port'
      ],
      issue: [
        'issue.title',
        'issue.agent_deployed',
        'issue.cve',
        'issue.description',
        'issue.port',
        'issue.tried_to_install_agent'
      ]
    }.freeze
  end
end
