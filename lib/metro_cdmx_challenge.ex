defmodule MetroCdmxChallenge do
  import SweetXml
  @doc """
  Obtains ....

  ## Examples
    iex> MetroCdmxChallenge.metro_lines("./data/tiny_metro.kml")
    [
      %{name: "Línea 5", stations:
        [
          %{name: "Pantitlan", coords: "90.0123113 30.012121"},
          %{name: "Hangares", coords: "90.0123463 30.012158"},
        ]
      },
      %{name: "Línea 3", stations:
        [
          %{name: "Universidad", coords: "90.0123113 30.012121"},
          %{name: "Copilco", coords: "90.0123463 30.012158"},
        ]
      }
    ]
  """
  defmodule Line do
    defstruct [:name, :stations]
  end

  defmodule Station do
    defstruct [:name, :coordinates, :line]
  end

  def metro_lines(xml_path) do
    {:ok, xml_inf} = File.read(xml_path)
    map_lines = xml_inf |> xmap(
      lines: 
        [~x"//Document/Folder[1]/Placemark"l, 
          name: ~x"./name/text()"s, 
          stations: 
            [~x"./LineString/coordinates", 
              coordinates: ~x"./text()"s]], 
      stations: 
        [~x"//Document/Folder[2]/Placemark"l, 
          name: ~x"./name/text()"s, 
          coordinates: ~x"./Point/coordinates/text()"s] )
    stations_raw = Enum.map(map_lines[:stations], 
      fn station-> 
        %{name: station[:name], coordinates: station[:coordinates] 
        |> String.trim} 
      end) 
    lines_raw = Enum.map(map_lines[:lines], 
      fn line-> 
        %{name: line[:name], coordinates: line[:stations][:coordinates] 
        |> String.split(~r/\s+/, trim: true)} 
      end)    
    Enum.reduce(lines_raw, [], fn line, lines_list -> 
      [%Line{
        name: line[:name], 
        stations: Enum.reduce(line[:coordinates], [], 
          fn station_coordinates, stations_list ->
            station = Enum.find(stations_raw, &(&1[:coordinates] == station_coordinates))
            cond do       
              station != nil ->
              [%Station{
                name: station[:name], 
                coordinates: station_coordinates, 
                line: line.name} 
                | stations_list]
            true ->
              stations_list
            end
          end) }| lines_list]
    end)
  end

  def metro_graph(xml_path) do
    graph = Graph.new(type: :directed)
    metro_lines(xml_path)
    |> Enum.reduce(graph, fn line, graph ->
        Enum.chunk_every(line.stations, 2, 1, :discard) 
        |> Enum.reduce(graph, 
             fn stations, graph -> 
             Graph.add_edge(graph, List.first(stations).name, List.last(stations).name, label: :lb)
             |> Graph.add_edge(List.last(stations).name, List.first(stations).name, label: :la)
        end)
    end)
  end

  def find_line() do
    #TODO
    :line
  end

  def find_station(requested_station) do
    metro_lines("./data/Metro_CDMX.kml")
    |> Enum.map(fn line -> 
        Enum.find(line.stations, &(&1.name == requested_station))
       end) 
    |> Enum.find(&(&1 != nil))
  end

  def get_route(source, destiny) do
    metro_graph("./data/Metro_CDMX.kml")
    |> Graph.dijkstra(source, destiny)
    |> Enum.map(&find_station/1) 
    |> Enum.map(&Map.from_struct/1)
    #|> Enum.group_by()   
  end  
end
