defmodule ChezaCardsWeb.UserForgotPasswordLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Accounts

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
            Forgot your password? 🔒
          </h2>
          <p class="mt-2 text-sm text-gray-600">
            We'll send a password reset link to your inbox.
          </p>
        </div>

        <div class="bg-white py-8 px-4 shadow-xl rounded-3xl sm:px-10 transform transition duration-300 hover:scale-[1.02]">
          <.form for={@form} id="reset_password_form" phx-submit="send_email" class="space-y-6">
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
              <.button
                phx-disable-with="Sending..."
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transform transition duration-150 hover:scale-105"
              >
                Send Reset Instructions 📩
              </.button>
            </div>
          </.form>

          <p class="mt-6 text-center text-sm text-gray-600">
            Remembered your password?
            <.link navigate={~p"/users/log_in"} class="font-medium text-purple-600 hover:text-purple-500 ml-1">
              Log in here! 🔑
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{"email" => ""}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end