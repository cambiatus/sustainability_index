module Affine exposing (Coefficients, affineTransform, linearTransform, coefficients)

{-| This module exposes two functions, affineTransform and linearTransorm, for mapping
2D vecors to 2D vectors.


# API

@docs Coefficients, affineTransform, linearTransform, coefficients

-}

import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import Vector exposing (..)


type alias Rect =
    { corner : Vector
    , size : Vector
    }


{-| Coefficients is a data structure for the
coefficients of an affine transformation

xx = ax + b
yy= cy + d

-}
type alias Coefficients =
    { a : Float
    , b : Float
    , c : Float
    , d : Float
    }


{-| The coefficients function maps a pair
of rectangles, sourceRect and targetRect,
to a record of coeffients for an affine
transformation. The resulting transformation
maps sourceRect to targetRect.
-}
coefficients : Rect -> Rect -> Coefficients
coefficients sourceRect targetRect =
    let
        aa =
            targetRect.size.x / sourceRect.size.x

        bb =
            targetRect.corner.x - sourceRect.corner.x

        cc =
            -targetRect.size.y / sourceRect.size.y

        dd =
            targetRect.corner.y - sourceRect.corner.y + targetRect.size.y
    in
        { a = aa, b = bb, c = cc, d = dd }


{-| affineTransform coefficients is an affine
transformations mapping vectors to vectors.
-}
affineTransform : Coefficients -> Vector -> Vector
affineTransform coefficients_ point =
    let
        x =
            coefficients_.a * point.x + coefficients_.b

        y =
            coefficients_.c * point.y + coefficients_.d
    in
        Vector x y point.label point.info


{-| linearTransform coefficients is an affine
transformations mapping vectors to vectors.
-}
linearTransform : Coefficients -> Vector -> Vector
linearTransform coefficients_ size =
    let
        w =
            abs coefficients_.a * size.x

        h =
            abs coefficients_.c * size.y

        -- 5.0 * size.height
    in
        Vector w h size.label size.info
