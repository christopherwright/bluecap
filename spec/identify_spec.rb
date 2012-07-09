require 'helper'

describe 'Identify handler' do

  before do
    Bluecap.redis.flushall
  end

  it 'should identify users with an incremental counter' do
    Bluecap.redis.get('user.ids').should eq nil 
    identify = Bluecap::Identify.new
    identify.handle({identify: 'Andy'}).should eq(1)
    identify.handle({identify: 'Evelyn'}).should eq(2)
    Bluecap.redis.get('user.ids').should eq '2'
  end

  it 'should not increment identifying counter for the same user' do
    Bluecap.redis.get('user.ids').should eq nil 
    identify = Bluecap::Identify.new
    identify.handle({identify: 'Andy'})
    identify.handle({identify: 'Andy'}).should eq(1)
  end

end