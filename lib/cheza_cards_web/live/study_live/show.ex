defmodule ChezaCardsWeb.StudyLive.Show do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards

  @impl true
  def mount(%{"collection_id" => collection_id}, _session, socket) do
    collection = Cards.get_collection!(collection_id)
    flashcards = Cards.get_study_session_flashcards(collection_id, limit: 10)

    socket =
      socket
      |> assign(:collection, collection)
      |> assign(:flashcards, flashcards)
      |> assign(:current_card_index, 0)
      |> assign(:show_answer, false)
      |> assign(:correct_count, 0)
      |> assign(:total_attempts, 0)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("next_card", _params, socket) do
    next_index = socket.assigns.current_card_index + 1

    if next_index >= length(socket.assigns.flashcards) do
      {:noreply, push_patch(socket, to: ~p"/collections/#{socket.assigns.collection}/study/results")}
    else
      socket =
        socket
        |> assign(:current_card_index, next_index)
        |> assign(:show_answer, false)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("show_answer", _params, socket) do
    {:noreply, assign(socket, :show_answer, true)}
  end

  @impl true
  def handle_event("mark_result", %{"correct" => correct}, socket) do
    socket =
      socket
      |> update(:total_attempts, &(&1 + 1))
      |> update(:correct_count, &(&1 + if(correct == "true", do: 1, else: 0)))

    {:noreply, socket}
  end

  @impl true
  def render(assigns) when assigns.live_action == :results do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <.header>
        Study Session Results
        <:subtitle>
          Collection: <%= @collection.name %>
        </:subtitle>
        <:actions>
          <.link navigate={~p"/collections/#{@collection}"}>
            <.button>Back to Collection</.button>
          </.link>
          <.link patch={~p"/collections/#{@collection}/study"} class="ml-4">
            <.button>Study Again</.button>
          </.link>
        </:actions>
      </.header>

      <div class="mt-8 p-6 bg-white rounded-lg shadow-lg">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 text-center">
          <div class="p-4 bg-blue-50 rounded-lg">
            <h3 class="text-lg font-semibold text-blue-800">Correct Answers</h3>
            <p class="text-3xl font-bold text-blue-600"><%= @correct_count %></p>
          </div>
          <div class="p-4 bg-purple-50 rounded-lg">
            <h3 class="text-lg font-semibold text-purple-800">Accuracy</h3>
            <p class="text-3xl font-bold text-purple-600">
              <%= if @total_attempts > 0 do %>
                <%= round(@correct_count / @total_attempts * 100) %>%
              <% else %>
                0%
              <% end %>
            </p>
          </div>
        </div>

        <div class="mt-8 text-center">
          <%= case {@correct_count, @total_attempts} do %>
            <% {c, t} when c == t and t > 0 -> %>
              <p class="text-2xl font-bold text-green-600">Perfect Score! 🌟</p>
              <p class="mt-2 text-gray-600">You're amazing! Keep up the great work!</p>
            <% {c, t} when c / t >= 0.8 -> %>
              <p class="text-2xl font-bold text-green-600">Excellent Work! 🎉</p>
              <p class="mt-2 text-gray-600">You're doing great! Just a bit more practice to perfection!</p>
            <% {c, t} when c / t >= 0.6 -> %>
              <p class="text-2xl font-bold text-yellow-600">Good Job! 👍</p>
              <p class="mt-2 text-gray-600">You're making progress! Keep practicing!</p>
            <% {_, t} when t > 0 -> %>
              <p class="text-2xl font-bold text-blue-600">Keep Going! 💪</p>
              <p class="mt-2 text-gray-600">Don't give up! Practice makes perfect!</p>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <.header>
        Study Session
        <:subtitle>
          Collection: <%= @collection.name %> (<%= @current_card_index + 1 %>/<%= length(@flashcards) %>)
        </:subtitle>
        <:actions>
          <.link navigate={~p"/collections/#{@collection}"}>
            <.button>Exit Session</.button>
          </.link>
        </:actions>
      </.header>

      <div class="mt-8">
        <%= if current_card = Enum.at(@flashcards, @current_card_index) do %>
          <div class="bg-white rounded-lg shadow-lg overflow-hidden">
            <div class="p-6">
              <h3 class="text-xl font-semibold mb-4">Question:</h3>
              <p class="text-gray-700 text-lg"><%= current_card.question %></p>

              <%= if current_card.hint do %>
                <div class="mt-4 text-sm">
                  <button
                    type="button"
                    class="text-blue-600 hover:text-blue-800"
                    phx-click={JS.toggle(to: "#hint-#{current_card.id}")}
                  >
                    Show Hint
                  </button>
                  <p id={"hint-#{current_card.id}"} class="hidden mt-2 text-gray-600 italic">
                    💡 <%= current_card.hint %>
                  </p>
                </div>
              <% end %>

              <%= if @show_answer do %>
                <div class="mt-6 border-t pt-6">
                  <h3 class="text-xl font-semibold mb-4">Answer:</h3>
                  <p class="text-gray-700 text-lg"><%= current_card.answer %></p>

                  <div class="mt-6 flex justify-center space-x-4">
                    <button
                      phx-click={
                        JS.push("mark_result", value: %{correct: true})
                        |> JS.push("next_card")
                      }
                      class="px-6 py-2 bg-green-600 text-white rounded-full hover:bg-green-700 transition-colors"
                    >
                      I Got It Right! 😊
                    </button>
                    <button
                      phx-click={
                        JS.push("mark_result", value: %{correct: false})
                        |> JS.push("next_card")
                      }
                      class="px-6 py-2 bg-red-600 text-white rounded-full hover:bg-red-700 transition-colors"
                    >
                      I Need More Practice 📚
                    </button>
                  </div>
                </div>
              <% else %>
                <div class="mt-6 text-center">
                  <button
                    phx-click="show_answer"
                    class="px-6 py-2 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition-colors"
                  >
                    Show Answer
                  </button>
                </div>
              <% end %>
            </div>

            <div class="bg-gray-50 px-6 py-3">
              <div class="flex flex-wrap gap-2">
                <%= for tag <- current_card.tags do %>
                  <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700">
                    #<%= tag %>
                  </span>
                <% end %>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
