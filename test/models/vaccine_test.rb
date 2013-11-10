require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class VaccineTest < Test::Unit::TestCase
  context "Vaccine Model" do
    should 'construct new instance' do
      @vaccine = Vaccine.new
      assert_not_nil @vaccine
    end
  end
end
