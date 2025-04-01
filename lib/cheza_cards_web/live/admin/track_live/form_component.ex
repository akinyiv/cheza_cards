defmodule ChezaCardsWeb.Admin.TrackLive.FormComponent do
  use ChezaCardsWeb, :live_component

  alias ChezaCards.Learning

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Manage learning track content and settings</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="track-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Track Name" required />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:slug]} type="text" label="URL Slug" required />
        <.input field={@form[:icon]} type="text" label="Icon (emoji)" />
        <.input field={@form[:order]} type="number" label="Display Order" />
        
        <div class="space-y-4">
          <.input field={@form[:is_active]} type="checkbox" label="Active" />
          <.input field={@form[:is_featured]} type="checkbox" label="Featured on Dashboard" />
        </div>

        <.input
          field={@form[:metadata]}
          type="textarea"
          label="Metadata (JSON)"
          value={Jason.encode!(@form[:metadata].value || %{}, pretty: true)}
          placeholder="{}"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Track</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{track: track} = assigns, socket) do
    changeset = Learning.change_track(track)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"track" => track_params}, socket) do
    changeset =
      socket.assigns.track
      |> Learning.change_track(track_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"track" => track_params}, socket) do
    save_track(socket, socket.assigns.action, track_params)
  end

  defp save_track(socket, :edit, track_params) do
    case Learning.update_track(socket.assigns.track, track_params) do
      {:ok, track} ->
        notify_parent({:saved, track})

        {:noreply,
         socket
         |> put_flash(:info, "Track updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_track(socket, :new, track_params) do
    case Learning.create_track(track_params) do
      {:ok, track} ->
        notify_parent({:saved, track})

        {:noreply,
         socket
         |> put_flash(:info, "Track created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
