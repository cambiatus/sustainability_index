module Decoder2 exposing(networkFromJson)

import Network exposing(Node(..), Edge(..), Network(..), SimpleEdge(..), 
  sourceNameOfSimpleEdge, sinkNameOfSimpleEdge, createNode
  , edgeListFromSimpleEdgeList, emptyNetwork)

import Flow exposing(sustainabilityPercentage)

import Json.Decode exposing(Decoder, map, map3, field, string, float, list, decodeString)
   
import Tools exposing(unique)

import ParserTools


{-| Build network from Json string 
-}
networkFromJson : String -> Network   
networkFromJson     str =
  Network (nodesFromJson str) (edgesFromJson str)



--
-- HELPER FUNCTIONS
--


nodesFromJson : String -> (List Node)
nodesFromJson str = 
  nodeNamesFromJson str |> List.map createNode

nodeNamesFromJson : String -> (List String)
nodeNamesFromJson str  =
  let 
    simpleEdgeList = simpleEdgesFromJson str
    sourceNodeNames = simpleEdgeList |> List.map sourceNameOfSimpleEdge
    sinkNodeNames = simpleEdgeList |> List.map sinkNameOfSimpleEdge
  in   
    sourceNodeNames ++ sinkNodeNames |> unique |> List.sort

simpleEdgesFromJson : String -> (List SimpleEdge)
simpleEdgesFromJson jsonString =
  case decodeString decodeEdgesFromData jsonString of  
    Err _ -> [] 
    Ok simpleEdgeList -> simpleEdgeList


edgesFromJson : String -> (List Edge)
edgesFromJson jsonString =
  case decodeString decodeEdgesFromData jsonString of  
    Err _ -> [] 
    Ok simpleEdgeList -> edgeListFromSimpleEdgeList simpleEdgeList

---
--- JSON DECODERS
---


decodeEdgesFromData : Decoder (List SimpleEdge)
decodeEdgesFromData = 
  field "data" decodeSimpleEdgeList


decodeSimpleEdgeList : Decoder (List SimpleEdge)
decodeSimpleEdgeList = 
  list decodeSimpleEdge



decodeSimpleEdge : Decoder SimpleEdge 
decodeSimpleEdge =
  map3 SimpleEdge 
     (field "from" string)
     (field "to" string)
     (field "value" string |> map ParserTools.flowRateFromString)

