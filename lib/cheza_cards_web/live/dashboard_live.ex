defmodule ChezaCardsWeb.DashboardLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Learning
  alias ChezaCards.Cards

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ChezaCards.PubSub, "user:#{socket.assigns.current_user.id}")
    end

    tracks = Learning.list_featured_tracks()
    recent_progress = Learning.get_recent_progress(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:featured_tracks, tracks)
     |> assign(:recent_progress, recent_progress)
     |> assign(:recent_collections, Cards.list_recent_collections(socket.assigns.current_user))
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Welcome Banner -->
        <div class="bg-white rounded-lg shadow-sm p-6 mb-8">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-2xl font-bold text-gray-900">Welcome back, <%= String.split(@current_user.email, "@") |> hd() %>! 👋</h1>
              <p class="mt-1 text-gray-600">Pick up where you left off or start something new.</p>
            </div>
            <div class="flex items-center space-x-4">
              <.link
                navigate={~p"/learn"}
                class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Start Learning
              </.link>
            </div>
          </div>
        </div>

        <!-- Learning Tracks Grid -->
        <div class="mb-8">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Featured Learning Tracks</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for track <- @featured_tracks do %>
              <.link
                navigate={~p"/learn/#{track.slug}"}
                class="group relative bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow"
              >
                <div class="aspect-w-16 aspect-h-9 bg-gray-100">
                  <div class="p-6">
                    <div class="text-3xl mb-4"><%= track.icon %></div>
                    <h3 class="text-lg font-medium text-gray-900 group-hover:text-indigo-600 transition-colors">
                      <%= track.name %>
                    </h3>
                    <p class="mt-2 text-sm text-gray-500"><%= track.description %></p>
                  </div>
                </div>
                <div class="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-indigo-500 to-purple-600 transform scale-x-0 group-hover:scale-x-100 transition-transform origin-left"></div>
              </.link>
            <% end %>
          </div>
        </div>

        <!-- Recent Progress -->
        <div class="mb-8">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Continue Learning</h2>
          <div class="bg-white rounded-lg shadow-sm divide-y divide-gray-200">
            <%= for progress <- @recent_progress do %>
              <.link
                navigate={~p"/learn/#{progress.track.slug}/#{progress.module.slug}"}
                class="block p-6 hover:bg-gray-50"
              >
                <div class="flex items-center justify-between">
                  <div class="flex items-center space-x-4">
                    <div class="text-2xl"><%= progress.track.icon %></div>
                    <div>
                      <h3 class="text-sm font-medium text-gray-900"><%= progress.track.name %></h3>
                      <p class="text-sm text-gray-500"><%= progress.module.name %></p>
                    </div>
                  </div>
                  <div class="flex items-center">
                    <div class="mr-4">
                      <div class="text-sm text-gray-500">Progress</div>
                      <div class="text-sm font-medium text-gray-900"><%= Float.round(progress.completion_percentage, 1) %>%</div>
                    </div>
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
              </.link>
            <% end %>
            <%= if Enum.empty?(@recent_progress) do %>
              <div class="p-6 text-center">
                <p class="text-gray-500">No learning progress yet. Start a new track!</p>
              </div>
            <% end %>
          </div>
        </div>

        <!-- Recent Collections -->
        <div class="mb-8">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-xl font-semibold text-gray-900">Your Collections</h2>
            <.link
              navigate={~p"/collections/new"}
              class="text-sm text-indigo-600 hover:text-indigo-900"
            >
              Create New Collection
            </.link>
          </div>
          <div class="bg-white rounded-lg shadow-sm divide-y divide-gray-200">
            <%= for collection <- @recent_collections do %>
              <.link
                navigate={~p"/collections/#{collection}"}
                class="block p-6 hover:bg-gray-50"
              >
                <div class="flex items-center justify-between">
                  <div>
                    <h3 class="text-sm font-medium text-gray-900"><%= collection.name %></h3>
                    <p class="text-sm text-gray-500"><%= collection.description %></p>
                  </div>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                  </svg>
                </div>
              </.link>
            <% end %>
            <%= if Enum.empty?(@recent_collections) do %>
              <div class="p-6 text-center">
                <p class="text-gray-500">No collections yet. Create your first one!</p>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
