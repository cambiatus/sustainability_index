

import Svg exposing (..)
import Svg.Attributes exposing (..)


textDisplay : Int -> Float -> Float -> Float -> String -> Svg msg 
textDisplay fontSize_ x_ y_  theta_  content = 
  let 
    angle = String.fromFloat theta_  
    xrr_ = String.fromFloat x_
    yrr_ = String.fromFloat y_ 
    rotate_ = "rotate(" ++ angle ++ " " ++ xrr_ ++ " " ++ yrr_ ++ ")"
  in
  text_ [ 
      x <| String.fromFloat x_ 
    , y <| String.fromFloat y_
    , fontSize <| String.fromInt fontSize_
    , transform rotate_
    ] [text content]

main =
  svg
    [ width "300"
    , height "300"
    , viewBox "0 0 300 300"
    ]
    [ 
       textDisplay 24 10 40 0  "Fruit:"
     , textDisplay 24 10 80 0  "Bananas"
     , textDisplay 24 10 120 -10  "Bananas"
     , textDisplay 24 10 160 90  "Bananas"
    ]

