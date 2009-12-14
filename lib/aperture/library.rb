require 'find'

module Aperture
  class Library
    attr_reader :root, :photos
    
     
    def initialize(root)
      raise ArgumentError, "Requires valid directory path" unless File.directory?(root)
      @root = root 
      @photos = Aperture::PhotoSet.new
    end
    
    def index
      Find.find(root) do |path|
        if path =~ /Version-.+\.apversion$/
          directory = File.dirname(path)
          filename = File.basename(path)
          
          photo =  find_photo_by_path(directory) || add_photo(directory)
          photo.versions << Version.new(filename, photo)
        end
      end
    end
    
    def parse_all
      @photos.each do |photo|
        photo.parse_all
      end        
    end
    
    
    def self.parse(root_path)
      library = new(root_path)
      library.index
      library.parse_all
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