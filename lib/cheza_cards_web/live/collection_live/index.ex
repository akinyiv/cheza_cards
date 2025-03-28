defmodule ChezaCardsWeb.CollectionLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Cards
  alias ChezaCards.Cards.Collection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :collections, Cards.list_collections())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Collection")
    |> assign(:collection, Cards.get_collection!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Collection")
    |> assign(:collection, %Collection{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Collections")
    |> assign(:collection, nil)
  end

  @impl true
  def handle_info({ChezaCardsWeb.CollectionLive.FormComponent, {:saved, collection}}, socket) do
    {:noreply, stream_insert(socket, :collections, collection)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    collection = Cards.get_collection!(id)
    {:ok, _} = Cards.delete_collection(collection)

    {:noreply, stream_delete(socket, :collections, collection)}
  end
end
