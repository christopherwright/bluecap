require 'helper'

describe Bluecap::Event do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Event.new :id => 3, :name => 'Sign Up', :timestamp => 1341845456
  end

  it 'should convert unix timestamps to strings in %Y%m%d format' do
    subject.date.should == '20120710'
  end

  it 'should create event key using cleaned name and date' do
    subject.key.should == 'events:sign.up:20120710'
  end

  it 'should track event for user by setting corresponding bit to 1' do
    subject.handle
    Bluecap.redis.getbit(subject.key, subject.id).should == 1
  end

end
