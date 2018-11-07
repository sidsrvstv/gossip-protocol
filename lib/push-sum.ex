defmodule Pushsum do

    def spread(n, fail_nodes, on_topology) do
        num_of_nodes = String.to_integer(n)

        GossipProtocol.Registry.start_link()
        GossipProtocol.Supervisor.start_link()
        GossipProtocol.Supervisor.start_node(:converged_status_counter)

        neighbors_list = Topology.get_neighbors(num_of_nodes, on_topology)
        num_of_nodes = length(neighbors_list)

        for i <- 1..num_of_nodes do
            GossipProtocol.Supervisor.start_node(i)
            #Process.monitor(pid)
        end

        first_node = :rand.uniform(num_of_nodes)
        #IO.puts first_node

        message = {first_node, 1}

        start_time = System.system_time(:millisecond)

        spread_gossip(first_node, message, num_of_nodes, neighbors_list)

        time_diff = System.system_time(:millisecond) - start_time
        IO.puts "Time taken to achieve convergence: #{time_diff} milliseconds"

        {:ok}
    end

    def spread_gossip(node_num, {s, w}, num_of_nodes, neighbors_list) do
        status = ok_to_send_to(node_num, num_of_nodes)

        message_q = GossipProtocol.Server.get_messages(node_num)

        {s_new, w_new} =
        if length(message_q) > 1 do
            [head | _] = message_q
            {s_old, w_old} = head
            s_new = s_old + s
            w_new = w_old + w
            {s_new, w_new}
        else
            s_new = s/2
            w_new = w/2
            {s_new, w_new}

        end

        case status do
            {:ok} ->
                message_outgoing = {s_new/2, w_new/2}
                GossipProtocol.Server.add_message_pushsum(node_num, message_outgoing )

                next_node = Enum.random(Enum.at(neighbors_list, node_num - 1))
                spread_gossip(next_node, message_outgoing, num_of_nodes, neighbors_list)
            {:noreply} ->
                IO.puts "Done"
        end

    end

    def ok_to_send_to(node_num, num_of_nodes) do
        messages = GossipProtocol.Server.get_messages(node_num)
        #IO.inspect messages

        if length(messages) < 4 do
            {:ok}
        else
            {s1,w1} = Enum.at(messages, 0)
            r1 = s1/w1

            {s2,w2} = Enum.at(messages, 1)
            r2 = s2/w2
            change1 = abs(r2 - r1)

            {s3,w3} = Enum.at(messages, 2)
            r3 = s3/w3
            change2 = abs(r3 - r2)

            {s4,w4} = Enum.at(messages, 3)
            r4 = s4/w4
            change3 = abs(r4 - r3)

            if change1 > :math.pow(10,-10) or change2 > :math.pow(10,-10) or change3 > :math.pow(10,-10) do
                {:ok}
            else
                converged_nodes = GossipProtocol.Server.get_messages(:converged_status_counter)
                #IO.inspect converged_nodes

                converged_nodes =
                if !Enum.member?(converged_nodes, node_num) do
                    GossipProtocol.Server.add_message_converge(:converged_status_counter, node_num)
                    #IO.puts "Node number #{node_num} has converged."
                    converged_nodes ++ [node_num]
                else
                    converged_nodes
                end

                #IO.inspect converged_nodes

                if length(converged_nodes) >= 0.9*num_of_nodes do
                    IO.puts "90% of nodes have converged."
                    {:noreply}
                else
                    {:ok}
                end
            end
        end
    end

end
