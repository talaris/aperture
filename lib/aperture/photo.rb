
module Aperture
    class Photo
      include Enumerable
      attr_reader :versions, :path
      
      def initialize(path)
        @path = path
        raise ArgumentError, "Requires valid directory path" unless File.directory?(@path)
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