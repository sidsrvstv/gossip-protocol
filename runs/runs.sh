mkdir runs

mix run lib/project2.ex 100 full gossip > runs/results_gossip_{100}_full.log
mix run lib/project2.ex 500 full gossip > runs/results_gossip_{500}_full.log
mix run lib/project2.ex 1000 full gossip > runs/results_gossip_{1000}_full.log
mix run lib/project2.ex 100 line gossip > runs/results_gossip_{100}_line.log
mix run lib/project2.ex 500 line gossip > runs/results_gossip_{500}_line.log
mix run lib/project2.ex 1000 line gossip > runs/results_gossip_{1000}_line.log
mix run lib/project2.ex 100 impline gossip > runs/results_gossip_{100}_impline.log
mix run lib/project2.ex 500 impline gossip > runs/results_gossip_{500}_impline.log
mix run lib/project2.ex 1000 impline gossip > runs/results_gossip_{1000}_impline.log
mix run lib/project2.ex 100 rand2d gossip > runs/results_gossip_{100}_rand2d.log
mix run lib/project2.ex 500 rand2d gossip > runs/results_gossip_{500}_rand2d.log
mix run lib/project2.ex 1000 rand2d gossip > runs/results_gossip_{1000}_rand2d.log
mix run lib/project2.ex 100 torus gossip > runs/results_gossip_{100}_torus.log
mix run lib/project2.ex 500 torus gossip > runs/results_gossip_{500}_torus.log
mix run lib/project2.ex 1000 torus gossip > runs/results_gossip_{1000}_torus.log
mix run lib/project2.ex 100 3d gossip > runs/results_gossip_{100}_3d.log
mix run lib/project2.ex 500 3d gossip > runs/results_gossip_{500}_3d.log
mix run lib/project2.ex 1000 3d gossip > runs/results_gossip_{1000}_3d.log
mix run lib/project2.ex 100 full push-sum > runs/results_pushsum_{100}_full.log
mix run lib/project2.ex 500 full push-sum > runs/results_pushsum_{500}_full.log
mix run lib/project2.ex 1000 full push-sum > runs/results_pushsum_{1000}_full.log
mix run lib/project2.ex 100 line push-sum > runs/results_pushsum_{100}_line.log
mix run lib/project2.ex 500 line push-sum > runs/results_pushsum_{500}_line.log
mix run lib/project2.ex 1000 line push-sum > runs/results_pushsum_{1000}_line.log
mix run lib/project2.ex 100 impline push-sum > runs/results_pushsum_{100}_impline.log
mix run lib/project2.ex 500 impline push-sum > runs/results_pushsum_{500}_impline.log
mix run lib/project2.ex 1000 impline push-sum > runs/results_pushsum_{1000}_impline.log
mix run lib/project2.ex 100 rand2d push-sum > runs/results_pushsum_{100}_rand2d.log
mix run lib/project2.ex 500 rand2d push-sum > runs/results_pushsum_{500}_rand2d.log
mix run lib/project2.ex 1000 rand2d push-sum > runs/results_pushsum_{1000}_rand2d.log
mix run lib/project2.ex 100 torus push-sum > runs/results_pushsum_{100}_torus.log
mix run lib/project2.ex 500 torus push-sum > runs/results_pushsum_{500}_torus.log
mix run lib/project2.ex 1000 torus push-sum > runs/results_pushsum_{1000}_torus.log
mix run lib/project2.ex 100 3d push-sum > runs/results_pushsum_{100}_3d.log
mix run lib/project2.ex 500 3d push-sum > runs/results_pushsum_{500}_3d.log
mix run lib/project2.ex 1000 3d push-sum > runs/results_pushsum_{1000}_3d.log
