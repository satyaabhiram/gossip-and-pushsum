# PROJECT2

## Team members :
  UFID : 
```
  5958-3952  (Satya Abhiram Theli)
  0250-4891  (Abhinay Chintalapati)
```

## What is working : 
  All combinations of algorithms, and topologies are working. However, in some cases the process doesn't exit as the network never converges. Details in Report.pdf

## How to run : 
  Unzip, then navigate to folder theli_chintalapati. Run using :
  ```
  ./my_program numNodes topology algorithm
  e.g : ./my_program 1000 full gossip
  ```

## Largest networks that converged :

                Topology                  Gossip                  Push-sum
                                          (nodes)                 (nodes)
                full                      10000                   10000

                line                      100000                  1500  

                rand2D                    3000                    2000

                3Dtorus                   200000                  200000

                honeycomb                 10000                   500

                randhoneycomb             20000                   2000

