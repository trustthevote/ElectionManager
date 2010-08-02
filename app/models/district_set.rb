# == Schema Information
# Schema version: 20100215144641
#
# Table name: district_sets
#
#  id             :integer         not null, primary key
#  display_name   :string(255)
#  secondary_name :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class DistrictSet < ActiveRecord::Base
  has_and_belongs_to_many :districts
  has_many :elections
  has_many :audits
  has_attached_file :icon, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  has_many :jurisdiction_memberships, :class_name => "JurisdictionMembership"
  has_many :users, :through => :jurisdiction_memberships
  
  # returns all precincts in this district set
  def precincts
    precinct_ids = connection.select_values( <<-eos
      SELECT DISTINCT districts_precincts.precinct_id
      FROM	districts_precincts, district_sets_districts
      WHERE	district_sets_districts.district_set_id = #{self.id}
      AND	district_sets_districts.district_id = districts_precincts.district_id
    eos
    )
    Precinct.find(precinct_ids)
  end
  
end
