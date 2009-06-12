class TermsController < LisController
  def model
    Term
  end
  def resource
    "term"
  end
  def filterable_on
    [:person_sourced_id]
  end
end
