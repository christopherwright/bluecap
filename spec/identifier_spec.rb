require 'helper'

describe 'Identifier' do

  before do
    Bluecap.redis.flushall
  end

  it 'should identify users with an incremental counter' do
    Bluecap.redis.get('user.ids').should eq nil 
    identifier = Bluecap::Identifier.new
    identifier.handle({identifier: 'Andy'})
    Bluecap.redis.get('user.ids').should eq '1'
    identifier.handle({identifier: 'Evelyn'})
    Bluecap.redis.get('user.ids').should eq '2'
  end

  it 'should not increment identifying counter for the same user' do
    Bluecap.redis.get('user.ids').should eq nil 
    identifier = Bluecap::Identifier.new
    identifier.handle({identifier: 'Andy'})
    Bluecap.redis.get('user.ids').should eq '1'
    identifier.handle({identifier: 'Andy'})
    Bluecap.redis.get('user.ids').should eq '1'
  end

end
