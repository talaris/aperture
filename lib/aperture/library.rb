require 'find'

module Aperture
  class Library
    attr_reader :root, :photos
    def initialize(root)
      raise ArgumentError unless File.directory?(root)
      @root = root 
      @photos = []
    end
    
    def index
      Find.find(root) do |path|
        
      end
    end
    
    def each
      
    end
  end
end