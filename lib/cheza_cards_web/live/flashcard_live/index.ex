defmodule ChezaCardsWeb.FlashcardLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards
  alias ChezaCards.Cards.Flashcard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :flashcards, Cards.list_flashcards())}
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

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Flashcard")
    |> assign(:flashcard, %Flashcard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Flashcards")
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
end
