class CreateLogementsTool < RubyLLM::Tool
  description "Create an logements"
  param :plan_id, desc: "The ID of the plan", type: :integer
  param :name, desc: "The name of the logement"
  param :cost, desc: "The cost of the logement", type: :number

  def execute(name:, cost:, plan_id:)
    plan = Plan.find(plan_id)
    logement = Logement.create!(
      plan: plan,
      name:,
      cost:
    )
    { plan_id: plan.id, cost: logement.cost, name: logement.name }
  rescue ActiveRecord::RecordNotFound
    { error: "Plan not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
