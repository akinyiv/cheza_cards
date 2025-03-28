defmodule ChezaCards.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChezaCardsWeb.Telemetry,
      ChezaCards.Repo,
      {DNSCluster, query: Application.get_env(:cheza_cards, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChezaCards.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChezaCards.Finch},
      # Start a worker by calling: ChezaCards.Worker.start_link(arg)
      # {ChezaCards.Worker, arg},
      # Start to serve requests, typically the last entry
      ChezaCardsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChezaCards.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChezaCardsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
