module SvgText exposing(..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


textDisplay1 : Int -> Float -> Float -> String -> Svg msg 
textDisplay1 fontSize_ x_ y_ content = 
  text_ [ 
      x <| String.fromFloat x_ 
    , y <| String.fromFloat y_
    , fontSize <| String.fromInt fontSize_
    ] [text content]

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
