require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class CountryTest < Test::Unit::TestCase
  context "Country Model" do
    should 'construct new instance' do
      @country = Country.new
      assert_not_nil @country
    end
  end
end
