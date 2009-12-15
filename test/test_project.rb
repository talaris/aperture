require 'helper'


class TestProject < Test::Unit::TestCase
  context "intialize" do
    setup do
      @project = Project.new( Hash.new )
    end
    
    should "create a new project object" do
      assert_instance_of Aperture::Project, @project
    end
    
    should "pass a hash as valid attirbutes" do
      assert_instance_of Hash, @project.attributes
    end
  end
  
  
end