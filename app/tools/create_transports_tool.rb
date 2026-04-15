class CreateTransportsTool < RubyLLM::Tool
  description "Create a transportation"
  param :plan_id, desc: "The ID of the plan", type: :integer
  param :name, desc: "The name of the transportation"
  param :cost, desc: "The cost of the trasnportation", type: :number

  def execute(name:, cost:, plan_id:)
    plan = Plan.find(plan_id)
    transport = Transport.create!(
      plan: plan,
      name:,
      cost:
    )
    { plan_id: plan.id, cost: transport.cost, name: transport.name }
  rescue ActiveRecord::RecordNotFound
    { error: "Plan not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
