
module Google
  class Search
    class Response
      
      ##
      # Response status code.
      
      attr_reader :status
      
      ##
      # Response details.
      
      attr_reader :details
      
      ##
      # Raw JSON string.
      
      attr_accessor :raw
      
      ##
      # Hash parsed from raw JSON string.
      
      attr_reader :hash
      
      ##
      # Items populated by the JSON hash.
      
      attr_reader :items
      
      ##
      # Estimated number of results.
      
      attr_reader :estimated_count
      
      ##
      # Current page index.
      
      attr_reader :page

      ##
      # Initialize with _hash_.
      
      def initialize hash
        @page = 0
        @hash = hash
        @status = hash['responseStatus']
        @details = hash['responseDetails']
        @items = []
        if valid?
          if hash['responseData'].include? 'cursor'
            @estimated_count = hash['responseData']['cursor']['estimatedResultCount'].to_i
            @page = hash['responseData']['cursor']['currentPageIndex'].to_i 
          end
          i = page
          @items = @hash['responseData']['results'].map do |result|
            item_class = Google::Search::Item.class_for result['GsearchResultClass']
            result['index'] = i; i += 1
            item_class.new result
          end
        end
      end
      
      ##
      # Check if the response is valid.
      
      def valid?
        hash['responseStatus'] == 200
      end
      
    end
  end
end