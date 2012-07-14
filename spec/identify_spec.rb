require 'helper'

describe Bluecap::Identify do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Identify.new('Andy')
  end

  it 'should identify users with an incremental counter' do
    subject.handle
    Bluecap::Identify.new('Evelyn').handle.should == 2
  end

  it 'should not increment identifying counter for the same user' do
    subject.handle
    subject.handle.should == 1
  end

end
