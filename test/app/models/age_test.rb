require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class AgeTest < Test::Unit::TestCase
  context "Age Model" do
    should 'construct new instance' do
      @age = Age.new
      assert_not_nil @age
    end
  end
end
