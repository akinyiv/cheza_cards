defmodule ChezaCardsWeb.UserLoginLive do
  use ChezaCardsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 bg-pattern flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full">
        <.back navigate={~p"/"}>Home</.back>
        <div class="text-center mb-8">
          <div class="inline-block animate-float mb-6">
            <img src="/images/mascot.svg" alt="ChezaCards Mascot" class="w-24 h-24 mx-auto" />
          </div>
          <h2 class="text-3xl font-bold text-gray-900">
            Welcome Back, Friend! 👋
          </h2>
          <p class="mt-2 text-sm text-gray-600">
            Ready to continue your learning adventure?
          </p>
        </div>

        <div class="bg-white py-8 px-4 shadow-xl rounded-3xl sm:px-10 transform transition duration-300 hover:scale-[1.02]">
          <.form
            for={@form}
            id="login_form"
            action={~p"/users/log_in"}
            phx-update="ignore"
            class="space-y-6"
          >
            <div>
              <.label for="email" class="block text-sm font-medium text-gray-700">
                Email 📧
              </.label>
              <div class="mt-1">
                <.input
                  id="email"
                  type="email"
                  name="user[email]"
                  required
                  autofocus
                  value={@form[:email].value}
                  class="appearance-none block w-full px-3 py-3 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                />
              </div>
            </div>

            <div>
              <.label for="password" class="block text-sm font-medium text-gray-700">
                Password 🔑
              </.label>
              <div class="mt-1">
                <.input
                  id="password"
                  type="password"
                  name="user[password]"
                  required
                  value={@form[:password].value}
                  class="appearance-none block w-full px-3 py-3 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                />
              </div>
            </div>

            <div class="flex items-center justify-between">
              <div class="flex items-center">
                <.input
                  id="remember_me"
                  type="checkbox"
                  name="user[remember_me]"
                  class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
                />
                <.label for="remember_me" class="ml-2 block text-sm text-gray-900">
                  Remember me
                </.label>
              </div>

              <div class="text-sm">
                <.link
                  navigate={~p"/users/reset_password"}
                  class="font-medium text-purple-600 hover:text-purple-500"
                >
                  Forgot your password?
                </.link>
              </div>
            </div>

            <div>
              <.button
                phx-disable-with="Signing in..."
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transform transition duration-150 hover:scale-105"
              >
                Let's Go! 🚀
              </.button>
            </div>
          </.form>

          <p class="mt-6 text-center text-sm text-gray-600">
            New to ChezaCards?
            <.link
              navigate={~p"/users/register"}
              class="font-medium text-purple-600 hover:text-purple-500 ml-1"
            >
              Join the Fun! ✨
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email) || ""
    form = to_form(%{"email" => email, "password" => ""}, as: "user")
    {:ok, assign(socket, form: form, page_title: "Welcome Back! | ChezaCards"), temporary_assigns: [form: form]}
  end
end