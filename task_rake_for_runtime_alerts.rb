class TaskRakeForRuntimeAlerts
  include Delayed::RecurringJob
  run_every 1.minute
  
  def perform
    users = User.all
    
    users.each do |user|
      
      alerts = user.alerts.unarchived.enabled
      
      alerts.each do |alert|
        
        well = Well.find(alert.well_id)
        hour_span = alert.span.to_i
        
        
        if (alert.type == "pump_cycles_upper" )
          
          time = hour_span.hours.ago
          events = well.events.stop_events_since(time)
          
          if (events.length > alert.value)
            
            fault = Fault.build(:well_id => well.id,
                                :user_id => user.id,
                                :alert_id => alert.id
                                :type => alert.type)
            # SEND EMAIL/TEXT BROWSER NOTIFICATION
            
          end
          
        elsif (alert.type == "pump_cycles_lower")
        
          time = hour_span.hours.ago
          events = well.events.stop_events_since(time)
          
          if (events.length < alert.value)
            
            fault = Fault.build(:well_id => well.id,
                                :user_id => user.id,
                                :alert_id => alert.id
                                :type => alert.type)
            # SEND EMAIL/TEXT BROWSER NOTIFICATION
          end
          
        elsif (alert.type == "pump_runtime_upper" && well.events.last.event == "SWITCHED_ON" )
          
          last_event = well.events.last
          last_event_happended = Time.now - last_event.created_at
          
          if (last_event_happended > hour_span.hours)
            fault = Fault.build(:well_id => well.id,
                              :user_id => user.id,
                              :alert_id => alert.id
                              :type => alert.type)
            # SEND EMAIL/TEXT BROWSER NOTIFICATION
          end
        
          
        elsif (alert.type == "pump_runtime_lower" && well.events.last.event == "SWITCHED_OFF")
        
          last_event = well.events.last
          last_event_happended = Time.now - last_event.created_at
          
          if (last_event_happended > hour_span.hours)
            fault = Fault.build(:well_id => well.id,
                              :user_id => user.id,
                              :alert_id => alert.id
                              :type => alert.type)
            # SEND EMAIL/TEXT BROWSER NOTIFICATION
          end
        end
      end
    end
  end
end