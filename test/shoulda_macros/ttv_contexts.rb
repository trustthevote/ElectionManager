class ActiveSupport::TestCase
  # WARNING: This doesn't work in side of another context??
  # must be at the top level of the test??
  def self.login_as(options={})
    context "with logged in user and roles \"#{options[:roles]}\" " do
      setup do
        # get all but the roles
        user_options = options.except(:roles)
        @logged_in_user = User.make(user_options)
        options[:roles].each do |rn|
          @logged_in_user.roles << UserRole.make(:name => rn)
        end if options[:roles]
        
        # @logged_in_user.save!
        # login as one user
        UserSession.create!(@logged_in_user)
      end
      
      yield 
    end
  end
  
  def self.setup_user_roles(options={})
    options = {:role_name => 'guest'}.merge(options)
    
  end
  
  def self.setup_users(options={})
    options = {:count => 2, :uname => 'user', :dname => 'example.com', :pwd => "password"}.merge(options)
    count = options[:count]
    context " Creation of #{count} users" do
      setup do
        count.times do |i|
          User.create(:email => "#{options[:uname]}#{i}@#{options[:dname]}", :password => "#{options[:pwd]}#{i}", :password_confirmation => "#{options[:pwd]}#{i}")
        end
      end
      
      yield
      
    end
    
  end # end setup_users
  
# Set up a series of Precincts, PrecinctSplits, DistrictSets and Districts
  def self.setup_precincts
    context "valid precincts" do
      setup do
        # create a precinct with one precinct split
        setup_precinct "Precinct 1", 1
        @p1 = @prec_new

        # create another precinct with 3 precinct splits
        setup_precinct "Precinct 2", 3
        @p2 = @prec_new
      end # end setup
      
      yield
      
    end #end context
  end # end setup_precincts method
  
    
# todo old style jurisdictions. needs to become depracated
  def self.setup_jurisdictions
    setup_precincts do
      context "valid jurisdictions and elections" do
        setup do
          # create a district set with only the first 2 districts in the
          # first precinct
          ds1 = setup_districtset "DistrictSet A", 0, 3
          ds2 = setup_districtset "DistrictSet B", 4, 5

          # create 2 elections each associated with a district set
          @e1 = Election.create!(:display_name => "Election 1", :district_set => ds1)
          @e2 = Election.create!(:display_name => "Election 2", :district_set => ds2)

        end # end setup
        
        yield
        
      end # end context
    end # end setup_precinct
  end # end setup_jurisdictions

  def self.setup_contest_requesters
    
    setup_jurisdictions do

      context 'valid contest requesters' do
        
        setup do
        # Create contests that where requested by district 0

         open_seat_count = 2
         voting_method = VotingMethod::WINNER_TAKE_ALL
        
          d0 =  District.find_by_display_name("District 0")

          4.times do |i|
            c = Contest.new(:display_name => "Contest #{i}", :open_seat_count => open_seat_count)
            c.district = d0
            c.election = @e1
            c.voting_method = voting_method
            c.save!
            
          end
          
        end # end setup
        
        yield
        
      end  # end valid contest requesters context
      
    end # end setup_jurisdictions

  end # end setup_contest_requesters
  
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
