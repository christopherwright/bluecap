require 'helper'
require 'date'

describe Bluecap::Cohort do

  before do
    Bluecap.redis.flushall

    @date = Date.parse('20120701')
    @initial_event = 'Sign Up'
    @attributes = {:country => 'Australia', :gender => 'Female'}
    @users = {
      :evelyn => Bluecap::Identify.new('Evelyn').handle,
      :charlotte => Bluecap::Identify.new('Charlotte').handle
    }
    @users.values.each do |id|
      event = Bluecap::Event.new :id => id,
        :name => @initial_event,
        :timestamp => @date.to_time.to_i
      event.handle

      attribute = Bluecap::Attributes.new  :id => id,
        :attributes => @attributes
      attribute.handle
    end
  end

  it 'should find cohort total for date' do
    cohort = Bluecap::Cohort.new :initial_event => @initial_event,
      :date => @date,
      :report_id => 1

    cohort.total.should == 2
  end

  it 'should not include in cohort if initial event did not occur on date' do
    sarah = Bluecap::Identify.new('Sarah').handle
    event = Bluecap::Event.new :id => sarah,
      :name => @initial_event,
      :timestamp => (@date + 1).to_time.to_i
    event.handle

    cohort = Bluecap::Cohort.new :initial_event => @initial_event,
      :date => @date,
      :report_id => 1
    cohort.total.should == 2
  end

  it 'should allow cohorts to be constructed with attributes of users' do
    cohort = Bluecap::Cohort.new :initial_event => @initial_event,
      :date => @date,
      :attributes => @attributes,
      :report_id => 1

    cohort.total.should == 2
  end

  it 'shold not include in cohort if attributes are not matched' do
    sarah = Bluecap::Identify.new('Sarah').handle
    event = Bluecap::Event.new :id => sarah,
      :name => @initial_event,
      :timestamp => @date.to_time.to_i
    event.handle
    attributes = @attributes.clone
    attributes[:country] = 'New Zealand'
    attribute = Bluecap::Attributes.new :id => sarah,
      :attributes => attributes
    attribute.handle

    cohort = Bluecap::Cohort.new :initial_event => @initial_event,
      :date => @date,
      :attributes => @attributes,
      :report_id => 1
    cohort.total.should == 2
  end

end
