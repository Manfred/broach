require File.expand_path('../../start', __FILE__)

class Mole
  include Broach::Attributes
end

describe "A class with Attributes" do
  before do
    @mole = Mole.new('name' => "Jerry", 'glasses' => false, 'description' => nil)
  end
  
  it "returns it's attribute through accessor methods" do
    @mole.name.should == "Jerry"
    @mole.glasses.should.be.false
    @mole.description.should.be.nil
  end
  
  it "does not respond to methods for attributes which haven't been set" do
    lambda {
      @mole.unknown
    }.should.raise(NoMethodError)
  end
end