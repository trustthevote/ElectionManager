require 'test_helper'
require 'pp'


class PrecinctTest < ActiveSupport::TestCase
  context "basic test" do
    should "able to create new precinct" do
      prec = Precinct.new(:display_name => "i am new")
      prec.save!
      pp prec
   end
  end
end