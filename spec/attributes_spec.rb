require 'helper'

describe Bluecap::Attributes do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Attributes.new :id => 3,
      :attributes => {:country => 'Australia', :age => 31}
  end

  it 'should create attributes key' do
    subject.key('age', 31).should == 'attributes:age:31'
  end

  it 'should create attributes key using cleaned name and date' do
    subject.key(' COUNTRY', 'Australia').should == 'attributes:country:australia'
  end

  it 'should create keys for multiple attributes' do
    subject.keys.should =~ ['attributes:country:australia',
                            'attributes:age:31']
  end

  it 'should track attributes for user by setting corresponding bits to 1' do
    data = {
      attributes: {
        age: 31,
        country: 'australia',
      },
      id: 5
    }

    subject.handle

    # Check that bits have changed.
    Bluecap.redis.getbit('attributes:age:31', subject.id).should == 1
    Bluecap.redis.getbit('attributes:country:australia', subject.id).should == 1
  end

end
