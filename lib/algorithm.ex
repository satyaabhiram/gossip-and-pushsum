defmodule ALGORITHM do
  @moduledoc """
  Documentation for ALGORITHM.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ALGORITHM.hello()
      :world

  """

  def start(algorithm, randomNode) do
    case algorithm do
      "gossip" -> GOSSIP.start(randomNode)
      "push-sum" -> PUSH_SUM.start(randomNode)
      _ -> "No matching algorithm"
    end
  end

  def update_state_variables(algorithm, index, neighbors, numberOfMessages, s, w, sumEstimates, message) do
    {numberOfMessages, s, w, sumEstimates} =
      case algorithm do
        "gossip" -> {GOSSIP.update_state_variables(index, neighbors, numberOfMessages, message), s, w, sumEstimates}
        "push-sum" -> PUSH_SUM.update_state_variables(index, neighbors, numberOfMessages, s, w, sumEstimates, message)
        _ -> "No matching algorithm"
      end
    {numberOfMessages, s, w, sumEstimates}
  end

  def receive(algorithm, index, neighbors, numberOfMessages, s, w, sumEstimates, message) do
    case algorithm do
      "gossip" -> GOSSIP.receive(index, neighbors, numberOfMessages, message)
      "push-sum" -> PUSH_SUM.receive(index, neighbors, numberOfMessages, s, w, sumEstimates, message)
      _ -> "No matching algorithm"
    end
  end

  def step(algorithm, index, neighbors, message) do
    case algorithm do
      "gossip" -> GOSSIP.step(index, neighbors, message)
      "push-sum" -> PUSH_SUM.step(index, neighbors, message)
      _ -> "No matching algorithm"
    end
  end
end
