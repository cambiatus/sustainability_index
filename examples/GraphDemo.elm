module GraphDemo exposing (..)

import Html exposing (Html, div, text, p)
import Html.Attributes exposing (..)
import Svg exposing (svg)
import Svg.Attributes as SA
import DisplayGraph exposing (Graph, Vertex, graphDisplay)
import Vector exposing (Vector)
import Affine


main : Html msg
main =
    div [] [ display ]


display : Html msg
display =
    div mainStyle
        [ svg
            [ width 200, height 200 ]
            (graphDisplay 100 testGraph)
        , p legendStyle  [ text "Graph" ]
        ]


testGraph =
    Graph vertices edges


vertices =
    [ Vertex 1 "A", Vertex 2 "B", Vertex 3 "C", Vertex 4 "D", Vertex 5 "E" ]


edges =
    [ ( 1, 2 ), ( 1, 3 ), ( 2, 3 ), ( 2, 4 ), ( 2, 5 ), ( 3, 4 ), ( 4, 5 ) ]


mainStyle =
        [  style "padding" "40px"
        ,  style "width" "220px"
        ,  style "height" "220px"
        ,  style "background-color" "#ddd" 
        ]


legendStyle =
        [  style "margin-left" "75px" ]
