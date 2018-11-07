defmodule Project2 do
  @moduledoc """
  Documentation for Project2.
  """

  @doc """
  main
    parses CLI

  ## Examples

      iex> Project2.main()


  """
    def main do
      matchArguments = System.argv()
      case matchArguments do
        [to_nodes, on_topology, fail_nodes, "gossip"] -> Gossip.spread(to_nodes, on_topology)
        [to_nodes, on_topology, fail_nodes, "push-sum"] -> Pushsum.spread(to_nodes, on_topology)
        _ -> IO.puts "Argument Error"
      end

    end
end

Project2.main



