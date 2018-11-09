module NetworkParser exposing(..)

import Parser exposing(..)

import Network exposing(
      Network(..)
      , Node
      , SimpleEdge(..)
      , Edge(..)
      , createNode
      , sourceNameOfSimpleEdge
      , sinkNameOfSimpleEdge)

import Tools exposing(unique)


simpleEdgeListParser : Parser (List SimpleEdge)
simpleEdgeListParser = 
  many simpleEdgeParser

simpleEdgeParser : Parser SimpleEdge 
simpleEdgeParser = 
  succeed SimpleEdge  
    |= identifier 
    |. symbol ","
    |. spaces  
    |= identifier 
    |. symbol ","
    |. spaces   
    |= float  
    |. symbol ";"
    |. spaces    

identifier : Parser String
identifier =
  getChompedString <|
    succeed ()
      |. chompIf isStartChar
      |. chompWhile isInnerChar

isStartChar : Char -> Bool
isStartChar char =
  Char.isAlpha char

isInnerChar : Char -> Bool
isInnerChar char =
  isStartChar char || Char.isDigit char

{-| Apply a parser zero or more times and return a list of the results.
-}
many : Parser a -> Parser (List a)
many p =
    loop [] (manyHelp p)

manyHelp : Parser a -> List a -> Parser (Step (List a) (List a))
manyHelp p vs =
    oneOf
        [ succeed (\v -> Loop (v :: vs))
            |= p
            |. spaces
        , succeed ()
            |> map (\_ -> Done (List.reverse vs))
        ]





networkFromString : String -> Network   
networkFromString str =
  Network (nodesFromString str) (edgeListFromString str)


simpleEdgeListFromString : String -> (List SimpleEdge)
simpleEdgeListFromString str = 
  case run simpleEdgeListParser str of 
    Err _ -> []
    Ok edgeList -> edgeList

edgeListFromString : String -> (List Edge)
edgeListFromString str = 
  simpleEdgeListFromString str 
    |> Network.edgeListFromSimpleEdgeList

nodeNamesFromString : String -> (List String)
nodeNamesFromString str  =
  let 
    simpleEdgeList = simpleEdgeListFromString str
    sourceNodeNames = simpleEdgeList |> List.map sourceNameOfSimpleEdge
    sinkNodeNames = simpleEdgeList |> List.map sinkNameOfSimpleEdge
  in   
    sourceNodeNames ++ sinkNodeNames |> unique |> List.sort

nodesFromString : String -> List Node   
nodesFromString str = 
  nodeNamesFromString str
    |> List.map createNode


-- unique : List comparable -> List comparable
-- unique list =
--     uniqueHelp identity Set.empty list []


-- uniqueHelp : (a -> comparable) -> Set comparable -> List a -> List a -> List a
-- uniqueHelp f existing remaining accumulator =
--     case remaining of
--         [] ->
--             List.reverse accumulator

--         first :: rest ->
--             let
--                 computedFirst =
--                     f first
--             in
--             if Set.member computedFirst existing then
--                 uniqueHelp f existing rest accumulator

--             else
--                 uniqueHelp f (Set.insert computedFirst existing) rest (first :: accumulator)

