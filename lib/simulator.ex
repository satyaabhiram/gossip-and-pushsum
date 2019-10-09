defmodule SIMULATOR do
  @moduledoc """
  Documentation for SIMULATOR.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SIMULATOR.hello()
      :world

  """

  use Supervisor

  def start_link(numNodes, topology, algorithm) do
    Supervisor.start_link(__MODULE__, [numNodes, topology, algorithm], name: __MODULE__)
  end

  def init(params) do
    numNodes = TOPOLOGY.get_number_of_nodes(Enum.at(params, 0), Enum.at(params, 1))
    nodes = Enum.map(0..numNodes, fn i ->
      cond do
        i==0 -> worker(DOER, [numNodes, Enum.at(params, 1), Enum.at(params, 2)], [id: i])
        true -> worker(NODE, [numNodes, Enum.at(params, 1), Enum.at(params, 2), i], [id: i, restart: :temporary])
      end
    end)
    Supervisor.init(nodes, strategy: :one_for_one)
  end

  def start_the_works(numNodes, topology, algorithm) do
    GenServer.cast(String.to_atom("doer"), {:do_it, TOPOLOGY.get_number_of_nodes(numNodes, topology), topology, algorithm})
  end
end

