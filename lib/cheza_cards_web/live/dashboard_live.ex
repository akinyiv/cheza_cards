defmodule ChezaCardsWeb.DashboardLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Progress 
  alias ChezaCards.Learning

  @impl true
  def mount(_params, _session, socket) do
    featured_tracks = Learning.list_featured_tracks()
    current_user = socket.assigns[:current_user]
    progress = Progress.compute_progress(current_user.id)
    {:ok, assign(socket, featured_tracks: featured_tracks, user: current_user, progress: progress)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-yellow-100 via-pink-100 to-blue-100">
      <!-- 🎈 Fun Navigation Bar -->
      <nav class="flex items-center justify-between px-6 py-4 bg-pink-200 shadow-md rounded-b-lg">
        <div class="flex items-center gap-2">
          <!-- Mascot placeholder -->
          <img src="/images/ChezaCardsMascot.png" alt="Mascot" class="w-10 h-10 rounded-full" />
          <span class="text-xl font-bold text-purple-800">ChezaCards</span>
        </div>
        <ul class="flex gap-6 text-purple-700 font-medium">
          <li><a href="#" class="hover:text-purple-900">🏠 Home</a></li>
          <li><a href="#" class="hover:text-purple-900">📚 Tracks</a></li>
          <li><a href="#" class="hover:text-purple-900">🎖️ Badges</a></li>
          <li><a href="#" class="hover:text-purple-900">🔍 Explore</a></li>
        </ul>
      </nav>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
        <!-- 🎉 Welcome Heading -->
        <h1 class="text-4xl font-extrabold text-center text-purple-700 mb-10 animate-bounce">
          🎉 Let's Learn & Play with ChezaCards!
        </h1>

        <!-- 👤 Profile Section -->
        <section class="mb-10 bg-white rounded-2xl shadow-lg p-6 border-l-8 border-pink-300 flex items-center gap-6">
          <img
            src={@user.avatar_url || "/images/default-avatar.png"}
            alt="Avatar"
            class="w-20 h-20 rounded-full border-4 border-pink-200 shadow-md"
          />
          <div>
            <h2 class="text-2xl font-bold text-purple-800"><%= @user.name || "Welcome!" %></h2>
            <div class="mt-2">
              <div class="w-full bg-pink-100 rounded-full h-4 shadow-inner">
                <div class="bg-pink-500 h-4 rounded-full transition-all duration-500 ease-out" style={"width: #{@progress.completion_percentage}%"}></div>
              </div>
              <p class="text-sm text-purple-700 mt-1">Progress: <%= @progress.completion_percentage %>%</p>
            </div>
          </div>
        </section>

        <!-- 🏆 Progress/Badges Section -->
        <section class="mb-16 bg-white rounded-2xl shadow-lg p-6 border-l-8 border-yellow-400">
          <h2 class="text-2xl font-bold text-indigo-600 mb-4">🏅 Your Achievements</h2>
          <div class="flex flex-wrap gap-4">
            <div class="bg-yellow-100 rounded-xl px-4 py-2 text-sm font-semibold text-yellow-800 shadow">
              ⭐ Beginner Badge
            </div>
            <div class="bg-green-100 rounded-xl px-4 py-2 text-sm font-semibold text-green-800 shadow">
              📘 Track Explorer
            </div>
            <div class="bg-blue-100 rounded-xl px-4 py-2 text-sm font-semibold text-blue-800 shadow">
              🎯 3 Tasks Completed
            </div>
            <!-- Placeholder for future earned badges -->
            <div class="bg-gray-100 rounded-xl px-4 py-2 text-sm font-semibold text-gray-500 shadow">
              🔒 Secret Badge
            </div>
          </div>
        </section>

        <!-- 🌟 Featured Learning Tracks -->
        <section>
          <h2 class="text-3xl font-bold text-indigo-600 mb-8">🌟 Featured Learning Tracks</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <%= for track <- @featured_tracks do %>
              <div class="bg-white rounded-2xl shadow-lg border-4 border-yellow-300 hover:scale-105 transform transition duration-300 ease-in-out">
                <img src={track.image_url || "/images/default-track.jpg"} alt={track.name} class="w-full h-48 object-cover rounded-t-2xl" />
                <div class="p-5">
                  <h3 class="text-2xl font-bold text-pink-600 mb-2"><%= track.name %></h3>
                  <p class="text-gray-700 mb-4"><%= track.description %></p>
                  <div class="flex items-center justify-between">
                    <span class="inline-block px-3 py-1 text-sm font-semibold rounded-full bg-green-200 text-green-800">
                      🎓 Grade <%= track.grade_level %>
                    </span>
                    <.link navigate={~p"/learn/#{track}"} class="bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-full">
                      🚀 Start
                    </.link>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </section>
      </div>
    </div>
    """
  end
end
