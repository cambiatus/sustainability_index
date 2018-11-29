module Display exposing (..)

import DisplayGraph exposing (Vertex, Graph)
import Network exposing (Network(..))
import Dict exposing (Dict)
import Svg exposing (Svg)
import Edge exposing (..)


networkDisplay : Float -> Network -> List (Svg msg)
networkDisplay scale network =
    DisplayGraph.graphDisplay scale <| graphFromNetwork network


graphFromNetwork : Network -> Graph
graphFromNetwork network =
    let
        dict =
            makeNodeDictionary network

        vertices =
            vertexList network

        edges =
            graphEdgesFromNetwork dict network
    in
        { vertices = vertices, edges = edges }


vertexList : Network -> List Vertex
vertexList network =
    List.indexedMap
        (\index item -> { id = index + 1, label = Tuple.first item, info = Tuple.second item })
        (Network.listNodesVerbose network)


type alias NodeDictionary =
    Dict String Int


makeNodeDictionary : Network -> NodeDictionary
makeNodeDictionary network =
    Dict.fromList <|
        List.indexedMap
            (\index label -> ( label, index + 1 ))
            (Network.listNodes network)


nodeIndex : NodeDictionary -> String -> Int
nodeIndex dict nodeName =
    Dict.get nodeName dict
        |> Maybe.withDefault -1


graphEdgeFromNetworkEdge : NodeDictionary -> Network.Edge -> Edge
graphEdgeFromNetworkEdge dict (Network.Edge from to flow) =
    let
        f =
            nodeIndex dict (Network.name from)

        t =
            nodeIndex dict (Network.name to)
    in
        Edge f t (String.fromFloat flow)


graphEdgesFromNetwork : NodeDictionary -> Network -> List Edge
graphEdgesFromNetwork dict (Network nodes edges) =
    List.map
        (graphEdgeFromNetworkEdge dict)
        edges
