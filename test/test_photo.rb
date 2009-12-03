require 'helper'


class TestPhoto < Test::Unit::TestCase
  context "intialize" do
    setup do
      @photo = Aperture::Photo.new(SAMPLE_PHOTO_PATH)
    end

    should "require a valid directory" do
      assert_raise ArgumentError do
        Aperture::Photo.new()
      end
    end
    
    should "required path should be a directory" do
      assert_raise ArgumentError do
        Aperture::Photo.new('root')
      end
    end
    
    should "create a new object" do
      assert_instance_of(Aperture::Photo, @photo)
    end
    
    should "set path is a directory" do
      assert File.directory?(@photo.path)
    end
    
    should "set versions to an empty array" do
      assert_equal @photo.versions, []
    end
    
  end
  
  context "<<" do
    setup do
      @photo = Aperture::Photo.new(SAMPLE_PHOTO_PATH)
    end

    should "add a version" do
      @photo << Aperture::Version.new("test")
      assert_equal @photo.versions.size, 1
    end
  end
  
  context "each" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
      @photo = @library.first
    end

    should "iterate over all versions" do
      
    end
    
    should "map should work" do
      assert_equal @photo.map {|p| p.class}, [Aperture::Version]*2
    end
  end
  
  
  
end
