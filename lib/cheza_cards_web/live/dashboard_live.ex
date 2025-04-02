defmodule ChezaCardsWeb.DashboardLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Learning

  @impl true
  def mount(_params, _session, socket) do
    featured_tracks = Learning.list_featured_tracks()
    {:ok, assign(socket, featured_tracks: featured_tracks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Welcome to ChezaCards</h1>

      <section class="mb-12">
        <h2 class="text-2xl font-semibold text-gray-800 mb-4">Featured Learning Tracks</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <%= for track <- @featured_tracks do %>
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
              <img src={track.image_url || "/images/default-track.jpg"} alt={track.name} class="w-full h-48 object-cover" />
              <div class="p-6">
                <h3 class="text-xl font-semibold text-gray-900 mb-2"><%= track.name %></h3>
                <p class="text-gray-600 mb-4"><%= track.description %></p>
                <div class="flex items-center justify-between">
                  <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                    Grade <%= track.grade_level %>
                  </span>
                  <.link navigate={~p"/learn/#{track}"} class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Start Learning
                  </.link>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </section>
    </div>
    """
  end
end
