module Decoder exposing(..)

import Network exposing(Node(..), Edge(..), Network(..), SimpleEdge(..), 
  sourceNameOfSimpleEdge, sinkNameOfSimpleEdge, createNode
  , edgeListFromSimpleEdgeList, emptyNetwork)

import Flow exposing(sustainabilityPercentage)

import Json.Decode exposing(Decoder, map, map2, map3, maybe, 
   field, string, float, list, decodeString)
   
import Tools exposing(unique)

---
--- BUILD
---

networkFromJson2 : String -> Network   
networkFromJson2 str =
  Network (nodesFromJson str) (edgesFromJson str)



simpleEdgeListFromJson : String -> List (SimpleEdge) 
simpleEdgeListFromJson jsonString = 
  case decodeString decodeSimpleEdgeList jsonString of 
     Err _ -> []
     Ok edgeList -> edgeList


nodesFromJson : String -> (List Node)
nodesFromJson str = 
  nodeNamesFromJson str |> List.map createNode

nodeNamesFromJson : String -> (List String)
nodeNamesFromJson str  =
  let 
    simpleEdgeList = simpleEdgeListFromJson str
    sourceNodeNames = simpleEdgeList |> List.map sourceNameOfSimpleEdge
    sinkNodeNames = simpleEdgeList |> List.map sinkNameOfSimpleEdge
  in   
    sourceNodeNames ++ sinkNodeNames |> unique |> List.sort


networkFromJson : String -> Network 
networkFromJson jsonString = 
  case decodeString decodeNetwork jsonString of 
     Err _ -> emptyNetwork 
     Ok network -> network


edgesFromJson : String -> (List Edge)
edgesFromJson jsonString =
  case decodeString decodeSimpleEdgeList jsonString of  
    Err _ -> [] 
    Ok simpleEdgeList -> edgeListFromSimpleEdgeList simpleEdgeList

---
--- JSON DECODERS
---


decodeNetwork : Decoder Network 
decodeNetwork = 
  map2 Network
    (field "nodes" (list decodeNode))
    (field "edges" (map edgeListFromSimpleEdgeList (list decodeSimpleEdge)))

decodeNode : Decoder Node
decodeNode =
  map Node
    (field "name" string)

decodeEdge : Decoder Edge
decodeEdge =
  map3 Edge
    (field "from" decodeNode)
    (field "to" decodeNode)
    (field "amount" float)

---
--- SIMPLE EDGES
---

decodeSimpleEdge : Decoder SimpleEdge 
decodeSimpleEdge =
  map3 SimpleEdge 
     (field "from" string)
     (field "to" string)
     (field "amount" float)

decodeSimpleEdgeList : Decoder (List SimpleEdge)
decodeSimpleEdgeList = 
  (field "edges" (list decodeSimpleEdge))

