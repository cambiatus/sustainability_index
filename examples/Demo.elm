module Demo exposing (..)

import Html exposing (Html, div, text, p)
import Html.Attributes exposing (..)
import Svg exposing (svg)
import Svg.Attributes as SA
import Vector exposing (Vector)
import Shape exposing (..)
import ColorRecord exposing (..)
import Affine


main : Html msg
main =
    div [] [ display ]


display : Html msg
display =
    div mainStyle
        [ svg
            [ width 300, height 300 ]
            (List.map draw shapes)
        ]


blackColor =
    ColorRecord 0 0 0 1.0


strokeClolor =
    blackColor


borderSquareColor =
    ColorRecord 20 20 20 1.0


bg =
    Rect
        { center = (Vector 0 0)
        , dimensions = (Vector 210 210)
        , strokeColor = strokeClolor
        , fillColor = ColorRecord 180 190 240 1
        }


r1 =
    Rect
        { center = (Vector 0 0)
        , dimensions = (Vector 10 10)
        , strokeColor = strokeClolor
        , fillColor = borderSquareColor
        }


r2 =
    moveBy (Vector 50 0) r1


r3 =
    moveBy (Vector 50 0) r2


r4 =
    moveBy (Vector 0 50) r3


r5 =
    moveBy (Vector 0 50) r4


r6 =
    moveBy (Vector -50 0) r5


r7 =
    moveBy (Vector -50 0) r6


r8 =
    moveBy (Vector 0 -50) r7


e1 =
    Ellipse
        { center = (Vector 50 50)
        , dimensions = (Vector 40 20)
        , strokeColor = blackColor
        , fillColor = ColorRecord 0 100 255 0.5
        }


e2 =
    Ellipse
        { center = (Vector 50 50)
        , dimensions = (Vector 20 40)
        , strokeColor = blackColor
        , fillColor = ColorRecord 100 0 255 0.7
        }


shapes =
    [ bg, r1, r2, r3, r4, r5, r6, r7, r8, e1, e2 ]
        |> List.map (moveBy (Vector 5 5))
        |> List.map (scaleBy 2)


mainStyle =
        [ style "padding" "50px" 
        , style "width" "300px" 
        , style "height" "300px"
        , style "background-color" "#eee" 
        ]
