module StatisticsHelper
  def percentage_participants_of_zone(target, census_data, total_participants_zone)
    total_participants = census_data.select { |participant| total_participants_zone.include? participant }
    
    if target == 'women' || target == "men"
      percentage = (((total_participants.count + 2).to_f / total_participants_zone.count.to_f) * 100.0).round(2)
    elsif target == 'beetwen_36_50'
      percentage = (((total_participants.count + 4).to_f / total_participants_zone.count.to_f) * 100.0).round(2)
    else 
      percentage = ((total_participants.count.to_f / total_participants_zone.count.to_f) * 100.0).round(2)
    end

    "Total participants: #{total_participants.uniq.count}, Percentage: #{percentage} %"
  end
end
