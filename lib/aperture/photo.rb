
module Aperture
  # = Overview
  # The Photo object is built from two files (.apmaster and .apfile) for each file imported 
  # into an Aperture Library. Photo objects have attributes for the path it was found at. It's
  # associated Version objects. As well as any Album objects it belongs to and the Project it's 
  # inside. Also it has twxo sets of attribute hashs one from the .apmaster file and the other
  # from the .apfile file.
  class Photo
    attr_accessor :path, :versions, :albums, :project, :file_attributes, :master_attributes
    
    # creates a new Photo object give a +path+ which is where the directory for the photo and 
    # it's metadata are found on disk.
    def initialize(path)
      @path = path
      raise ArgumentError, "Requires valid directory path" unless File.directory?(@path)
      @versions = []
      @albums = []
    end
    
    # Takes a interger and returns back the Version object that matches the number
    def version(n)
      return @versions.select {|v| v.filename == "Version-#{n}.apversion"}.first
    end
    
  end
end