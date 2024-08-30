

#!/bin/ruby
$LOAD_PATH << '.'
require 'test/unit'
require 'cap_tools'

class CapToolsTest  < Test::Unit::TestCase
    def setup
      ## Nothing really
    end
    
    def teardown
      ## Nothing really
    end
    def test_description
        # F
        assert_equal("1F", CapTools.description_captiance_f_to_s(1.0) )
        assert_equal("1.2F", CapTools.description_captiance_f_to_s(1.2) )
        # mF
        assert_equal("1mF", CapTools.description_captiance_f_to_s(1.0 / 1000) )
        assert_equal("1.2mF", CapTools.description_captiance_f_to_s(1.2 / 1000) )
        # uF
        assert_equal("1uF", CapTools.description_captiance_f_to_s(1.0 / 1000000) )
        assert_equal("1.2uF", CapTools.description_captiance_f_to_s(1.2 / 1000000) )
        # nF
        assert_equal("1nF", CapTools.description_captiance_f_to_s(1.0 / 1000000000) )
        assert_equal("1.2nF", CapTools.description_captiance_f_to_s(1.2/ 1000000000) )
        # pF
        assert_equal("1pF", CapTools.description_captiance_f_to_s(1.0 / 1000000000000) )
        assert_equal("1.2pF", CapTools.description_captiance_f_to_s(1.2/ 1000000000000) )
        assert_equal("0.001pF", CapTools.description_captiance_f_to_s(1.0 / 1000000000000000) )
        assert_equal("0.0012pF", CapTools.description_captiance_f_to_s(1.2/ 1000000000000000) )
    end
    def test_value
        # F
        assert_equal("1F", CapTools.captiance_f_to_s(1.0) )
        assert_equal("1F2", CapTools.captiance_f_to_s(1.2) )
        # mF
        assert_equal("1mF", CapTools.captiance_f_to_s(1.0 / 1000) )
        assert_equal("1m2", CapTools.captiance_f_to_s(1.2 / 1000) )
        # uF
        assert_equal("1uF", CapTools.captiance_f_to_s(1.0 / 1000000) )
        assert_equal("1u2", CapTools.captiance_f_to_s(1.2 / 1000000) )
        # nF
        assert_equal("1nF", CapTools.captiance_f_to_s(1.0 / 1000000000) )
        assert_equal("1n2", CapTools.captiance_f_to_s(1.2/ 1000000000) )
        # pF
        assert_equal("1pF", CapTools.captiance_f_to_s(1.0 / 1000000000000) )
        assert_equal("1p2", CapTools.captiance_f_to_s(1.2/ 1000000000000) )
        assert_equal("0p001", CapTools.captiance_f_to_s(1.0 / 1000000000000000) )
        assert_equal("0p0012", CapTools.captiance_f_to_s(1.2/ 1000000000000000) )
    end
end
