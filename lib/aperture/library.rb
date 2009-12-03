require 'find'

module Aperture
  class Library
    include Enumerable
    attr_reader :root, :photos
    def initialize(root)
      raise ArgumentError unless File.directory?(root)
      @root = root 
      @photos = []
    end
    
    def index
      Find.find(root) do |path|
        if path =~ /\.apversion$/
          directory = File.dirname(path)
          filename = File.basename(path)
          photo =  find_photo_by_path(directory) || add_photo(directory) 
          photo << Version.new(filename)
        end
      end
    end
    
    def find_photo_by_path(path)
      @photos.select {|p| p.path == path}.first
    end
    
    def add_photo(directory)  
      photo = Photo.new(directory)
      @photos << photo
      photo
    end
    
    def each &blk
      @photos.each &blk
    end
    
  end
end