module LineSegment exposing (LineSegment, affineTransform, draw, moveTo, moveBy, scaleBy)

{-| This module exposes the lineSegment type. Values of this type
can be manipulated mathematically and rendered in to SVG.


# API

@docs LineSegment, affineTransform, draw, moveTo, moveBy, scaleBy

-}

import Affine
import ColorRecord exposing (..)
import Svg as S exposing (..)
import Svg.Attributes exposing (..)
import Vector exposing (Vector)
import SvgText


{-| A record which models a line segment with
endpoints a and b.
-}
type alias LineSegment =
    { a : Vector
    , b : Vector
    , width : Float
    , strokeColor : ColorRecord
    , fillColor : ColorRecord
    , label : String
    }


{-| Apply an affine transform to a lineSegment.
-}
affineTransform : Affine.Coefficients -> LineSegment -> LineSegment
affineTransform coefficients lineSegment =
    let
        newA =
            Affine.affineTransform coefficients lineSegment.a

        newB =
            Affine.affineTransform coefficients lineSegment.b
    in
        { lineSegment | a = newA, b = newB }


{-| Produce an SVG representation of a lineSegment.
  (n_x, n_y)     = normal vector to segment
  (un_x, un_y)   = unit normal
  (unn_x, unn_y) = the unit normal with positive y component
  The label is drawn, to  first approximation, at a point
  obtained by translating the midpoint of the segment 
  a distance   k   along the unit normal with positive
  y-component.  It is rotated around that point so that
  the baseline of the text is parallel to the segment.
-}
draw : LineSegment -> List (S.Svg msg)
draw segment =
   let   
    n_x = -(segment.a.y - segment.b.y)
    n_y = segment.a.x - segment.b.x
    normSquared = n_x*n_x + n_y*n_y
    norm = sqrt normSquared
    un_x = n_x/norm  
    un_y = n_y/norm
    ut_x = (segment.b.x - segment.a.x)/norm
    ut_y = (segment.b.y - segment.a.y)/norm
    utt_x = if ut_x > 0 then ut_x else ( -ut_x)
    utt_y = if un_x > 0 then ut_y else ( -ut_y)
    unn_y = if un_y > 0 then un_y else ( -un_y)
    unn_x = if un_y > 0 then un_x else ( -un_x)
    a = -8
    b = 0
    x_mid = (segment.a.x + segment.b.x)/2 + a*unn_x + b*utt_x
    y_mid = (segment.a.y + segment.b.y)/2 + a*unn_y + b*utt_y
    angle = (57.29564553  * (acos unn_x)) - 90
  in
    [
        S.line (lineAttributes segment) []
      , SvgText.textDisplay 12 x_mid y_mid angle segment.label
    ]


{-| Move a lineSegment to a new position: translante
it so that its first endpoint is at the given position.
-}
moveTo : Vector -> LineSegment -> LineSegment
moveTo position lineSegment =
    let
        displacement =
            Vector.sub lineSegment.b lineSegment.a

        newB =
            Vector.add displacement position
    in
        { lineSegment | a = position, b = newB }


{-| Translate a lineSegment.
-}
moveBy : Vector -> LineSegment -> LineSegment
moveBy displacement lineSegment =
    let
        newA =
            Vector.add displacement lineSegment.a

        newB =
            Vector.add displacement lineSegment.b
    in
        { lineSegment | a = newA, b = newB }


{-| Scale a line segment by a factor. That is,
dilate with center at the origin.
-}
scaleBy : Float -> LineSegment -> LineSegment
scaleBy factor lineSegment =
    let
        newA =
            Vector.mul factor lineSegment.a

        newB =
            Vector.mul factor lineSegment.b
    in
        { lineSegment | a = newA, b = newB }


lineAttributes : LineSegment -> List (Attribute msg)
lineAttributes lineSegment =  
    [ fill (rgba lineSegment.fillColor)
    , stroke (rgba lineSegment.fillColor)
    , x1 (String.fromFloat lineSegment.a.x)
    , y1 (String.fromFloat lineSegment.a.y)
    , x2 (String.fromFloat lineSegment.b.x)
    , y2 (String.fromFloat lineSegment.b.y)
    , strokeWidth (String.fromFloat lineSegment.width)
    ]
