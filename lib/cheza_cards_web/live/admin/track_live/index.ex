defmodule ChezaCardsWeb.Admin.TrackLive.Index do
  use ChezaCardsWeb, :live_view

  alias ChezaCards.Learning
  alias ChezaCards.Learning.Track

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Manage Learning Tracks")
     |> assign(:tracks, list_tracks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Track")
    |> assign(:track, Learning.get_track!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Track")
    |> assign(:track, %Track{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:track, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    track = Learning.get_track!(id)
    {:ok, _} = Learning.delete_track(track)

    {:noreply, assign(socket, :tracks, list_tracks())}
  end

  defp list_tracks do
    Learning.list_tracks()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="bg-white shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="sm:flex sm:items-center">
            <div class="sm:flex-auto">
              <h1 class="text-xl font-semibold text-gray-900">Learning Tracks</h1>
              <p class="mt-2 text-sm text-gray-700">
                Manage the learning tracks available to students in the platform.
              </p>
            </div>
            <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
              <.link
                patch={~p"/admin/tracks/new"}
                class="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:w-auto"
              >
                Add Track
              </.link>
            </div>
          </div>

          <div class="mt-8 flow-root">
            <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
              <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
                <table class="min-w-full divide-y divide-gray-300">
                  <thead>
                    <tr>
                      <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0">Name</th>
                      <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Description</th>
                      <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Status</th>
                      <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Featured</th>
                      <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-0">
                        <span class="sr-only">Actions</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">
                    <%= for track <- @tracks do %>
                      <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm sm:pl-0">
                          <div class="flex items-center">
                            <div class="h-10 w-10 flex-shrink-0 rounded-lg bg-gray-100 flex items-center justify-center text-xl">
                              <%= track.icon %>
                            </div>
                            <div class="ml-4">
                              <div class="font-medium text-gray-900"><%= track.name %></div>
                              <div class="text-gray-500"><%= track.slug %></div>
                            </div>
                          </div>
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          <%= track.description %>
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          <span class={"inline-flex rounded-full px-2 text-xs font-semibold leading-5 #{if track.is_active, do: "bg-green-100 text-green-800", else: "bg-gray-100 text-gray-800"}"}>
                            <%= if track.is_active, do: "Active", else: "Inactive" %>
                          </span>
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                          <%= if track.is_featured do %>
                            <span class="inline-flex items-center rounded-full bg-yellow-100 px-2 text-xs font-semibold text-yellow-800">
                              Featured
                            </span>
                          <% end %>
                        </td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
                          <.link
                            patch={~p"/admin/tracks/#{track}/edit"}
                            class="text-indigo-600 hover:text-indigo-900 mr-4"
                          >
                            Edit
                          </.link>
                          <.link
                            phx-click="delete"
                            phx-value-id={track.id}
                            data-confirm="Are you sure you want to delete this track? This will also delete all associated modules and lessons."
                            class="text-red-600 hover:text-red-900"
                          >
                            Delete
                          </.link>
                        </td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%= if @live_action in [:new, :edit] do %>
        <.modal id="track-modal" show on_cancel={JS.patch(~p"/admin/tracks")}>
          <.live_component
            module={ChezaCardsWeb.Admin.TrackLive.FormComponent}
            id={@track.id || :new}
            title={@page_title}
            action={@live_action}
            track={@track}
            patch={~p"/admin/tracks"}
          />
        </.modal>
      <% end %>
    </div>
    """
  end
end
