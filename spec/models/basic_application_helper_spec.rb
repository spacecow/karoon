require 'spec_helper'

describe BasicApplicationHelper do
  before(:each) do
    @obj = Object.new    
    @obj.extend(BasicApplicationHelper)
  end

  context "#jdistance_of_time_in_words" do
    before(:each) do
      @then = DateTime.parse('2012-03-29 16:00:00')
    end

    it "less than 5 seconds" do
      @obj.send(:jdistance_of_time_in_words,@then,@then,true).should eq "less than 5 seconds"
    end

    it "less than 10 seconds" do
      @now = DateTime.parse('2012-03-29 16:00:08')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "less than 10 seconds"
    end

    it "less than 20 seconds" do
      @now = DateTime.parse('2012-03-29 16:00:18')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "less than 20 seconds"
    end

    it "half a minute" do
      @now = DateTime.parse('2012-03-29 16:00:28')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "half a minute"
    end

    it "less than a minutes" do
      @now = DateTime.parse('2012-03-29 16:00:49')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "less than a minute"
    end

    it "1 minute" do
      @now = DateTime.parse('2012-03-29 16:01:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "1 minute"
    end

    it "44 minutes" do
      @now = DateTime.parse('2012-03-29 16:44:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "44 minutes"
    end
    
    it "about 1 hour" do
      @now = DateTime.parse('2012-03-29 16:54:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "about 1 hour"
    end
    
    it "about 8 hours" do
      @now = DateTime.parse('2012-03-29 23:54:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "about 8 hours"
    end
    
    it "1 day" do
      @now = DateTime.parse('2012-03-30 23:54:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "1 day"
    end

    it "16 days" do
      @now = DateTime.parse('2012-04-14 23:54:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "16 days"
    end

    it "about 1 month" do
      @now = DateTime.parse('2012-04-30 23:54:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "about 1 month"
    end

    it "2 months" do
      @now = DateTime.parse('2012-05-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "2 months"
    end

    it "1 year" do
      @now = DateTime.parse('2013-05-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "about 1 year"
    end

    it "2 year" do
      @now = DateTime.parse('2014-05-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "about 2 years"
    end

    it "over 1 year" do
      @now = DateTime.parse('2013-07-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "over 1 year"
    end
    
    it "over 2 years" do
      @now = DateTime.parse('2014-07-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "over 2 years"
    end
    
    it "over 3 years" do
      @now = DateTime.parse('2015-01-28 16:14:21')
      @obj.send(:jdistance_of_time_in_words,@then,@now,true).should eq "almost 3 years"
    end
  end
end
