defmodule Topology do

    def cube_root(x, precision \\ 1.0e-5) do
        f = fn(prev) -> (2 * prev + x / :math.pow(prev, (2))) / 3 end
        fixed_point(f, x, precision, f.(x))
      end

    defp fixed_point(_, guess, tolerance, next) when abs(guess - next) < tolerance, do: next
    defp fixed_point(f, _, tolerance, next), do: fixed_point(f, next, tolerance, f.(next))

    def get_neighbors(num_of_nodes, topology) do
        case topology do
            "full" ->
                neighborsList = for i <- 1..num_of_nodes do
                                    for j <- 1..num_of_nodes, i != j , do: j
                                end
                neighborsList

            "line" ->
                neighborsList =  for i <- 1..num_of_nodes do
                                    cond do
                                        i == 1 -> [i+1]
                                        i == num_of_nodes -> [i-1]
                                        true -> [i-1,i+1]
                                    end
                                end
                neighborsList

            "impline" ->
                neighborsList =  for i <- 1..num_of_nodes do
                                    cond do
                                        i == 1 ->
                                            [one, two] = Enum.take_random(1..num_of_nodes, 2)
                                            if i != one, do: [i+1, one], else: [i+1, two]
                                        i == num_of_nodes ->
                                            [one, two] = Enum.take_random(1..num_of_nodes, 2)
                                            if i != one, do: [i-1, one], else: [i-1, two]
                                        true -> [i-1,i+1]
                                            [one, two] = Enum.take_random(1..num_of_nodes, 2)
                                            if i != one, do: [i-1,i+1, one], else: [i-1, i+1, two]
                                    end
                                end
                neighborsList

            "torus" ->
                rowcnt = trunc(:math.sqrt(num_of_nodes)) + 1
                num_of_nodes = rowcnt * rowcnt
                neighborsList = for i <- 1..num_of_nodes do
                                     cond do
                                        i == 1 -> [i + 1, rowcnt, i + rowcnt, num_of_nodes - rowcnt + 1 ]
                                        i == rowcnt -> [1, i-1, num_of_nodes, i+rowcnt]
                                        i == num_of_nodes - rowcnt + 1 -> [1, i+1, i-rowcnt, num_of_nodes]
                                        i == num_of_nodes -> [i-1, rowcnt, i-rowcnt, num_of_nodes - rowcnt + 1 ]
                                        i < rowcnt -> [i-1,i+1,i+rowcnt, num_of_nodes - rowcnt + i ]
                                        i > num_of_nodes - rowcnt + 1 and i < num_of_nodes -> [ i + rowcnt - num_of_nodes  ,i-1,i+1,i-rowcnt]
                                        rem(i-1,rowcnt) == 0 -> [i+1, i-rowcnt, i+rowcnt-1, i+rowcnt]
                                        rem(i, rowcnt) == 0 -> [i-1,i-rowcnt, i-rowcnt+1, i+rowcnt]
                                        true -> [i-1,i+1,i-rowcnt,i+rowcnt]
                                    end
                                end
                neighborsList
            "rand2D" ->
                all_node = for i <- 1..num_of_nodes do
                    x = :rand.uniform()
                    y = :rand.uniform()
                    {i,x,y}
                end
                neighborsList = Enum.reduce(all_node, [], fn {id1, x, y}, accu ->
                    row = Enum.reduce(all_node, [], fn {id2, xp, yp}, acc ->
                            dist = :math.sqrt(  ((x - xp)*(x - xp) + (y - yp)*(y - yp)) )
                            if id1 != id2 and dist <= 0.1 do
                                [id2 | acc]
                            else
                                acc
                            end
                        end)
                    |> Enum.reverse
                    [row | accu]
                end)
                Enum.reverse(neighborsList)
            "3D" ->
                rowcnt = trunc(cube_root(num_of_nodes)) + 1
                num_of_nodes = rowcnt * rowcnt
                total_num_of_nodes = rowcnt * rowcnt * rowcnt

                neighborsList = for i <- 1..total_num_of_nodes do
                                    potential_neighbors = [i - 1, i + 1, i + rowcnt, i - rowcnt, i + num_of_nodes, i - num_of_nodes]
                                    Enum.reduce(potential_neighbors, [], fn x, acc ->
                                       if x > 0 and x <= total_num_of_nodes, do: [x | acc] , else: acc
                                    end)
                                end
                neighborsList
        end
    end
end

