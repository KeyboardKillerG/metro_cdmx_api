defmodule MetroCdmxApiWeb.MetroController do
  use MetroCdmxApiWeb, :controller
  alias MetroCdmxApi.Metro
  def show(conn, params) do
    origin = params["origin"]
    dest = params["dest"]
    path = MetroCdmxChallenge.get_route(origin, dest)
    render(conn, "show.json", %{origin: origin, dest: dest, itinerary: path})
  end
end
