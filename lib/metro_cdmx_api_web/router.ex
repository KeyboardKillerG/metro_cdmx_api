defmodule MetroCdmxApiWeb.Router do
  use MetroCdmxApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MetroCdmxApiWeb do
    pipe_through :api
    get "/metrocdmx/route", MetroController, :show
  end
end
