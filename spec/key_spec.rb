require 'bluecap/keys'

describe Bluecap::Keys do

  it 'should strip surrounding whitespace from string' do
    subject.clean('  paid  ').should eq('paid')
  end

  it 'should not allow capital letters in string' do
    subject.clean('SignUp').should eq('signup')
  end

  it "should convert non-alphanumeric characters that aren't
  leading/trailing to periods" do
    subject.clean('  logged in  ').should eq('logged.in')
  end

end

