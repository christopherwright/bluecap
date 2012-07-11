require 'helper'

describe 'Attributes handler' do

  before do
    Bluecap.redis.flushall
    @attributes = Bluecap::Attributes.new
  end

  it 'should create attributes key' do
    @attributes.key('gender', 'male').should eq('attributes:gender:male')
  end

  it 'should create attributes key using cleaned name and date' do
    @attributes.key(' COUNTRY', 'Australia').should eq('attributes:country:australia')
  end

  it 'should track attributes for user by setting corresponding bits to 1' do
    data = {
      attributes: {
        hash: {
          gender: 'male',
          country: 'australia',
        },
        id: 5
      }
    }

    # Confirm data is empty before handling attributes.
    Bluecap.redis.getbit('attributes:gender:male', data[:attributes][:id])
      .should eq(0)
    Bluecap.redis.getbit('attributes:country:australia', data[:attributes][:id])
      .should eq(0)

    @attributes.handle(data)

    # Check that bits have changed.
    Bluecap.redis.getbit('attributes:gender:male', data[:attributes][:id])
      .should eq(1)
    Bluecap.redis.getbit('attributes:country:australia', data[:attributes][:id])
      .should eq(1)

    # For good measure, confirm that other bits have been left untouched.
    Bluecap.redis.getbit('attributes:gender:male', data[:attributes][:id] - 1)
      .should eq(0)
  end

end
