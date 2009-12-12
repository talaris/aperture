
module Aperture
    class Photo
      include Enumerable
      attr_accessor :versions, :path
      
      def initialize(path)
        @path = path
        raise ArgumentError, "Requires valid directory path" unless File.directory?(@path)
        @versions = []
      end
      
      def parse_all
        @versions.each do |version|
          version.parse
        end        
      end
      
      # def original_version
      #   return @versions.select {|v| v.filename == "OriginalVersionInfo.apversion"}.first
      # end
      
      def version(n)
        return @versions.select {|v| v.filename == "Version-#{n}.apversion"}.first
      end
      
  end
end