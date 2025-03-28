defmodule ChezaCardsWeb.UserProgressLive.Show do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Progress

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_progress, Progress.get_user_progress!(id))}
  end

  defp page_title(:show), do: "Show User progress"
  defp page_title(:edit), do: "Edit User progress"
end
