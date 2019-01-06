# GossipSimulator

**Description**

This is an implementation of the gossip protocol for peer to peer communication, such that data is routed to all nodes in a network. There are two main prototypes which have been implemented:

1. Gossip protocol for rumor mongering
2. Push Sum algorithm for computing aggregate across the network

Both the above algorithms have been implemented and tested for the below mentioned topologies:

1. Full: Each node is connected to all other nodes
2. Line: Each node connected to only two nodes, except last and first node which only has 1 neighbor
3. Torus: Nodes are connected in form a 3D Torus
4. Imperfect line: Just like line but each node is additionally connected to one other random node
5. Random2D: nodes are connected in the form of a 2 dimensional grid but within unit area. 
6. 3D: Nodes are connected to form a 3 dimensinal grid


**Installation and Running**

Go to the folder 'gossip_simulator' using command line tool and type 

$> mix run lib/gossip_simulator.ex num_of_nodes topology algorithm

e.g. mix run lib/gossip_simulator.ex 100 full push-sum
The above command would run push-sum algorithm for 100 nodes connected in full topology.

algorithm: [push-sum], [gossip]
topology: [line], [full], [3D], [rand2D], [torus], [impline]

