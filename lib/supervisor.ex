defmodule GossipProtocol.Supervisor do
  use Supervisor

  def start_link do
    # We are now registering our supervisor process with a name
    # so we can reference it in the `start_node/1` function
    Supervisor.start_link(__MODULE__, [], name: :node_supervisor)
  end

  def start_node(of_node) do
    Supervisor.start_child(:node_supervisor, [of_node])
  end

  def init(_) do
    children = [
      worker(GossipProtocol.Server, [])
    ]

    # We also changed the `strategy` to `simple_one_for_one`.
    # With this strategy, we define just a "template" for a child,
    # no process is started during the Supervisor initialization, just
    # when we call `start_child/2`
    supervise(children, strategy: :simple_one_for_one)
  end
end

