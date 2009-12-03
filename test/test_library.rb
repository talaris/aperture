require 'helper'

class TestLibrary < Test::Unit::TestCase
  context "#initialize" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
    end
    
    should "create require a path" do
      assert_raise ArgumentError do
        Aperture::Library.new()
      end
    end
    
    should "required path should be a directory" do
      assert_raise ArgumentError do
        Aperture::Library.new('root')
      end
    end
    
    should "create a new object" do
      assert_instance_of(Aperture::Library, @library)
    end
    
    should "set root is a directory" do
      assert File.directory?(@library.root)
    end
    
    should "set photos to an empty array" do
      assert_equal @library.photos, []
    end
  end
  
  context "#index" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
    end

    should "find 6 photos" do
      assert_equal @library.photos.size, 6
    end
    
    should "find 2 versions in IMG_1753" do
      photo = @library.find_photo_by_path(SAMPLE_PHOTO_PATH)
      assert_equal photo.versions.size, 2
    end
  end
  
  context "find_photo_by_path" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
      @photo = @library.find_photo_by_path(SAMPLE_PHOTO_PATH)
    end
    
    should "be a photo" do
      assert_instance_of(Aperture::Photo, @photo)
    end

    should "should pick out photo with same path" do
      assert_equal @photo.path, SAMPLE_PHOTO_PATH
    end
  end
  
  context "add_photo" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
    end

    should "add one photo to library" do
      @library.add_photo(SAMPLE_PHOTO_PATH)
      assert_equal @library.photos.size, 1
    end
  end
  
  context "each" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
    end

    should "iterate over all the photos" do
      versions = 0
      @library.each {|p| versions += p.versions.size}
      assert_equal versions, 12
    end
    
    should "give us access to inject" do
      versions = @library.map {|p| p.versions.size }
      assert_equal versions, [2]*6
    end
  end
  
  
  

end
