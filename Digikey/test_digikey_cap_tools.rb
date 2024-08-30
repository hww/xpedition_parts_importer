

#!/bin/ruby
$LOAD_PATH << '.'
require 'test/unit'
require 'cap_tools'


class DigikeyCapToolsTest < Test::Unit::TestCase
  def setup
    ## Nothing really
  end
  
  def teardown
    ## Nothing really
  end
  def test_a
      assert_equal(1.0, DigikeyCapTools.convert_capacity("1F") )
      assert_equal(0.001, DigikeyCapTools.convert_capacity("1MF") )
      assert_equal(0.000001, DigikeyCapTools.convert_capacity("1UF") )
      assert_equal(0.000000001, DigikeyCapTools.convert_capacity("1NF") )
      assert_equal(0.000000000001, DigikeyCapTools.convert_capacity("1PF") )
      assert_equal(0.000000000000001, DigikeyCapTools.convert_capacity("0.001PF") )


      assert_equal(1.0, DigikeyCapTools.convert_capacity("1F") )
      assert_equal(0.001, DigikeyCapTools.convert_capacity("1M") )
      assert_equal(0.000001, DigikeyCapTools.convert_capacity("1U") )
      assert_equal(0.000000001, DigikeyCapTools.convert_capacity("1N") )
      assert_equal(0.000000000001, DigikeyCapTools.convert_capacity("1P") )
      assert_equal(0.000000000000001, DigikeyCapTools.convert_capacity("0.001P") )
  end
end