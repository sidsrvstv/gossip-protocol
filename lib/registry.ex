defmodule GossipProtocol.Registry do

  use GenServer

  # API

  def start_link do
    # We register our registry (yeah, I know), with a simple name,
    # just so we can reference it in the other functions.
    GenServer.start_link(__MODULE__, nil, name: :registry)
  end

  def whereis_name(node_num) do
    GenServer.call(:registry, {:whereis_name, node_num})
  end

  def register_name(node_num, pid) do
    GenServer.call(:registry, {:register_node, node_num, pid})
  end

  def unregister_name(node_num) do
    GenServer.cast(:registry, {:unregister_node, node_num})
  end

  def send(node_num, message) do
    # If we try to send a message to a process
    # that is not registered, we return a tuple in the format
    # {:badarg, {process_name, error_message}}.
    # Otherwise, we just forward the message to the pid of this node.
    case whereis_name(node_num) do
      :undefined ->
        {:badarg, {node_num, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # SERVER

  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, node_num}, _from, state) do
    {:reply, Map.get(state, node_num, :undefined), state}
  end

  def handle_call({:register_node, node_num, pid}, _from, state) do
    # Registering a name is just a matter of putting it in our Map.
    # Our response tuple include a `:no` or `:yes` indicating if
    # the process was included or if it was already present.
    case Map.get(state, node_num) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, node_num, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_node, node_num}, state) do
    # And unregistering is as simple as deleting an entry from our Map
    {:noreply, Map.delete(state, node_num)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    # When a monitored process dies, we will receive a `:DOWN` message
    # that we can use to remove the dead pid from our registry
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    # And here we just filter out the dead pid
    remove = fn {_key, pid} -> pid  != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end

end
