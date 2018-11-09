module ColorRecord exposing (ColorRecord, rgba, mix)

{-| This module exposes the ColorRecord type. Color records
can be manipulated mathemaitcall, e.g., if x and y are
color records, then so is mix x y -- it is a kind of average
of x and y .

The function rgba x y converts a color record to a string compatible
with SVG.


# API

@docs ColorRecord, rgba, mix

-}


{-| A record which represents a color.
-}
type alias ColorRecord =
    { r : Int, g : Int, b : Int, a : Float }


{-| Take the average of two ColorRecords
-}
mix : ColorRecord -> ColorRecord -> ColorRecord
mix a b =
    let
        rr =
            intAverage a.r b.r

        gg =
            intAverage a.g b.g

        bb =
            intAverage a.b b.b

        aa =
            (a.a + b.a) / 2.0
    in
        ColorRecord rr gg bb aa


intAverage i j =
    let
        sum =
            toFloat <| i + j

        average =
            sum / 2.0
    in
        round average


{-| Convert a ColorRecord into a string compatible with SVG
-}
rgba : ColorRecord -> String
rgba color =
    "rgba(" ++ String.fromInt color.r ++ "," ++ String.fromInt color.g ++ "," ++ String.fromInt color.b ++ "," ++ String.fromFloat color.a ++ ")"
