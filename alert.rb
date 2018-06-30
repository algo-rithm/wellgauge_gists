class Alert < ActiveRecord::Base
    
    TYPES = [   "connection",
                "voltage_line_1_upper", 
                "voltage_line_1_lower", 
                "voltage_line_2_upper", 
                "voltage_line_2_lower",
                "current_line_1_upper",
                "current_line_1_lower",
                "current_line_2_upper",
                "current_line_2_lower",
                "water_depth_upper",
                "water_depth_lower",
                "pump_cycles_upper",
                "pump_cycles_lower",
                "pump_runtime_upper",
                "pump_runtime_lower"]
                
    STATUS = [  "ACTIVE", "DISABLED"  ]
    
    belongs_to :user
    belongs_to :well
    
    validates_presence_of :well_id, :name, :type
    validates_inclusion_of :type, in: TYPES, :message => "Alert Type needs to be either #{TYPES.to_sentence(two_words_connector: ' or ', last_word_connector: ' or ')}", :if => Proc.new{ |p| p.type.present?}
    
    default_scope { unarchived }
    scope :unarchived, -> { where(archived: false) }
    scope :of_id, -> (id) { where(id: id) }
    scope :of_well, -> (well) { where(well: well) }
    scope :enabled, -> { where(enabled: true) }
    scope :of_type, -> (type) { where(type: type) }
    scope :of_status, -> (status) { where(status: status) }
    scope :exceeds_upper_float, -> (value) { where ("value > ?"), value }
    scope :exceeds_lower_float, -> (value) { where ("value < ?"), value }
    
    def archive!
        self.archived = true
        self.name = self.name + "--Archived--" + Util.generate_uid
        return self.save
    end
    
    def show_json
        {
            id: self.id,
            user: self.user.show_json,
            wg_sn: self.well.wg_sn,
            name: self.name,
            enabled: self.enabled,
            status: self.status,
            type: self.type,
            value: self.value,
        }
    end
    
    class << self
        def basic_search(params={})
            scope = Alert
            scope = scope.ordered
            
            if params[:page].present?
                scope = scope.offset(params[:page][:offset]) if params[:page][:offset].present?
                scope = scope.limit(params[:page][:limit]) if params[:page][:limit].present?
            end
            
            return scope
        end
        
        
    end
    
end

# == Schema Information
#
# Table name: alerts
#
#  id         :integer          not null, primary key
#  well_id    :integer          not null
#  user_id    :integer          not null
#  name       :string           not null
#  enabled    :boolean          default(TRUE), not null
#  type       :string           not null
#  status     :string           not null
#  archived   :boolean          default(FALSE)
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_alerts_on_user_id  (user_id)
#  index_alerts_on_well_id  (well_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (well_id => wells.id)
#
