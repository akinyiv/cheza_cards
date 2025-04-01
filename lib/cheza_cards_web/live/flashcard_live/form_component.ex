defmodule ChezaCardsWeb.FlashcardLive.FormComponent do
  use ChezaCardsWeb, :live_component

  alias ChezaCards.Cards

  @common_tags [
    "math",
    "science",
    "swahili",
    "english",
    "social_studies",
    "cre",
    "grade4",
    "grade5",
    "grade6",
    "cbc"
  ]

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Create a fun flashcard to help you learn!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="flashcard-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="space-y-6">
          <.input
            field={@form[:question]}
            type="textarea"
            label="Question"
            placeholder="Write your question here..."
          />
          <.input
            field={@form[:answer]}
            type="textarea"
            label="Answer"
            placeholder="Write the answer here..."
          />
          <.input
            field={@form[:hint]}
            type="text"
            label="Hint (optional)"
            placeholder="Add a helpful hint..."
          />
          
          <div class="space-y-2">
            <label class="text-sm font-semibold leading-6 text-zinc-800">Tags</label>
            <div class="flex flex-wrap gap-2">
              <%= for tag <- @common_tags do %>
                <label class="inline-flex items-center p-2 bg-gray-100 rounded-full cursor-pointer hover:bg-gray-200">
                  <input
                    type="checkbox"
                    name="flashcard[tags][]"
                    value={tag}
                    checked={tag in (@form[:tags].value || [])}
                    class="mr-2"
                  />
                  <span class="text-sm"><%= tag %></span>
                </label>
              <% end %>
            </div>
          </div>

          <div class="hidden">
            <input type="hidden" name="flashcard[collection_id]" value={@collection.id} />
            <input type="hidden" name="flashcard[user_id]" value={@current_user.id} />
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">
            <%= if @action == :new, do: "Create Flashcard", else: "Update Flashcard" %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{flashcard: flashcard} = assigns, socket) do
    changeset = Cards.change_flashcard(flashcard)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:common_tags, @common_tags)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"flashcard" => flashcard_params}, socket) do
    changeset =
      socket.assigns.flashcard
      |> Cards.change_flashcard(flashcard_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"flashcard" => flashcard_params}, socket) do
    save_flashcard(socket, socket.assigns.action, flashcard_params)
  end

  defp save_flashcard(socket, :edit, flashcard_params) do
    case Cards.update_flashcard(socket.assigns.flashcard, flashcard_params) do
      {:ok, flashcard} ->
        notify_parent({:saved, flashcard})

        {:noreply,
         socket
         |> put_flash(:info, "Flashcard updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_flashcard(socket, :new, flashcard_params) do
    case Cards.create_flashcard(flashcard_params) do
      {:ok, flashcard} ->
        notify_parent({:saved, flashcard})

        {:noreply,
         socket
         |> put_flash(:info, "Flashcard created successfully")
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
