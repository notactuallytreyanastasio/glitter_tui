defmodule GlitterTui.Application do
  # For OTP apps, we have a supervisor
  # but we won't start anything else right now.
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # If you had a GenServer or something else, you'd list it here.
    ]

    opts = [strategy: :one_for_one, name: GlitterTui.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

