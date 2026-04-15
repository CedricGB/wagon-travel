class CreateActivitiesTool < RubyLLM::Tool
  description "Create an activity"
  param :plan_id, desc: "The ID of the plan", type: :integer
  param :name, desc: "The name of the activity"
  param :cost, desc: "The cost of the activity", type: :number

  def execute(name:, cost:, plan_id:)
    plan = Plan.find(plan_id)
    activity = Activity.create!(
      plan: plan,
      name:,
      cost:
    )
    { plan_id: plan.id, cost: activity.cost, name: activity.name }
  rescue ActiveRecord::RecordNotFound
    { error: "Plan not found" }
  rescue ActiveRecord::RecordInvalid => e
    { error: e.message }
  end
end
