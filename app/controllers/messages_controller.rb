class MessagesController < ApplicationController
  SYSTEM_PROMPT = "
    Tu es un assistant de voyage intelligent.

    OBJECTIF :
    Aider l’utilisateur à organiser un voyage complet.

    TON RÔLE :
    Tu peux :
    1. Poser des questions pour construire un plan
    2. Donner des recommandations (lieux, activités)
    3. Proposer des itinéraires (A → B)
    4. Donner des conseils pratiques (budget, sécurité, culture, santé)

    COMPORTEMENT :
    Si l’utilisateur n’a pas donné d’informations, pose des questions UNE PAR UNE :
    - destination
    - budget
    - durée
    - logement
    - activités

    Si l’utilisateur pose une question spécifique : réponds directement

    Si l’utilisateur demande :
    - “quoi faire” → donne 5 activités pertinentes => Si l'utilisateur donne des activitées, alors ajoute la à la base de données avec un cost en décimal avec uniquement 2 chiffres après la virgule
     - “quoi faire” → donne 5 logements pertinentes => Si l'utilisateur donne des logements, alors ajoute la à la base de données avec un cost en décimal avec uniquement 2 chiffres après la virgule
    - “itinéraire” → propose un trajet structuré
    - “infos pays” → donne :
      - règles légales
      - coutumes
      - nourriture
      - paiement
      - téléphone
      - vaccins

    STYLE :
    - clair
    - structuré
    - utile
    - humain

    FORMAT :
    - listes si utile
    - réponses concises
    - pas de blabla inutile

    À ÉVITER :
    - poser des questions si ce n’est pas nécessaire
    - répondre hors sujet
    - être trop vague"

  def create
    @plan = Plan.find(params[:plan_id])
    @chat = @plan.chat

    # 1. MESSAGE USER
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save

      # 2. APPEL IA
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      @response = @ruby_llm_chat
                  .with_tool(CreateActivitiesTool)
                  .with_tool(CreateLogementsTool)
                  .with_tool(CreateTransportsTool)
                  .with_instructions(instructions)
                  .ask(@message.content)

      #  3. MESSAGE IA
      Message.create(
        role: "assistant",
        content: @response.content,
        chat: @chat
      )
      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to plan_path(@plan) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { plan: @plan, message: @message })
        end
        format.html { render "plans/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def travel_context
    "Here is the actual information on my travel :
    L'id du plan est : #{@plan.id},\n
     The name of the plan is : #{@plan.title},\n
     Departure location :#{@plan.departure},\n
     Arrival location : #{@plan.arrival},\n
     Date of departure: #{@plan.date_start},\n
     Date of return: #{@plan.date_end},\n
     Number of travellers included: #{@plan.nb_people},\n
     The total budget: #{@plan.budget} €,\n
     "
  end

  def instructions
    [SYSTEM_PROMPT, travel_context].compact.join("\n\n")
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
