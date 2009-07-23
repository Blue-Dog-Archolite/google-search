
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
        @hash = hash
        @status = hash['responseStatus']
        @details = hash['responseDetails']
        @estimated_count = hash['responseData']['cursor']['estimatedResultCount'].to_i rescue 0
        @page = hash['responseData']['cursor']['currentPageIndex'].to_i rescue 0
        @items = []
        if valid?
          @items = @hash['responseData']['results'].map do |result|
            item_class = Google::Search::Item.class_for result['GsearchResultClass']
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