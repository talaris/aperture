require 'helper'

class TestLibrary < Test::Unit::TestCase
  context "#initialize" do
    should "create require a path" do
      assert_raise ArgumentError do
        library = Aperture::Library.new()
      end
    end
    
    should "required path should be a directory" do
      assert_raise ArgumentError do
        library = Aperture::Library.new('root')
      end
    end
    
    should "create a new object" do
      library = Aperture::Library.new(File.join(File.dirname(__FILE__), 'data'))
      assert_instance_of(Aperture::Library, library)
    end
  end
  
  context "#parse" do
    setup do
      
    end

    should "description" do
      
    end
  end
  
  

end
