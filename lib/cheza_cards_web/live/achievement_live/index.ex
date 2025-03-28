defmodule ChezaCardsWeb.AchievementLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Progress
  alias ChezaCards.Progress.Achievement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :achievements, Progress.list_achievements())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Achievement")
    |> assign(:achievement, Progress.get_achievement!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Achievement")
    |> assign(:achievement, %Achievement{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Achievements")
    |> assign(:achievement, nil)
  end

  @impl true
  def handle_info({ChezaCardsWeb.AchievementLive.FormComponent, {:saved, achievement}}, socket) do
    {:noreply, stream_insert(socket, :achievements, achievement)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    achievement = Progress.get_achievement!(id)
    {:ok, _} = Progress.delete_achievement(achievement)

    {:noreply, stream_delete(socket, :achievements, achievement)}
  end
end
