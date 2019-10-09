defmodule PUSH_SUM do
  @moduledoc """
  Documentation for PUSH_SUM.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PUSH_SUM.hello()
      :world

  """
  @threshold :math.pow(10, -10)

  def start(randomNode) do
    GenServer.cast(String.to_atom(Integer.to_string(randomNode)), {:start})
  end

  def update_state_variables(index, neighbors, numberOfMessages, s, w, sumEstimateChanges, message) do
    # update state variables
    {s, w, sumEstimateChanges} =
      cond do
        numberOfMessages == 0 -> {s/2, w/2, sumEstimateChanges}
        true -> {(s+elem(message, 0))/2, (w+elem(message, 1))/2, [abs(s/w - (s+elem(message, 0))/(w+elem(message, 1))) | List.delete_at(sumEstimateChanges, 2)]}
      end
    {numberOfMessages+1, s, w, sumEstimateChanges}
  end

  def receive(index, neighbors, numberOfMessages, s, w, sumEstimateChanges, message) do
    # receive
    cond do
      ((length(sumEstimateChanges) == 3) and
        (Enum.at(sumEstimateChanges, 0) <= @threshold) and
        (Enum.at(sumEstimateChanges, 1) <= @threshold) and
        (Enum.at(sumEstimateChanges, 2) <= @threshold)) -> terminate(index)
      true -> step(index, neighbors, {s, w})
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
