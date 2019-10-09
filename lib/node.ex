defmodule NODE do
  use GenServer

  @moduledoc """
  Documentation for NODE.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NODE.hello()
      :world

  """

  def start_link(numNodes, topology, algorithm, index) do
    GenServer.start_link(__MODULE__, [numNodes, topology, algorithm, index], name: String.to_atom(Integer.to_string(index)))
  end

  def init(params) do
    numNodes = Enum.at(params, 0)
    topology = Enum.at(params, 1)
    algorithm = Enum.at(params, 2)
    index = Enum.at(params, 3)
    neighbors = []
    numberOfMessages = 0
    s = index
    w = 1
    sumEstimateChanges = [0]
    {:ok, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}}
  end

  def handle_cast({:compute_neighbors, xc, yc}, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}) do
    neighbors = TOPOLOGY.compute_neighbors(numNodes, topology, index, xc, yc)
    GenServer.cast(String.to_atom("doer"), {:neighbors_done, index})
    {:noreply, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}}
  end

  def handle_cast({:start}, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}) do
    ALGORITHM.receive(algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges, {0, 0})
    {:noreply, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}}
  end

  def handle_cast({:message, message}, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}) do
    {numberOfMessages, s, w, sumEstimateChanges} = ALGORITHM.update_state_variables(algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges, message)
    if numberOfMessages == 1 do
      GenServer.cast(String.to_atom("doer"), {:got_message, index})
    end
    ALGORITHM.receive(algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges, message)
    {:noreply, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}}
  end

  def handle_cast({:step, message}, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}) do
    ALGORITHM.step(algorithm, index, neighbors, message)
    {:noreply, {numNodes, topology, algorithm, index, neighbors, numberOfMessages, s, w, sumEstimateChanges}}
  end

  def handle_info(:terminate, state) do
    {:stop, :normal, state}
  end
end
