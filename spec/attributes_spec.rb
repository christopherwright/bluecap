require 'helper'

describe Bluecap::Attributes do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Attributes.new :id => 3,
      :attributes => {:country => 'Australia', :gender => 'Female'}
  end

  it 'should create attributes key' do
    subject.key('gender', 'female').should == 'attributes:gender:female'
  end

  it 'should create attributes key using cleaned name and date' do
    subject.key(' COUNTRY', 'Australia').should == 'attributes:country:australia'
  end

  it 'should create keys for multiple attributes' do
    subject.keys.should =~ ['attributes:country:australia',
                            'attributes:gender:female']
  end

  it 'should track attributes for user by setting corresponding bits to 1' do
    data = {
      attributes: {
        gender: 'female',
        country: 'australia',
      },
      id: 5
    }

    subject.handle

    # Check that bits have changed.
    Bluecap.redis.getbit('attributes:gender:female', subject.id).should == 1
    Bluecap.redis.getbit('attributes:country:australia', subject.id).should == 1
  end

end
