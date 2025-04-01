defmodule ChezaCardsWeb.PageLive do
  use ChezaCardsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 bg-pattern text-gray-900">
      <!-- Hero Section -->
      <div class="relative overflow-hidden">
        <div class="max-w-7xl mx-auto px-6 sm:px-8 lg:px-10 py-16 sm:py-24">
          <div class="text-center">
            <div class="inline-block animate-float mb-8">
              <img src="/images/mascot.svg" alt="ChezaCards Mascot" class="w-32 h-32 mx-auto" loading="lazy" />
            </div>
            <h1 class="text-4xl sm:text-5xl font-extrabold bg-gradient-to-r from-purple-600 via-pink-500 to-orange-400 bg-clip-text text-transparent animate-gradient-x">
              Learning is Fun with ChezaCards! 🎉
            </h1>
            <p class="mt-6 text-lg sm:text-xl text-gray-700 max-w-3xl mx-auto">
              Join thousands of Kenyan students who are learning and having fun with our interactive flashcards!
            </p>
            <div class="mt-10 flex flex-col sm:flex-row gap-4 justify-center">
              <.link
                navigate={~p"/users/register"}
                class="inline-flex items-center px-6 py-3 text-lg font-semibold rounded-full shadow-md text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:scale-105 hover:shadow-xl transition-transform"
              >
                Start Learning For Free
                <span class="ml-2 text-xl animate-bounce">→</span>
              </.link>
              <.link
                navigate={~p"/users/log_in"}
                class="inline-flex items-center px-6 py-3 text-lg font-semibold rounded-full border-2 border-purple-600 text-purple-600 bg-white hover:bg-purple-50 hover:scale-105 hover:shadow-lg transition-transform"
              >
                I Already Have An Account
              </.link>
            </div>
          </div>
        </div>
      </div>

      <!-- Subject Cards -->
      <div class="max-w-7xl mx-auto px-6 sm:px-8 lg:px-10 py-16">
        <h2 class="text-2xl sm:text-3xl font-bold text-center mb-12">
          Explore Fun Subjects! 📚
        </h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
          <%= for {emoji, subject} <- [{"🔢", "Math"}, {"🧪", "Science"}, {"📖", "Kiswahili"}, {"🌍", "Environmental Studies"}] do %>
            <div class="bg-white rounded-2xl p-6 shadow-lg transform transition-transform hover:scale-105 hover:rotate-2 cursor-pointer text-center">
              <div class="text-4xl mb-2"><%= emoji %></div>
              <h3 class="font-bold"><%= subject %></h3>
            </div>
          <% end %>
        </div>
      </div>

      <!-- Features Grid -->
      <div class="max-w-7xl mx-auto px-6 sm:px-8 lg:px-10 py-16">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <%= for {icon, title, description} <- [
                {"📚", "CBC-Aligned Content", "Study with flashcards that match exactly what you're learning in school!"},
                {"🎮", "Learn Through Play", "Turn studying into a fun game with points, achievements, and rewards!"},
                {"🌟", "Track Your Progress", "Watch yourself improve and celebrate your learning achievements!"}
              ] do %>
            <div class="feature-card bg-white rounded-3xl p-8 shadow-xl transform transition-transform hover:scale-105">
              <div class="w-16 h-16 bg-purple-100 rounded-2xl flex items-center justify-center mb-6 animate-float">
                <div class="text-4xl"><%= icon %></div>
              </div>
              <h3 class="text-xl font-bold mb-4"><%= title %></h3>
              <p class="text-gray-600"><%= description %></p>
            </div>
          <% end %>
        </div>
      </div>

      <!-- CTA Section -->
      <div class="bg-gradient-to-r from-purple-600 to-blue-600 py-16 text-center">
        <h2 class="text-2xl sm:text-3xl font-bold text-white mb-8 animate-float">
          Ready to Make Learning Fun? 🚀
        </h2>
        <.link
          navigate={~p"/users/register"}
          class="inline-flex items-center px-6 py-3 text-lg font-semibold rounded-full shadow-xl text-purple-600 bg-white hover:bg-gray-50 hover:scale-105 transition-transform"
        >
          Get Started Now - It's Free!
          <span class="ml-2 text-xl animate-bounce">→</span>
        </.link>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Welcome to ChezaCards!")}
  end
end