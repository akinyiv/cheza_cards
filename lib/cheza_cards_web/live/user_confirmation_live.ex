defmodule ChezaCardsWeb.UserConfirmationLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 bg-pattern flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div class="max-w-md w-full">
        <.back navigate={~p"/"}>Home</.back>
        <div class="text-center mb-8">
          <div class="inline-block animate-float mb-6">
            <img src="/images/mascot.svg" alt="ChezaCards Mascot" class="w-24 h-24 mx-auto" />
          </div>
          <h2 class="text-3xl font-bold text-gray-900">
            Confirm Your Account ✅
          </h2>
          <p class="mt-2 text-sm text-gray-600">
            Just one more step to start your journey with us!
          </p>
        </div>

        <div class="bg-white py-8 px-4 shadow-xl rounded-3xl sm:px-10 transform transition duration-300 hover:scale-[1.02]">
          <.simple_form for={@form} id="confirmation_form" phx-submit="confirm_account" class="space-y-6">
            <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
            
            <div>
              <.button phx-disable-with="Confirming..." class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transform transition duration-150 hover:scale-105">
                Confirm My Account 🚀
              </.button>
            </div>
          </.simple_form>

          <p class="mt-6 text-center text-sm text-gray-600">
            Need an account?
            <.link navigate={~p"/users/register"} class="font-medium text-purple-600 hover:text-purple-500 ml-1">
              Sign Up Here! ✨
            </.link>
            | 
            <.link navigate={~p"/users/log_in"} class="font-medium text-purple-600 hover:text-purple-500 ml-1">
              Log In
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end