defmodule ChezaCardsWeb.UserRegistrationLive do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Accounts
  alias ChezaCards.Accounts.User

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
            Join the Fun! 🎉
          </h2>
          <p class="mt-2 text-sm text-gray-600">
            Create your account and start learning with ChezaCards!
          </p>
        </div>

        <div class="bg-white py-8 px-4 shadow-xl rounded-3xl sm:px-10 transform transition duration-300 hover:scale-[1.02]">
          <.form
            for={@form}
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            phx-trigger-action={@trigger_submit}
            action={~p"/users/log_in?_action=registered"}
            method="post"
            class="space-y-6"
          >
            <div>
              <.label for={@form[:email].id}>
                Email 📧
              </.label>
              <div class="mt-1">
                <.input
                  field={@form[:email]}
                  type="email"
                  required
                  phx-debounce="blur"
                  class="appearance-none block w-full px-3 py-3 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                />
                <%= for msg <- @form[:email].errors do %>
                  <.error><%= msg %></.error>
                <% end %>
              </div>
            </div>

            <div>
              <.label for={@form[:password].id}>
                Password 🔑
              </.label>
              <div class="mt-1">
                <.input
                  field={@form[:password]}
                  type="password"
                  required
                  class="appearance-none block w-full px-3 py-3 border border-gray-300 rounded-xl shadow-sm placeholder-gray-400 focus:outline-none focus:ring-purple-500 focus:border-purple-500 sm:text-sm"
                />
                <%= for msg <- @form[:password].errors do %>
                  <.error><%= msg %></.error>
                <% end %>
              </div>
            </div>

            <div>
              <.button
                phx-disable-with="Creating account..."
                class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-medium text-white bg-gradient-to-r from-purple-600 to-blue-600 hover:from-purple-700 hover:to-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500 transform transition duration-150 hover:scale-105"
              >
                Create My Account! 🌟
              </.button>
            </div>
          </.form>

          <p class="mt-6 text-center text-sm text-gray-600">
            Already have an account?
            <.link
              navigate={~p"/users/log_in"}
              class="font-medium text-purple-600 hover:text-purple-500 ml-1"
            >
              Log in here! ✨
            </.link>
          </p>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, page_title: "Join ChezaCards!")
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end