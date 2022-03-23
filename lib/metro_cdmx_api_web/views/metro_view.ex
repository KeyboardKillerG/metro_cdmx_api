defmodule MetroCdmxApiWeb.MetroView do
  @moduledoc """
      View for Metro
    """
  use MetroCdmxApiWeb, :view

  def render("show.json", %{origin: origin, dest: dest, itinerary: itinerary}) do
    IO.inspect(itinerary)
    %{
      status: 200,
      origin: origin,
      dest: dest,
      itinerary: itinerary
    }
  end
end
