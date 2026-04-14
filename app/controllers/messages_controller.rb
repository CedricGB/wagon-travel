class MessagesController < ApplicationController
  SYSTEM_PROMPT = "
  Tu es un assistant de voyage.

  Tu dois poser les questions suivantes UNE PAR UNE :
  1. Destination
  2. Budget
  3. Durée
  4. Type de logement
  5. Activités

  Ne pose qu'une seule question à la fois.
  Attends la réponse avant de continuer.
  "


  def create
    @plan = Plan.find(params[:plan_id])
    @chat = @plan.chat

    # 1. MESSAGE USER
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save

      # 2. APPEL IA
      ruby_llm_chat = RubyLLM.chat

      response = ruby_llm_chat
      .with_instructions(SYSTEM_PROMPT)
      .ask(@message.content)
      #  3. MESSAGE IA
      Message.create(
        role: "assistant",
        content: response.content,
        chat: @chat
      )

      redirect_to plan_path(@plan)

    else
      render "plans/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
