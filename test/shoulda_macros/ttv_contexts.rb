class ActiveSupport::TestCase
  def self.setup_precincts
    context "valid precincts" do
      setup do
        # create a precint within 4 Districts
        @p1 = Precinct.create!(:display_name => "Precint 1")
        (0..3).each do |i|
          @p1.districts << District.new(:display_name => "District #{i}", :district_type => DistrictType::COUNTY)
        end
        
        # create another precint with another set of 4 Districts
        @p2 = Precinct.create!(:display_name => "Precint 2")      
        (4..7).each do |i|
          @p2.districts << District.create!(:display_name => "District #{i}", :district_type => DistrictType::COUNTY)
        end

        # create a set of districts that are not associated with any precincts
        (8..11).each do |i|
          District.create!(:display_name => "District #{i}", :district_type => DistrictType::COUNTY)
        end
      end # end setup
      
      yield
      
    end #end context
  end # end setup_precincts method
  
  def self.setup_jurisdictions
    setup_precincts do

      context "valid jurisdictions and elections" do
        setup do
          # create a district set with only the first 2 districts in the
          # first precinct
          ds1  = DistrictSet.create!(:display_name => "District Set 1")
          ds1.districts << District.find_by_display_name("District 0")
          ds1.districts << District.find_by_display_name("District 1")
          ds1.save!
          
          # create another district set that is associated first 2 districts
          # in the second precinct
          ds2  = DistrictSet.create!(:display_name => "District Set 2")
          ds2.districts << District.find_by_display_name("District 4")
          ds2.districts << District.find_by_display_name("District 5")
          ds2.save!

          # create 2 elections each associated with a district set
          @e1 = Election.create!(:display_name => "Election 1", :district_set => ds1)
          @e2 = Election.create!(:display_name => "Election 2", :district_set => ds2)

        end # end setup
        
        yield
        
      end # end context
    end # end setup_precinct
  end # end setup_jurisdictions

  def self.setup_question_requesters
    
    setup_jurisdictions do     
      
      context "valid question requesters" do
        setup do

          # create 4 questions that where requested by the district 0,
          # district 0 is associated with the first precinct 
          d0 =  District.find_by_display_name("District 0")
          (0..3).each do |i|
            q = Question.new(:display_name => "Question #{i}", :question => "what is #{i}")
            q.requesting_district = d0
            q.election = @e1
            q.save!
          end

          # create 4 questions that where requested by the district 4,
          # district 2 is overlaps the second precinct 
          d4 =  District.find_by_display_name("District 4")
          
          (4..7).each do |i|
            q = Question.new(:display_name => "Question #{i}", :question => "what is #{i}")
            q.requesting_district = d4
            q.election = @e2
            q.save!

          end
        end # end setup
        # yield to the context in the test
        yield
        
      end # end context
    end # #end setup_jurisdictions block
  end # end setup_question_reminders
  
end