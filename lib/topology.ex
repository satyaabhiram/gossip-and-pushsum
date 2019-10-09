defmodule TOPOLOGY do
  @moduledoc """
  Documentation for TOPOLOGY.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TOPOLOGY.hello()
      :world

  """

  def get_number_of_nodes(numNodes, topology) do
    cond do
      topology == "3Dtorus" -> round(:math.pow(round(nth_root(3, numNodes)), 3))
      true -> numNodes
    end
  end

  def compute_neighbors(numNodes, topology, index, xc, yc) do
    neighbors =
      case topology do
        "full" -> full(numNodes, index)
        "line" -> line(numNodes, index)
        "rand2D" -> rand2D(numNodes, index, xc, yc)
        "3Dtorus" -> torus3D(numNodes, index)
        "honeycomb" -> honeycomb(numNodes, index)
        "randhoneycomb" -> randhoneycomb(numNodes, index)
        _ -> "No matching Topology"
      end
    neighbors
  end

  def full(numNodes, index) do
    neighbors = Enum.to_list(1..numNodes)
    neighbors = List.delete(neighbors, index)
    neighbors
  end

  def line(numNodes, index) do
    neighbors = cond do
        index==1 -> [index+1]
        index==numNodes -> [index-1]
        true -> [index-1,index+1]
    end
    neighbors
  end

  def rand2D(numNodes, index, xc, yc) do
    p = Enum.reduce(1..numNodes, [], 
                fn y, acc -> acc ++ cond do 
                                    y == index -> #IO.puts " same number match"
                                              []
    :math.sqrt(:math.pow(Enum.at(xc,index-1)-Enum.at(xc,y-1),2)+:math.pow(Enum.at(yc,index-1)-Enum.at(yc,y-1),2)) < 0.1 -> [y]
                                    true -> []
                                    end 
    end)
    p
  end

  def torus3D(numNodes, index) do
    layer = round(nth_root(3, numNodes))
    dr = layer*layer
    lay  = trunc((index-1)/dr)
    ie = index - (lay*dr)
    row = trunc((ie-1)/layer)
    col = rem((ie-1),layer)
    p = cond do 
            (row+1)==layer -> [1+((col*layer)+(lay*dr))]
            true -> [1+((row+1)+(col*layer)+(lay*dr))]
        end     
    q = cond do 
            row == 0 -> [1+((layer-1)+(col*layer)+(lay*dr))]
            true ->  [1+((row-1)+(col*layer)+(lay*dr))]
        end
    r = cond do 
            (col+1)==layer -> [1+(row+(lay*dr))]
            true -> [1+(row+((col+1)*layer)+(lay*dr))]
        end     
    s = cond do 
            col == 0 -> [1+(row+((layer-1)*layer)+(lay*dr))]
            true ->  [1+(row+((col-1)*layer)+(lay*dr))]
        end
    t = cond do 
            (lay+1)==layer -> [1+(row+(col*layer))]
            true -> [1+(row+(col*layer)+((lay+1)*dr))]
        end     
    u = cond do 
            lay == 0 ->  [1+(row+(col*layer)+((layer-1)*dr))]
            true ->  [1+(row+(col*layer)+((lay-1)*dr))]
        end
    p ++ q ++ r ++ s ++ t ++ u
  end

  def honeycomb(numNodes, index) do
    row = trunc((index-1)/6)
    col = rem((index-1),6)
    last = trunc((numNodes-1)/6)
    p = cond do
      row == last -> cond do 
        rem(last,2) == 0 -> cond do 
          col == 0 -> [((6*(row-1))+col)+1]
          col == 5 -> [((6*(row-1))+col)+1]
          rem(col,2) == 0 ->[((6*row)+col-1)+1,((6*(row-1))+col)+1]
          true -> [((6*row)+col+1)+1,((6*(row-1))+col)+1]
        end
        true -> cond do 
          col == 0 -> [((6*(row-1))+col)+1]
          col == 5 -> [((6*(row-1))+col)+1]
          rem(col,2) == 0 -> [((6*row)+col+1)+1,((6*(row-1))+col)+1]
          true -> [((6*row)+col-1)+1,((6*(row-1))+col)+1]
        end
      end
      row == 0 ->  cond do 
        col == 0 -> [((6*(row+1))+col)+1]
        col == 5 -> [((6*(row+1))+col)+1]
        rem(col,2) == 0 ->[((6*row)+col-1)+1,((6*(row+1))+col)+1]
        true -> [((6*row)+col+1)+1,((6*(row+1))+col)+1]
      end
      rem(row,2) == 0 -> cond do 
        col == 0 -> [((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        col == 5 -> [((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        rem(col,2) == 0 ->[((6*row)+col-1)+1,((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        true -> [((6*row)+col+1)+1,((6*(row-1))+col)+1,((6*(row+1))+col)+1]
      end
      true -> cond do 
        col == 0 -> [((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        col == 5 -> [((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        rem(col,2) == 0 -> [((6*row)+col+1)+1,((6*(row-1))+col)+1,((6*(row+1))+col)+1]
        true -> [((6*row)+col-1)+1,((6*(row-1))+col)+1,((6*(row+1))+col)+1]
      end
    end
    p
  end

  def randhoneycomb(numNodes, index) do
    p = honeycomb(numNodes, index)
    numbers = 1..numNodes
    t = Enum.to_list(numbers) -- [p]
    r = [Enum.random(t -- [index])]
    p ++ r
  end

  def nth_root(n, x, precision \\ 1.0e-5) do
    f = fn(prev) -> ((n - 1) * prev + x / :math.pow(prev, (n-1))) / n end
    fixed_point(f, x, precision, f.(x))
  end

  defp fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next

  defp fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))
end
