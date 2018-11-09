# Network

The Network module implements the Ulanowicz et al for
efficiency, reliability, and sustainability of networks.
The module has been written using Elm 0.19 and will
have to be tested for 0.18. Minor changes may be required.

The code is in `src/Network.elm`. A network is described
by nodes and edges. Here are the type definitions:

```
type Node =
  Node String

type Edge =
  Edge Node Node Float

type Network =
  Network (List Node) (List Edge)
```

## Tests

As an example, we create a small network by hand:

```
u1 = createNode "U1"
u2 = createNode "U2"
u3 = createNode "U3"
u4 = createNode "U4"

e14 = createEdge u1 u4 30
e12 = createEdge u1 u2 90.4
e43 = createEdge u4 u3 22
e23 = createEdge u2 u3 31.4

net = buildNetwork [u1, u2, u3, u4] [e14, e12, e43, e23 ]
```

These definitions can be found in `tests/Example.elm`.
Thus we can make various computations as follows.

```
$ elm repl
> import Examples exposing(..)
> import Network expsoing(..)
> import Flow exposing(..)

> listNodes net
["U1","U2","U3","U4"]

> listEdges net
["U1->U4","U1->U2","U4->U3","U2->U3"]

> listEdgesWithFlow net
["U1->U4: 30","U1->U2: 90.4","U4->U3: 22","U2->U3: 31.4"]

> efficiency net
154.677

> resilience net
149.719 : Float

> alpha net
0.5081441618940449 : Float

> sustainabilityPercentage net
96.99 : Float
```

To see the structure of `net`, do this:

```
> net
Network [Node "U1",Node "U2",Node "U3",Node "U4"] [Edge (Node "U1") (Node "U4") 30,Edge (Node "U1") (Node "U2") 90.4,Edge (Node "U4") (Node "U3") 22,Edge (Node "U2") (Node "U3") 31.4]
    : Network
```

## Experiments

### Adding an edge

There are facilities for editing a given network in
order to experiment with changes in it.

```
> net2 = insertEdge "U1" "U3" 20 net

> sustainabilityPercentage net2
81.11 : Float
```

Note that inserting this edge decreased the sustainability.

### Deleting an edge

To delete an edge, use this syntax

```
deleteEdge name1 name2  network
```

Here is another experiment:

```
> net2 = deleteEdge "U1" "U4" net

> sustainabilityPercentage net2
73.02 : Float
```

### Modifying an edge

```
> net2 = replaceEdge "U1" "U4" 10 net

> sustainabilityPercentage net2
91.54 : Float
```

## JSON Decoders

Below is a JSON representation of network
we have been working with.

```
netAsJson = """
  {
    "nodes": [
      {"name": "U1" },
      {"name": "U2" },
      {"name": "U3" },
      {"name": "U4" }
    ],
    "edges": [
        {
          "from": "U1",
          "to": "U4",
          "amount": 30
        },
        {
          "from": "U1",
          "to": "U2",
          "amount": 90.4
        },
        {
          "from": "U4",
          "to": "U3",
          "amount": 22
        },
        {
          "from": "U2",
          "to": "U3",
          "amount": 31.4
        }
    ]
  }

"""
```

We can use it as follows:

```
> import Strings exposing(..) -- netAsJson is defined here
> import Decoder exposing(..) -- For: netWorkFromJson : String -> Network
> net = networkFromJson netAsJson
```

You an chadk that this is the same `net` that was defined before.
