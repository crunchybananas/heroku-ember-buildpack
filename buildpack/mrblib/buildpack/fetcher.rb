module Buildpack
  module Shell; end

  class Fetcher
    include Buildpack::Shell

    def initialize(base_url)
      @http     = HttpRequest.new
      @base_url = base_url
    end

    def fetch(url_path, local_path)
      File.open(local_path, 'w') do |file|
        file.print @http.get("#{@base_url}/#{url_path}").body
      end
    end

    def unpack(file)
      system("tar xzf #{file} 2>1")
    end
  end
end
