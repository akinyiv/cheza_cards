defmodule ChezaCardsWeb.AchievementLive.FormComponent do
  use ChezaCardsWeb, :live_component

  alias ChezaCards.Progress

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage achievement records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="achievement-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:badge_icon]} type="text" label="Badge icon" />
        <.input field={@form[:required_score]} type="number" label="Required score" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Achievement</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{achievement: achievement} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Progress.change_achievement(achievement))
     end)}
  end

  @impl true
  def handle_event("validate", %{"achievement" => achievement_params}, socket) do
    changeset = Progress.change_achievement(socket.assigns.achievement, achievement_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"achievement" => achievement_params}, socket) do
    save_achievement(socket, socket.assigns.action, achievement_params)
  end

  defp save_achievement(socket, :edit, achievement_params) do
    case Progress.update_achievement(socket.assigns.achievement, achievement_params) do
      {:ok, achievement} ->
        notify_parent({:saved, achievement})

        {:noreply,
         socket
         |> put_flash(:info, "Achievement updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_achievement(socket, :new, achievement_params) do
    case Progress.create_achievement(achievement_params) do
      {:ok, achievement} ->
        notify_parent({:saved, achievement})

        {:noreply,
         socket
         |> put_flash(:info, "Achievement created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
