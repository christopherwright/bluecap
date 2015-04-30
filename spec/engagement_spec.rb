require 'helper'

describe Bluecap::Engagement do
  before do
    Bluecap.redis.flushall

    @date = Date.parse('20120701')
    @initial_event = 'Sign Up'
    @engagement_event = 'Logged In'
    @attributes = {:country => 'Australia', :age => 31}
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
    @report_id = 1
    @cohort = Bluecap::Cohort.new :initial_event => @initial_event,
      :date => @date,
      :report_id => @report_id
    end
  end

  it 'should measure engagement for a cohort' do
    @users.values.each do |id|
      event = Bluecap::Event.new :id => id,
        :name => @engagement_event,
        :timestamp => (@date + 1).to_time.to_i
      event.handle
    end
    event = Bluecap::Event.new :id => @users[:charlotte],
      :name => @engagement_event,
      :timestamp => (@date + 2).to_time.to_i
    event.handle

    engagement = Bluecap::Engagement.new :cohort => @cohort,
      :engagement_event => @engagement_event,
      :start_date => (@date + 1),
      :end_date => (@date + 2),
      :report_id => @report_id
    results = engagement.measure

    results.should include '20120702' => 100.0,
      '20120703' => 50.0
  end

end
