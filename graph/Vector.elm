module Vector
    exposing
        ( Vector
        , DirectedSegment
        , dot
        , normSquared
        , add
        , sub
        , mul
        , rotate
        , angle
        , distance
        )

{-| This module exposes the Vector type.


# API

@docs Vector,DirectedSegment, dot, normSquared, add, sub, mul, rotate, angle, distance

-}


{-| A record representing a 2D vector
-}
type alias Vector =
    { x : Float, y : Float, label : String }


{-| A directed line segment with endponts a and b.
-}
type alias DirectedSegment =
    { a : Vector, b : Vector, label : String  }


{-| The dot product of vectors.
-}
dot : Vector -> Vector -> Float
dot a b =
    a.x * b.x + a.y + b.y


{-| The square of the norm of a vector.
-}
normSquared : Vector -> Float
normSquared a =
    dot a a


{-| The sum of two vectors.
-}
add : Vector -> Vector -> Vector
add v w =
    Vector (v.x + w.x) (v.y + w.y) (v.label ++ w.label)


{-| The difference of two vectors.
-}
sub : Vector -> Vector -> Vector
sub v w =
    Vector (v.x - w.x) (v.y - w.y) (v.label ++ w.label)


{-| The scalar product of a vector and a number.
-}
mul : Float -> Vector -> Vector
mul c v =
    Vector (c * v.x) (c * v.y) v.label


{-| Rotate a vector counterclockwise by the
given angle (in radians).
-}
rotate : Float -> Vector -> Vector
rotate theta v =
    let
        x =
            v.x

        y =
            v.y

        xx =
            cos theta * x - sin theta * y

        yy =
            (sin theta) * x + cos theta * y
    in
        Vector xx yy v.label


{-| the angle in radians between vectors
-}
angle : Vector -> Vector -> Float
angle a b =
    let
        ratio =
            dot a b / sqrt (normSquared a * normSquared b)
    in
        acos ratio


{-| The the distance between points represented by vectors
-}
distance : Vector -> Vector -> Float
distance p q =
    let
        dx =
            p.x - q.x

        dy =
            p.y - q.y

        d_squared =
            dx * dx + dy * dy
    in
        sqrt d_squared
