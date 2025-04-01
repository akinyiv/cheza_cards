defmodule ChezaCardsWeb.FlashcardLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards
  alias ChezaCards.Cards.Flashcard

  @impl true
  def mount(%{"collection_id" => collection_id}, _session, socket) do
    collection = Cards.get_collection!(collection_id)

    socket =
      socket
      |> assign(:collection, collection)
      |> stream(:flashcards, Cards.list_collection_flashcards(collection_id))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Flashcard")
    |> assign(:flashcard, Cards.get_flashcard!(id))
  end

  defp apply_action(socket, :new, %{"collection_id" => collection_id}) do
    socket
    |> assign(:page_title, "New Flashcard")
    |> assign(:flashcard, %Flashcard{collection_id: collection_id})
  end

  defp apply_action(socket, :index, %{"collection_id" => _collection_id}) do
    socket
    |> assign(:page_title, "#{socket.assigns.collection.name} - Flashcards")
    |> assign(:flashcard, nil)
  end

  @impl true
  def handle_info({ChezaCardsWeb.FlashcardLive.FormComponent, {:saved, flashcard}}, socket) do
    {:noreply, stream_insert(socket, :flashcards, flashcard)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    flashcard = Cards.get_flashcard!(id)
    {:ok, _} = Cards.delete_flashcard(flashcard)

    {:noreply, stream_delete(socket, :flashcards, flashcard)}
  end

  @impl true
  def handle_event("start-study", _params, socket) do
    collection = socket.assigns.collection
    {:noreply, push_navigate(socket, to: ~p"/collections/#{collection}/study")}
  end
end
