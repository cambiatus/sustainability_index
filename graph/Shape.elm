module Shape exposing (Shape(..), ShapeData, affineTransform, draw, moveBy, moveTo, scaleBy)

{-| This module exposes the Shape type. Values of this type
can be manipulated mathematically and rendered in to SVG.


# API

@docs Shape, ShapeData, affineTransform, draw, moveBy, moveTo, scaleBy

-}

import Affine
import ColorRecord exposing (..)
import Svg as S exposing (..)
import Svg.Attributes exposing (..)
import Vector exposing (Vector)
import SvgText


{-| A type for representing shapes: rectangles or ellipses
-}
type Shape
    = Rect ShapeData
    | Ellipse ShapeData


{-| A type for representing the data needed
to define a shape.
-}
type alias ShapeData =
    { center : Vector
    , dimensions : Vector
    , strokeColor : ColorRecord
    , fillColor : ColorRecord
    , label : String
    , info : String
    }


{-| Transformm a shape by an affine function.
-}
affineTransform : Affine.Coefficients -> Shape -> Shape
affineTransform coefficients shape =
    let
        shapeData =
            data shape

        newCenter =
            Affine.affineTransform coefficients shapeData.center

        newDimensions =
            Affine.linearTransform coefficients shapeData.dimensions

        newShapeData =
            { shapeData | center = newCenter, dimensions = newDimensions }
    in
        updateData shape newShapeData


{-| Produce an SVG representation of a shape.
-}
draw : Shape -> List (S.Svg msg)
draw shape =
    let
        deltaX =
            -8

        deltaY =
            30
    in
        case shape of
            Rect data_ ->
                [ S.rect (svgRectAttributes data_) [], SvgText.textDisplay 14 (data_.center.x + deltaX) (data_.center.y + deltaY) 0 data_.label ]

            Ellipse data_ ->
                [ S.ellipse (svgEllipseAttributes data_) []
                , S.image
                    [ x (String.fromFloat (data_.center.x - 20))
                    , y (String.fromFloat (data_.center.y - 20))
                    , width "40px"
                    , height "40px"
                    , xlinkHref data_.info

                    --, xlinkHref ""
                    -- , xlinkHref "https://s3.amazonaws.com/noteimages/jxxcarlson/hello.jpg"
                    ]
                    []
                , SvgText.textDisplay 14 (data_.center.x + deltaX) (data_.center.y + deltaY) 0 data_.label
                ]



{-

   <svg width="5cm" height="4cm" version="1.1"
          xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
   	<image xlink:href="firefox.jpg" x="0" y="0" height="50px" width="50px"/>
   </svg>

-}
-- https://ca.slack-edge.com/T0CJ5UNHK-U2VCR5R6H-g0a0d4d97299-72


updateData : Shape -> ShapeData -> Shape
updateData shape data_ =
    case shape of
        Rect _ ->
            Rect data_

        Ellipse _ ->
            Ellipse data_


data : Shape -> ShapeData
data shape =
    case shape of
        Rect data_ ->
            data_

        Ellipse data_ ->
            data_


{-| Move the center of a shape.
-}
moveTo : Vector -> Shape -> Shape
moveTo position shape =
    let
        shapeData =
            data shape

        center =
            shapeData.center

        newCenter =
            { center | x = position.x, y = position.y }

        newShapeData =
            { shapeData | center = newCenter }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


{-| Translate the center of a shape.
-}
moveBy : Vector -> Shape -> Shape
moveBy displacement shape =
    let
        shapeData =
            data shape

        center =
            shapeData.center

        newCenter =
            { center | x = displacement.x + center.x, y = displacement.y + center.y }

        newShapeData =
            { shapeData | center = newCenter }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


{-| Rescale a shape.
-}
scaleBy : Float -> Shape -> Shape
scaleBy factor shape =
    let
        shapeData =
            data shape

        center =
            shapeData.center

        newCenter =
            { center | x = factor * center.x, y = factor * center.y }

        dimensions =
            shapeData.dimensions

        newDimensions =
            { dimensions | x = factor * dimensions.x, y = factor * dimensions.y }

        newShapeData =
            { shapeData | center = newCenter, dimensions = newDimensions }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


svgRectAttributes : ShapeData -> List (Attribute msg)
svgRectAttributes data_ =
    [ fill (rgba data_.fillColor)
    , stroke (rgba data_.fillColor)
    , x (String.fromFloat (data_.center.x - data_.dimensions.x / 2))
    , y (String.fromFloat (data_.center.y - data_.dimensions.y / 2))
    , width (String.fromFloat data_.dimensions.x)
    , height (String.fromFloat data_.dimensions.y)
    ]


svgEllipseAttributes : ShapeData -> List (Attribute msg)
svgEllipseAttributes data_ =
    [ fill (rgba data_.fillColor)
    , stroke (rgba data_.fillColor)
    , cx (String.fromFloat data_.center.x)
    , cy (String.fromFloat data_.center.y)
    , rx (String.fromFloat data_.dimensions.x)
    , ry (String.fromFloat data_.dimensions.y)
    ]
