# == Schema Information
# Schema version: 20100813053101
#
# Table name: ballot_styles
#
#  id                :integer         not null, primary key
#  display_name      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  ballot_style_code :string(255)
#

class BallotStyle < ActiveRecord::Base
  # TODO: rename ballot_style_code attribute to code
end
