defmodule MY_PROGRAM do
  def loop() do
    loop()
  end
  def main(args) do
    [numNodes, topology, algorithm] = args
    numNodes = String.to_integer(numNodes)
    {:ok, _pid} = SIMULATOR.start_link(numNodes, topology, algorithm)
    SIMULATOR.start_the_works(numNodes, topology, algorithm)
    loop()
  end
end

MY_PROGRAM.main(System.argv)