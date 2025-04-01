defmodule ChezaCardsWeb.PresetLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards

  @impl true
  def mount(_params, _session, socket) do
    subjects = Cards.list_preset_subjects()

    {:ok, assign(socket, :subjects, subjects)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "CBC-Aligned Flashcard Sets")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl mx-auto py-8 px-4">
      <.header>
        CBC-Aligned Flashcard Sets
        <:subtitle>
          Ready-to-use flashcard collections aligned with the CBC curriculum
        </:subtitle>
      </.header>

      <div class="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <%= for subject <- @subjects do %>
          <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition-shadow duration-300">
            <div class="p-6">
              <div class="flex items-center mb-4">
                <%= case subject do %>
                  <% "math_g4" -> %>
                    <span class="text-3xl mr-3">🔢</span>
                  <% "science_g4" -> %>
                    <span class="text-3xl mr-3">🔬</span>
                  <% "swahili_g4" -> %>
                    <span class="text-3xl mr-3">📚</span>
                <% end %>
                <h3 class="text-xl font-semibold">
                  <%= case subject do %>
                    <% "math_g4" -> %>
                      Mathematics - Grade 4
                    <% "science_g4" -> %>
                      Science - Grade 4
                    <% "swahili_g4" -> %>
                      Kiswahili - Darasa la 4
                  <% end %>
                </h3>
              </div>

              <p class="text-gray-600 mb-6">
                <%= case subject do %>
                  <% "math_g4" -> %>
                    Master essential math concepts including multiplication, fractions, and geometry.
                  <% "science_g4" -> %>
                    Explore fascinating science topics from matter states to plant life.
                  <% "swahili_g4" -> %>
                    Jifunze Kiswahili kupitia kadi za maneno, methali, na sarufi.
                <% end %>
              </p>

              <div class="flex items-center justify-between">
                <.link
                  navigate={~p"/presets/#{subject}"}
                  class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition-colors"
                >
                  View Collection
                  <span class="ml-2">→</span>
                </.link>

                <div class="flex items-center text-gray-500">
                  <span class="mr-2">
                    <%= case subject do %>
                      <% "math_g4" -> %>
                        25 cards
                      <% "science_g4" -> %>
                        20 cards
                      <% "swahili_g4" -> %>
                        30 cards
                    <% end %>
                  </span>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
                    <path
                      fill-rule="evenodd"
                      d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
