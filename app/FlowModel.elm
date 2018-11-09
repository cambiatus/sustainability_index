module FlowModel exposing(
    displayNodes
  , displayEdges
  , displayListWithTitle
  , report
  , exampleNetwork
  )

import Element exposing(Element, text, px, el, alignRight)
import Element.Font as Font

import Network exposing(
    Network(..)
    , listNodes
    , listEdgesWithFlow
    , nodeCount
    , edgeCount
    , totalFlow
   )
import Flow exposing(
    efficiency
    , resilience
    , sustainabilityPercentage
    , roundTo
    )



import Example

type alias Item = 
  { 
      label: String,
      value: String
  }

summarize : Network -> List Item
summarize network = 
  [
        { label = "Nodes", value = String.fromInt <| nodeCount network }
      , { label = "Edges", value = String.fromInt <| edgeCount network } 
      , { label = "Total flow", value = String.fromFloat <| (roundTo 0) <| totalFlow network }
      , { label = "Efficiency", value = String.fromFloat <| (roundTo 0) <| efficiency network }
      , { label = "Resilience", value = String.fromFloat <| (roundTo 0) <| resilience network }
      , { label = "Sustainability", value = String.fromFloat <| (roundTo 0) <| sustainabilityPercentage network }


  ]
  
report : Network -> Element msg
report network = 
    Element.table [Element.spacing 10, Element.width (px 160) ]
        { data = summarize network
        , columns =
            [ { header = el [Font.bold] (Element.text "Measure")
                , width = (px 40)
                , view =
                        \datum ->
                            Element.text datum.label
              }
            , { header = el [Font.bold] <| alignRightElement 90 "Value"
                , width = (px 90)
                , view =
                        \datum -> alignRightElement 90 datum.value
                            -- Element.el [Element.width (px 90)] (
                            --         Element.el [alignRight] (Element.text datum.value))

              }
            ]
        }
    

alignRightElement : Int -> String -> Element msg 
alignRightElement width_ str = 
  Element.el [Element.width (px width_)] (
        Element.el [alignRight] (Element.text str)
 )

displayListWithTitle : String -> List(Element msg) -> List(Element msg)
displayListWithTitle title list = 
  [Element.el [Font.bold] (text title)] ++ list

displayNodes : Network -> List(Element msg)
displayNodes network = 
  listNodes network 
    |> List.sort
    |> List.map (\node -> Element.row [] [text node])

displayEdges : Network -> List(Element msg)
displayEdges network = 
  listEdgesWithFlow network
    |> List.sort 
    |> List.map (\edge -> Element.row [] [text edge])

exampleNetwork : Network
exampleNetwork = Example.net

