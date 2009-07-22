
require 'json'

module Google
  class Search
    
    URI = 'http://www.google.com/uds'
    
    ##
    # Version. Defaults to 1.0
    
    attr_accessor :version
    
    ##
    # Offset. Defaults to 0
    
    attr_accessor :offset
    
    ##
    # Language. Defaults to :en
    
    attr_accessor :lang
    
    ##
    # Query. Defaults to nil
    
    attr_accessor :query
    
    ##
    # API Key.
    
    attr_accessor :api_key
    
    ##
    # Size. Defaults to :small
    #
    #  - :small = 4
    #  - :large = 8
    #
    
    attr_accessor :size
    
    ##
    # Type symbol:
    #
    #   - :local
    #   - :web
    #   - :video
    #   - :blog
    #   - :news
    #   - :image
    #   - :book
    #   - :patent
    #
    
    attr_accessor :type
    
    ##
    # Initialize search _type_ with _options_.
    
    def initialize type, options = {}
      @type = type
      @version = options[:version] || 1.0
      @offset = options[:offset] || 0
      @size = options[:size] || :small
      @lang = options[:lang] || :en
      @query = options[:query]
      @api_key = options[:api_key]
    end
    
    def get_uri
      URI + "/G#{@type}Search?" + {
        :lstkp => @offset,
        :rsz => @size,
        :hl => @lang,
        :key => @api_key,
        :q => @query
      }.map { |key, value| "#{key}=#{value}" }.join('&')
    end
    
    def get_raw
      p get_uri
    end
  end
end