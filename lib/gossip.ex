defmodule GOSSIP do
  @moduledoc """
  Documentation for GOSSIP.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GOSSIP.hello()
      :world

  """

  def start(randomNode) do
    GenServer.cast(String.to_atom(Integer.to_string(randomNode)), {:message, "hello"})
  end

  def update_state_variables(index, neighbors, numberOfMessages, message) do
    # update statae variables
    numberOfMessages+1
  end

  def receive(index, neighbors, numberOfMessages, message) do
    # receive
    cond do
      numberOfMessages >= 10 -> terminate(index)
      true -> step(index, neighbors, message)
    end
  end

  def step(index, neighbors, message) do
    cond do
      length(neighbors) > 0 ->
        randomNode = Enum.random(neighbors)
        GenServer.cast(String.to_atom(Integer.to_string(randomNode)), {:message, message})
      true ->
    end
    GenServer.cast(String.to_atom(Integer.to_string(index)), {:step, message})
  end

  def terminate(index) do
    send(self(), :terminate)
  end
end
