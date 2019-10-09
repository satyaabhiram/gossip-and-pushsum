defmodule DOER do
  @moduledoc """
  Documentation for DOER.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DOER.hello()
      :world

  """

  use GenServer

  def start_link(numNodes, topology, algorithm) do
    GenServer.start_link(__MODULE__, [numNodes, topology, algorithm], name: String.to_atom("doer"))
  end

  def init(state) do
    numNodes = Enum.at(state, 0)
    topology = Enum.at(state, 1)
    algorithm = Enum.at(state, 2)
    readyNodes = 0
    doneNodes = 0
    startTime = :os.system_time(:millisecond)
    {:ok, {numNodes, topology, algorithm, readyNodes, doneNodes, startTime}}
  end

  def handle_cast({:do_it, numNodes, topology, algorithm}, state) do
    {xc, yc} =
    cond do 
      topology == "rand2D" -> {Enum.map(1..numNodes, fn(x) -> Enum.random(1..numNodes)/numNodes end), Enum.map(1..numNodes, fn(x) -> Enum.random(1..numNodes)/numNodes end)}
      true -> {0, 0}
    end
    Enum.each(1..numNodes, fn i -> GenServer.cast(String.to_atom(Integer.to_string(i)), {:compute_neighbors, xc, yc}) end)
    {:noreply, state}
  end

  def handle_cast({:neighbors_done, i}, {numNodes, topology, algorithm, readyNodes, doneNodes, startTime}) do
    readyNodes = readyNodes+1
    if readyNodes==numNodes do
      randomNode = Enum.random(1..numNodes)
      ALGORITHM.start(algorithm, randomNode)
      IO.puts("Spreading the message")
      startTime = :os.system_time(:millisecond)
    end
    {:noreply, {numNodes, topology, algorithm, readyNodes, doneNodes, startTime}}
  end

  def handle_cast({:got_message, i}, {numNodes, topology, algorithm, readyNodes, doneNodes, startTime}) do
    doneNodes = doneNodes+1
    if rem(doneNodes, 100) == 0 do
      IO.puts("#{doneNodes}/#{numNodes}: Node id: #{i}")
    end
    if doneNodes==numNodes do
      IO.puts("#{algorithm} on #{topology}(#{numNodes}) done in #{:os.system_time(:millisecond) - startTime} milliseconds")
      System.stop(0)
    end
    {:noreply, {numNodes, topology, algorithm, readyNodes, doneNodes, startTime}}
  end
end

