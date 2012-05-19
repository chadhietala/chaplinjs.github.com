module Jekyll
  module VersionFilter
    def version_url(input)
      "/version#{@context.environments.first["site"]["versions"][input]}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::VersionFilter)