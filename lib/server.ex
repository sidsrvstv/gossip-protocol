defmodule GossipProtocol.Server do
  use GenServer

  # API

  def start_link(node_num) do
    # Instead of passing an atom to the `name` option, we send
    # a tuple. Here we extract this tuple to a private method
    # called `via_tuple` that can be reused for every function
    GenServer.start_link(__MODULE__, [], name: via_tuple(node_num))
  end

  def add_message(node_num, message, topology, neighbors_list) do
    # And the `GenServer` callbacks will accept this tuple the same way it
    # accepts a `pid` or an atom.
    # IO.puts "node #{node_num}"
    GenServer.cast(via_tuple(node_num), {:add_message, message})
    GossipProtocol.Server.spread_gossip(node_num, message, topology, neighbors_list)
  end

  def add_message_pushsum(node_num, message ) do
    # And the `GenServer` callbacks will accept this tuple the same way it
    # accepts a `pid` or an atom.
    # IO.puts "node #{node_num}"
    GenServer.cast(via_tuple(node_num), {:add_message, message})
  end

  def add_message_converge(node_num, message ) do
    # And the `GenServer` callbacks will accept this tuple the same way it
    # accepts a `pid` or an atom.
    # IO.puts "node #{node_num}"
    GenServer.cast(via_tuple(node_num), {:add_message, message})
  end

  def add_message_timer(node_num, message ) do
    # And the `GenServer` callbacks will accept this tuple the same way it
    # accepts a `pid` or an atom.
    # IO.puts "node #{node_num}"
    GenServer.cast(via_tuple(node_num), {:add_message, message})
  end

  def get_messages(node_num) do
    GenServer.call(via_tuple(node_num), :get_messages)
  end

  defp via_tuple(node_num) do
    # And the tuple always follow the same format:
    # {:via, module_name, term}
    {:via, GossipProtocol.Registry, {:node_num, node_num}}
  end

    # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end

  def spread_gossip(node_num, spread_the_word, num_of_nodes, neighbors_list) do

    updated_neighbors = get_updated_neighbors(node_num, neighbors_list)
    if length(updated_neighbors) == 0 do
        GossipProtocol.Server.add_message_converge(:converged_status_counter, node_num)
        all_nodes = Enum.to_list(1..num_of_nodes)
        converged_nodes = GossipProtocol.Server.get_messages(node_num)
        nodes_alive = Enum.filter(all_nodes, fn node -> !Enum.member?(converged_nodes, node) end)
        next_node = Enum.random(nodes_alive)
        spread_gossip(next_node, spread_the_word, num_of_nodes, neighbors_list)
    end

    status = ok_to_send_to(node_num, num_of_nodes)
    case status do
        {:ok} ->

            next_node = Enum.random(updated_neighbors)
            GossipProtocol.Server.add_message(next_node, spread_the_word, num_of_nodes, neighbors_list )
        {:noreply} ->
            IO.puts "Nodes have converged."
    end

    Process.sleep(50)
    GossipProtocol.Server.spread_gossip(node_num, spread_the_word, num_of_nodes, neighbors_list)

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
          GossipProtocol.Server.add_message_converge(:converged_status_counter, node_num)
            #IO.puts "Node number #{node_num} has converged."
            converged_nodes ++ [node_num]
        else
            converged_nodes
            #IO.puts "#{node_num} is already converged."
        end

        # IO.inspect converged_nodes

        if length(converged_nodes) >= 0.9*num_of_nodes do
            IO.puts "90% of nodes received the message 10 times."
            # finish_time = System.system_time(:millisecond)
            # get_time = GossipProtocol.Server.get_messages(:timer)
            # total_time = finish_time - Enum.at(get_time, 0)
            # IO.puts "Time to converge = #{total_time}"
            # exit(:shutdown)
            {:noreply}
        else
            {:ok}
        end
    end
  end

  # Pushsum code

  def spread_gossip_pushsum(node_num, {s, w}, num_of_nodes, neighbors_list) do
    status = ok_to_send_to_pushsum(node_num, num_of_nodes)

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

def ok_to_send_to_pushsum(node_num, num_of_nodes) do
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
