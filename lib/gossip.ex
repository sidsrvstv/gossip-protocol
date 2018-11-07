defmodule Gossip do

    def spread(n, fail_nodes, on_topology) do
        num_of_nodes = String.to_integer(n)
        spread_the_word = "brian may rocks!"

        GossipProtocol.Registry.start_link()
        GossipProtocol.Supervisor.start_link()
        #Process.monitor(pid_start)
        GossipProtocol.Supervisor.start_node(:converged_status_counter)
        neighbors_list = Topology.get_neighbors(num_of_nodes, on_topology)
        num_of_nodes = length(neighbors_list)

        for i <- 1..num_of_nodes do
            GossipProtocol.Supervisor.start_node(i)
            #Process.monitor(pid)
        end

        first_node = :rand.uniform(num_of_nodes)
        #IO.puts first_node
        fail_nodes_list = Enum.take_random(1..num_of_nodes, fail_nodes)
        start_time = System.system_time(:millisecond)
<<<<<<< HEAD
        spread_gossip(first_node, spread_the_word, num_of_nodes, neighbors_list, fail_nodes_list)
=======
        GossipProtocol.Server.add_message(first_node, spread_the_word, num_of_nodes, neighbors_list )
        # spread_gossip(first_node, spread_the_word, num_of_nodes, neighbors_list)
>>>>>>> e67adf2424d8196fb4e2374c2e1aaa518ef283e3

        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"

        {:ok}
    end
<<<<<<< HEAD


    def spread_gossip(node_num, spread_the_word, num_of_nodes, neighbors_list, fail_nodes_list) do
        status = ok_to_send_to(node_num, num_of_nodes)
        updated_neighbors1 = get_updated_neighbors(node_num, neighbors_list)
        updated_neighbors = Enum.filter(updated_neighbors1, fn node -> !Enum.member?(fail_nodes_list, node) end)
        if length(updated_neighbors) == 0 do
            GossipProtocol.Server.add_message(:converged_status_counter, node_num)
            all_nodes = Enum.to_list(1..num_of_nodes)
            converged_nodes = GossipProtocol.Server.get_messages(node_num)
            nodes_alive = Enum.filter(all_nodes, fn node -> !Enum.member?(converged_nodes, node) end)
            next_node = Enum.random(nodes_alive)
            spread_gossip(next_node, spread_the_word, num_of_nodes, neighbors_list, fail_nodes_list)
        end
        case status do
            {:ok} ->
                GossipProtocol.Server.add_message(node_num, spread_the_word )

                #neighbor_nodes = Topology.get_neighbors(node_num, num_of_nodes, topology)
                #IO.inspect neighbor_nodes
                #next_node = Enum.random(Enum.at(neighbors_list, node_num - 1))
                next_node = Enum.random(updated_neighbors)
                spread_gossip(next_node, spread_the_word, num_of_nodes, neighbors_list, fail_nodes_list)
            {:noreply} ->
                IO.puts "Nodes have converged."
        end
    end

    def get_updated_neighbors(node_num, neighborsList) do
        converged_nodes = GossipProtocol.Server.get_messages(node_num)
        old_neighbors = Enum.at(neighborsList, node_num - 1)
        new_neighbors = Enum.filter(old_neighbors, fn node -> !Enum.member?(converged_nodes, node) end)
        new_neighbors
    end

    def ok_to_send_to(node_num, num_of_nodes) do
        #IO.puts node_num
        messages = GossipProtocol.Server.get_messages(node_num)

        if length(messages) < 10 do
            {:ok}
        else
            # IO.puts "Node number #{node_num} received the message 10 time already"
            converged_nodes = GossipProtocol.Server.get_messages(:converged_status_counter)

            converged_nodes =
            if !Enum.member?(converged_nodes, node_num) do
                GossipProtocol.Server.add_message(:converged_status_counter, node_num)
                #IO.puts "Node number #{node_num} has converged."
                converged_nodes ++ [node_num]
            else
                converged_nodes
                #IO.puts "#{node_num} is already converged."
            end

            # IO.inspect converged_nodes

            if length(converged_nodes) >= 0.9*num_of_nodes do
                IO.puts "90% of nodes received the message 10 times."
                {:noreply}
            else
                {:ok}
            end
        end
    end
=======
>>>>>>> e67adf2424d8196fb4e2374c2e1aaa518ef283e3
end
