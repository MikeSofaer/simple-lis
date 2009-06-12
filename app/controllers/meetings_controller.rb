class MeetingsController < LisController
  def model
    Meeting
  end
  def resource
    "meeting"
  end
  def filterable_on
    [:target_sourced_id]
  end
end
