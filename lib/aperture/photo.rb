
module Aperture
  class Photo
    attr_accessor :versions, :path, :file_attributes, :master_attributes
    
    def initialize(path)
      @path = path
      raise ArgumentError, "Requires valid directory path" unless File.directory?(@path)
      @versions = []
    end
    
    def version(n)
      return @versions.select {|v| v.filename == "Version-#{n}.apversion"}.first
    end
    
  end
end