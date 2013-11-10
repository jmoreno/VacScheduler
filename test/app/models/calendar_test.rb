require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class CalendarTest < Test::Unit::TestCase
  context "Calendar Model" do
    should 'construct new instance' do
      @calendar = Calendar.new
      assert_not_nil @calendar
    end
  end
end
