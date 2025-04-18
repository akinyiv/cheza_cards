defmodule ChezaCardsWeb.UserResetPasswordLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm p-6 bg-white shadow-lg rounded-lg">
      <.header class="text-center text-xl font-semibold">Reset Password</.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.error :if={@form.errors != []} class="text-red-500">
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:password]} type="password" label="New password" required class="w-full p-2 border rounded-md" />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          label="Confirm new password"
          required
          class="w-full p-2 border rounded-md"
        />
        <:actions>
          <.button phx-disable-with="Resetting..." class="w-full bg-blue-500 text-white py-2 rounded-md hover:bg-blue-600">Reset Password</.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/register"} class="text-blue-500 hover:underline">Register</.link>
        | <.link href={~p"/users/log_in"} class="text-blue-500 hover:underline">Log in</.link>
      </p>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket = assign_user_and_token(socket, token)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)
        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, token) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end