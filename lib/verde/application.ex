defmodule Verde.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VerdeWeb.Telemetry,
      # Start the Ecto repository
      Verde.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Verde.PubSub},
      # Start Finch
      {Finch, name: Verde.Finch},
      # Start the Endpoint (http/https)
      VerdeWeb.Endpoint,
      # Start a worker by calling: Verde.Worker.start_link(arg)
      # {Verde.Worker, arg}
      {Arangox, Application.get_env(:verde, Arangox)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Verde.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VerdeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
