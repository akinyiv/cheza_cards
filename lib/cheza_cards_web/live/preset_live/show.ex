defmodule ChezaCardsWeb.PresetLive.Show do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards

  @impl true
  def mount(%{"subject" => subject}, _session, socket) do
    socket =
      socket
      |> assign(:subject, subject)
      |> assign(:loading, false)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, get_subject_title(socket.assigns.subject))}
  end

  @impl true
  def handle_event("create_collection", _params, socket) do
    socket = assign(socket, :loading, true)
    subject = socket.assigns.subject

    case Cards.create_preset_collection(socket.assigns.current_user.id, subject) do
      {:ok, collection} ->
        {:noreply,
         socket
         |> put_flash(:info, "Collection created successfully!")
         |> push_navigate(to: ~p"/collections/#{collection}")}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to create collection. Please try again.")
         |> assign(:loading, false)}
    end
  end

  defp get_subject_title("math_g4"), do: "Mathematics - Grade 4"
  defp get_subject_title("science_g4"), do: "Science - Grade 4"
  defp get_subject_title("swahili_g4"), do: "Kiswahili - Darasa la 4"

  defp get_subject_description("math_g4") do
    """
    Master essential mathematics concepts for Grade 4:
    • Multiplication and Division
    • Fractions and Decimals
    • Basic Geometry
    • Measurement and Data
    """
  end

  defp get_subject_description("science_g4") do
    """
    Explore fascinating science topics for Grade 4:
    • States of Matter
    • Plant Life and Growth
    • Earth and Space
    • Forces and Motion
    """
  end

  defp get_subject_description("swahili_g4") do
    """
    Jifunze mada muhimu za Kiswahili darasa la 4:
    • Aina za Sentensi
    • Matumizi ya Vivumishi na Vielezi
    • Methali na Misemo
    • Utunzi wa Insha
    """
  end

  defp get_subject_icon("math_g4"), do: "🔢"
  defp get_subject_icon("science_g4"), do: "🔬"
  defp get_subject_icon("swahili_g4"), do: "📚"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-8 px-4">
      <.header>
        <div class="flex items-center">
          <span class="text-4xl mr-4"><%= get_subject_icon(@subject) %></span>
          <%= get_subject_title(@subject) %>
        </div>
        <:subtitle>
          <%= get_subject_description(@subject) %>
        </:subtitle>
        <:actions>
          <.link navigate={~p"/presets"}>
            <.button class="mr-4">Back to Presets</.button>
          </.link>
          <.button
            phx-click="create_collection"
            phx-disable-with="Creating..."
            disabled={@loading}
          >
            Add to My Collections
          </.button>
        </:actions>
      </.header>

      <div class="mt-8 bg-white rounded-lg shadow-lg overflow-hidden">
        <div class="p-6">
          <h3 class="text-xl font-semibold mb-4">What's Included:</h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-4">
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>CBC-aligned content</span>
              </div>
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>Carefully curated questions</span>
              </div>
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>Helpful hints and explanations</span>
              </div>
            </div>

            <div class="space-y-4">
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>Progress tracking</span>
              </div>
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>Study reminders</span>
              </div>
              <div class="flex items-center text-green-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                <span>Offline access</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
