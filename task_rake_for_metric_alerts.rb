class TaskRakeForMetricAlerts
  include Delayed::RecurringJob
  run_every 3.minutes
  
  # METRIC_TYPES = ["voltage_line_1", "voltage_line_2", "current_line_1", "current_line_2", "water_depth"]
  
  def perform
    
    users = User.all
    
    users.each do |user|
      
      alerts = user.alerts.unarchived.enabled
      
      alerts.each do |alert|
        
        well = Well.find(alert.well_id)
        metrics = Well_Metric.all(:conditions => ["well_id = ? AND created_at IN (?)", well.id, (alert.last_scanned_at.to_date)..Time.now])
        
        metrics.each do |metric|
          
          
          if (alert.type == "voltage_line_1_upper" && metric.metric_type == "voltage_line_1")
             
            if(metric.value > alert.float_value)
              fault = Fault.build(:well_id => well.id,
                                  :user_id => user.id,
                                  :well_metric_id => metric.id,
                                  :alert_id => alert.id
                                  :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
              
          elsif (alert.type == "voltage_line_1_lower" && metric.metric_type == "voltage_line_1" )
          
            if(metric.value < alert.float_value)
              fault = Fault.build(:well_id => well.id,
                                  :user_id => user.id,
                                  :well_metric_id => metric.id,
                                  :alert_id => alert.id
                                  :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
     
          elsif (alert.type == "voltage_line_2_upper" && metric.metric_type == "voltage_line_2")
          
            if(metric.value > alert.float_value)
              fault = Fault.build(:well_id => well.id,
                                :user_id => user.id,
                                :well_metric_id => metric.id,
                                :alert_id => alert.id
                                :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
            
          elsif (alert.type == "voltage_line_2_lower" && metric.metric_type == "voltage_line_2")
          
            if(metric.value < alert.float_value)
              fault = Fault.build(:well_id => well.id,
                              :user_id => user.id,
                              :well_metric_id => metric.id,
                              :alert_id => alert.id
                              :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
          
          elsif (alert.type == "current_line_1_upper" && metric.metric_type == "current_line_1")
          
            if(metric.value > alert.float_value)
              fault = Fault.build(:well_id => well.id,
                              :user_id => user.id,
                              :well_metric_id => metric.id,
                              :alert_id => alert.id
                              :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
            
          elsif (alert.type == "current_line_1_lower" && metric.metric_type == "current_line_1")
            
            if(metric.value < alert.float_value)
              fault = Fault.build(:well_id => well.id,
                              :user_id => user.id,
                              :well_metric_id => metric.id,
                              :alert_id => alert.id
                              :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
          
          elsif (alert.type == "current_line_2_upper" && metric.metric_type == "current_line_2")
  
            if(metric.value > alert.float_value)
              fault = Fault.build(:well_id => well.id,
                            :user_id => user.id,
                            :well_metric_id => metric.id,
                            :alert_id => alert.id
                            :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
              
          elsif (alert.type == "current_line_2_lower" && metric.metric_type == "current_line_2")
              
            if(metric.value < alert.float_value)
              fault = Fault.build(:well_id => well.id,
                            :user_id => user.id,
                            :well_metric_id => metric.id,
                            :alert_id => alert.id
                            :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
              
          elsif (alert.type == "water_depth_upper" && metric.metric_type == "water_depth")
          
            if(metric.value > alert.float_value)
              fault = Fault.build(:well_id => well.id,
                            :user_id => user.id,
                            :well_metric_id => metric.id,
                            :alert_id => alert.id
                            :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
              
          elsif (alert.type == "water_depth_lower" && metric.metric_type == "water_depth")
          
            if(metric.value < alert.float_value)
              fault = Fault.build(:well_id => well.id,
                          :user_id => user.id,
                          :well_metric_id => metric.id,
                          :alert_id => alert.id
                          :type => alert.type)
              # SEND EMAIL/TEXT BROWSER NOTIFICATION
            end
          
        end
          
        alert.last_scanned_at = Time.now
        alert.save
        
      end
    end
  end
end