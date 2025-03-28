defmodule ChezaCardsWeb.UserProgressLive.FormComponent do
  use ChezaCardsWeb, :live_component

  alias ChezaCards.Progress

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage user_progress records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_progress-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:streak_count]} type="number" label="Streak count" />
        <.input field={@form[:total_stars]} type="number" label="Total stars" />
        <.input field={@form[:level]} type="number" label="Level" />
        <.input field={@form[:last_activity]} type="datetime-local" label="Last activity" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User progress</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_progress: user_progress} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Progress.change_user_progress(user_progress))
     end)}
  end

  @impl true
  def handle_event("validate", %{"user_progress" => user_progress_params}, socket) do
    changeset = Progress.change_user_progress(socket.assigns.user_progress, user_progress_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"user_progress" => user_progress_params}, socket) do
    save_user_progress(socket, socket.assigns.action, user_progress_params)
  end

  defp save_user_progress(socket, :edit, user_progress_params) do
    case Progress.update_user_progress(socket.assigns.user_progress, user_progress_params) do
      {:ok, user_progress} ->
        notify_parent({:saved, user_progress})

        {:noreply,
         socket
         |> put_flash(:info, "User progress updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user_progress(socket, :new, user_progress_params) do
    case Progress.create_user_progress(user_progress_params) do
      {:ok, user_progress} ->
        notify_parent({:saved, user_progress})

        {:noreply,
         socket
         |> put_flash(:info, "User progress created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
