class Audit < ActiveRecord::Base
  serialize :election_data_hash
  attr_accessible :display_name, :election_data_hash, :district_set, :district_set_id
  
  has_many :alerts
  
  belongs_to :district_set

  # Applies transforms to @hash based on alerts
  def apply_alerts
    alerts.each{ |alert|
      if alert.alert_type == "no_jurisdiction" && alert.choice == "use_current"
        election_data_hash["ballot_info"]["jurisdiction_display_name"] = district_set.display_name
        self.save!
        alerts.delete(alert)
      end
    }
  end

  # Audits @hash (without touching it), producing more @alerts
  def audit
    if not election_data_hash["ballot_info"]["jurisdiction_display_name"]
      if district_set
        alerts << Alert.new(:message => "No jurisdiction name specified.", :alert_type => "no_jurisdiction", :options => 
          {:use_current => "Use current jurisdiction #{district_set.display_name}", :abort => "Abort import"}, :default_option => :use_current)
      else
        raise "No current jurisdiction and no jurisdiction in YAML file. Choose a jurisdiction before importing."
      end
    end
  end

end