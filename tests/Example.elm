module Example exposing(..)

import Network exposing(
     createNode
    , createEdge
    , buildNetwork
  )


import Flow exposing(
      efficiency,
      resilience,
      sustainability,
      sustainabilityPercentage
  )


u1 = createNode "U1"
u2 = createNode "U2"
u3 = createNode "U3"
u4 = createNode "U4"

e14 = createEdge u1 u4 30
e12 = createEdge u1 u2 90.4
e43 = createEdge u4 u3 22
e23 = createEdge u2 u3 31.4


net = buildNetwork [u1, u2, u3, u4] [e14, e12, e43, e23 ] 


