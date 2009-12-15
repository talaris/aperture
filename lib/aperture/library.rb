require 'find'

module Aperture
  class Library
    attr_reader :root, :photos
    
    def initialize(root)
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = Aperture::PhotoSet.new
    end    
    
    def self.parse(root_path)
      library = new(root_path)

      Find.find(library.root) do |path|
        if path =~ /Version-.+\.apversion$/
          directory = File.dirname(path)
          filename = File.basename(path)
          
          photo =  library.find_photo_by_path(directory) || library.add_photo(directory)
          attributes = Plist::parse_xml( path )
          photo.versions << Version.new(filename, attributes, photo)
        end
      end

      return library
    end
    
    def find_photo_by_path(path)
      return @photos.select {|p| p.path == path}.first
    end
    
    def add_photo(directory)  
      photo = Photo.new(directory)
      @photos << photo
      return photo
    end
  end
end