
module Aperture
  class Project
    attr_accessor :photos, :attributes
    
    def initialize(attributes = {})
      @attributes = attributes
      @photos = PhotoSet.new
    end
  end
end