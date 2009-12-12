require 'helper'

class TestLibrary < Test::Unit::TestCase
  context "#initialize" do
    setup do
      @library = Library.new(SAMPLE_LIBRARY_PATH)
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
    
    should "create a new library object" do
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
      @library = Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
    end

    should "find 24 photos" do
      assert_equal @library.photos.size, 24
    end
    
    should "find 1 versions in IMG_1753" do
      photo = @library.find_photo_by_path(SAMPLE_PHOTO_PATH)
      assert_equal photo.versions.size, 1
    end
    
    should "find 11 version of 2008-Costume Contest" do
      photo = @library.find_photo_by_path(File.join(SAMPLE_LIBRARY_PATH, '/Misc.approject/2009-12-10 @ 04:11:58 PM - 2.apimportgroup/2008-Costume Contest 030'))
      assert_equal photo.versions.size, 11
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
  
  context "photo_count" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
    end

    should "should return all 24 photos" do
      assert_equal @library.photo_count, 24
    end
  end
  
  context "version_count" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
    end

    should "should return all 34 versions" do
      assert_equal @library.version_count, 34
    end
  end
  
  context "camera_model_count_hash" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
      @library.parse_all
    end

    should "Find 6 photos from 'Canon PowerShot SD770 IS'" do
      camera_model = 'Canon PowerShot SD770 IS'
      assert_equal @library.camera_model_count_hash[camera_model], 12
    end
  end
  
  context "lens_model_count_hash" do
    setup do
      @library = Aperture::Library.new(SAMPLE_LIBRARY_PATH)
      @library.index
      @library.parse_all
    end

    should "Find 6 photos from lens '6.2-18.6 mm'" do
      lens_model = '6.2-18.6 mm'
      assert_equal @library.lens_model_count_hash[lens_model], 12
    end
  end
  
end
