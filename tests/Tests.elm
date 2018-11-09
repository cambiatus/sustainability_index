module Tests exposing (..)

import Expect exposing (Expectation, FloatingPointTolerance(..))
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Network exposing(..)
import Decoder exposing(..)
import Json.Decode exposing(decodeString)
import Strings exposing(..)
import Flow exposing(..)

doTest comment inputExpression outputExpression =
    test comment <|
        \_ ->
            Expect.equal inputExpression outputExpression

doFloatTest comment inputExpression outputExpression =
    test comment <|
        \_ ->
            Expect.within (Relative 0.0001) inputExpression outputExpression


u1 = createNode "U1"
u2 = createNode "U2"
u3 = createNode "U3"
u4 = createNode "U4"

e14 = createEdge u1 u4 30
e12 = createEdge u1 u2 90.4
e43 = createEdge u4 u3 22
e23 = createEdge u2 u3 31.4


net = buildNetwork [u1, u2, u3, u4] [e14, e12, e43, e23 ] 

net2 = Network 
         [Node "U1",Node "U2",Node "U3",Node "U4"] 
         [Edge (Node "U1") (Node "U4") 30,Edge (Node "U1") (Node "U2") 90.4,Edge (Node "U4") (Node "U3") 22,Edge (Node "U2") (Node "U3") 31.4]

--
  -- NETWORK TEST DATA
--


suite : Test
suite =
    describe "The Network module" [
          creationSuite 
        , flowSuite
        , jsonSuite
    ]

creationSuite = describe "Create nodes, edges, networks" 
    [ 
        doTest
        "1. Create node"
        (name (createNode "A"))
        ("A")
    , doTest
        "2. Equal nodes"
        (equalNodes (createNode "A") (createNode "A"))
        (True)
    , doTest
        "2. Unequal nodes"
        (equalNodes (createNode "A") (createNode "B"))
        (False)
    , doTest
        "3. Build network and count nodes"
        (nodeCount net)
        (4)
    , doTest
        "4. Build network and count edges"
        (edgeCount net)
        (4)
    , doTest
        "5. insertEdge"
        ((edgeCount (insertEdge "U1" "U3" 10 net)))
        (5)
        , doTest
        "6. deleteEdge"
        ((edgeCount (deleteEdge "U1" "U4" net)))
        (3)
    , doTest
        "7. replaceEdge"
        ((Maybe.map edgeFlow (getEdge "U1" "U4" (replaceEdge "U1" "U4" 1.234 net))))
        (Just 1.234)
  ] 

flowSuite = describe "Test flows" 
    [ 
      doFloatTest 
        "1. totalFlow"
        (totalFlow net)
        (173.8)
    , doFloatTest
        "2. efficiency"
        (efficiency net)
        (154.677)
    , doFloatTest
        "3. resilience"
        (resilience net)
        (149.719)
    , doFloatTest
        "4. alpha"
        (alpha net)
        (0.50814)
    , doFloatTest
        "5. sustainability"
        (sustainability net)
        (0.9699)
    ] 

jsonSuite = describe "Json decoders"
  [
    doTest
      "1. Decode node"
      (decodeString decodeNode nodeAAsJson)
      (Ok (Node "A"))
    , doTest
      "2. Decode edge"
      (decodeString decodeEdge edgeABAsJson)
      (Ok (Edge (Node "A") (Node "B") 17.3))
    , doTest
      "3. Decode simple edge"
      (decodeString decodeSimpleEdge simpleEdgeAB)
      (Ok (SimpleEdge "A" "B" 17.3))
    , doTest
      "4. Construct network from Json"
      (networkFromJson netAsJson)
      (net2)
    , doTest
      "5. Construct simple edge list from JSON"
      (decodeString decodeSimpleEdgeList simpleEdgeListAsJson)
      (Ok [SimpleEdge "U1" "U4" 30,SimpleEdge "U1" "U2" 90.4,SimpleEdge "U4" "U3" 22,SimpleEdge "U2" "U3" 31.4])
    , doTest
      "6. Construct simple edge list from JSON"
      (simpleEdgeListFromJson simpleEdgeListAsJson)
      ([SimpleEdge "U1" "U4" 30,SimpleEdge "U1" "U2" 90.4,SimpleEdge "U4" "U3" 22,SimpleEdge "U2" "U3" 31.4])
    

  ]

jsonXX = """
{"value":"1 BES","to":"james1111111","symbol":"BES","memo":"","from":"lucca1111111","block_time":"2018-11-03T18:48:52.500"}
"""
 
jsonSuite2 = describe "Json decoders"
  [
    doTest
      "1. Decode simple edge"
      (decodeString decodeSimpleEdge simpleEdgeAB)
      (Ok (SimpleEdge "A" "B" 17.3))
    , doTest
      "4. Construct network from Json"
      (networkFromJson netAsJson)
      (net2)
    , doTest
      "5. Construct simple edge list from JSON"
      (decodeString decodeSimpleEdgeList simpleEdgeListAsJson)
      (Ok [SimpleEdge "U1" "U4" 30,SimpleEdge "U1" "U2" 90.4,SimpleEdge "U4" "U3" 22,SimpleEdge "U2" "U3" 31.4])
    , doTest
      "6. Construct simple edge list from JSON"
      (simpleEdgeListFromJson simpleEdgeListAsJson)
      ([SimpleEdge "U1" "U4" 30,SimpleEdge "U1" "U2" 90.4,SimpleEdge "U4" "U3" 22,SimpleEdge "U2" "U3" 31.4])
    

  ]