
module Aperture
    class Photo
      include Enumerable
      attr_reader :versions, :path
      
      def initialize(path)
        @path = path
        @versions = []
      end
    
      def <<(version)
        @versions << version
      end
    
      def each &blk
        @versions.each &blk
      end

    
  end
end