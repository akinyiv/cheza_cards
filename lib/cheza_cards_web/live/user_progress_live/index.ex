defmodule ChezaCardsWeb.UserProgressLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Progress
  alias ChezaCards.Progress.UserMetrics

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_progress_collection, Progress.list_user_metrics())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User progress")
    |> assign(:user_progress, Progress.get_user_metrics!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User progress")
    |> assign(:user_progress, %UserMetrics{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User progress")
    |> assign(:user_progress, nil)
  end

  @impl true
  def handle_info({ChezaCardsWeb.UserProgressLive.FormComponent, {:saved, user_progress}}, socket) do
    {:noreply, stream_insert(socket, :user_progress_collection, user_progress)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_progress = Progress.get_user_metrics!(id)
    {:ok, _} = Progress.delete_user_metrics(user_progress)

    {:noreply, stream_delete(socket, :user_progress_collection, user_progress)}
  end
end
