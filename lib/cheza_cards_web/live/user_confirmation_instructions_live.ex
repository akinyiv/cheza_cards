defmodule ChezaCardsWeb.UserConfirmationInstructionsLive do
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
            No confirmation instructions received?
          </h2>
          <p class="mt-2 text-sm text-gray-600">
            We'll send a new confirmation link to your inbox.
          </p>
        </div>

        <div class="bg-white py-8 px-4 shadow-xl rounded-3xl sm:px-10 transform transition duration-300 hover:scale-[1.02]">
          <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions" class="space-y-6">
            <div>
              <.label for="email" class="block text-sm font-medium text-gray-700">
                Email 📧
              </.label>
              <div class="mt-1">
                <.input field={@form[:email]} type="email" placeholder="Email" required class="appearance-none block w-full px-3 py-3 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none focus:ring-purple-500 focus:border-purple-500 sm:text-sm" />
              </div>
            </div>

            <div>
              <.button phx-disable-with="Sending..." class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transform transition duration-150 hover:scale-105">
                Resend confirmation instructions
              </.button>
            </div>
          </.form>

          <p class="mt-6 text-center text-sm text-gray-600">
            New to ChezaCards?
            <.link navigate={~p"/users/register"} class="font-medium text-purple-600 hover:text-purple-500 ml-1">
              Join the Fun! ✨
            </.link>
            | 
            <.link navigate={~p"/users/log_in"} class="font-medium text-purple-600 hover:text-purple-500 ml-1">
              Log in
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end