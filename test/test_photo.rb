require 'helper'


class TestPhoto < Test::Unit::TestCase
  context "intialize" do
    setup do
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
    end

    should "require a valid directory" do
      assert_raise ArgumentError do
        Photo.new()
      end
    end
    
    should "required path should be a directory" do
      assert_raise ArgumentError do
        Photo.new('root')
      end
    end
    
    should "create a new photo object" do
      assert_instance_of(Aperture::Photo, @photo)
    end
    
    should "set path is a directory" do
      assert File.directory?(@photo.path)
    end
    
    should "set versions to an empty array" do
      assert_equal @photo.versions, []
    end
    
  end

  context "version(n)" do
    setup do
      @photo = Photo.new(SAMPLE_PHOTO_PATH)
      @photo.versions << Version.new(SAMPLE_ORIGINAL_FILENAME, {}, @photo)
      @photo.versions << Version.new(SAMPLE_VERSION_FILENAME, {}, @photo)
    end

    should "pickout correct version number" do
      version = @photo.version(1)
      assert_equal "Version-1.apversion", version.filename
    end
  end
end
