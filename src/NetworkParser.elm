module NetworkParser exposing (
    NodeUrl(..)
     , simpleEdgeListFromString
     , stringOfSimpleEdgeList
     , nodesFromString
     , edgeListFromString
     , networkFromString 
     , identifier)

import Parser exposing (..)
import Parser.Extras exposing(many)
import Network
    exposing
        ( Network(..)
        , Node
        , SimpleEdge(..)
        , Edge(..)
        , createNode
        , sourceNameOfSimpleEdge
        , sinkNameOfSimpleEdge
        )
import Tools exposing (unique)


simpleEdgeListParser : Parser (List SimpleEdge)
simpleEdgeListParser =
    many simpleEdgeParser


stringOfSimpleEdgeList : List SimpleEdge -> String
stringOfSimpleEdgeList edgeList =
    edgeList
        |> List.map Network.stringOfSimpleEdge
        |> String.join " "


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


endsWithChar : Char -> Parser String
endsWithChar endChar =
    getChompedString <|
        succeed ()
            |. chompWhile (\char -> char /= endChar)


isStartChar : Char -> Bool
isStartChar char =
    Char.isAlpha char


isInnerChar : Char -> Bool
isInnerChar char =
    isStartChar char || Char.isDigit char


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


simpleEdgeListFromString : String -> List SimpleEdge
simpleEdgeListFromString str =
    case run simpleEdgeListParser str of
        Err _ ->
            []

        Ok edgeList ->
            edgeList


edgeListFromString : String -> List Edge
edgeListFromString str =
    simpleEdgeListFromString str
        |> Network.edgeListFromSimpleEdgeList


nodeNamesFromString : String -> List String
nodeNamesFromString str =
    let
        simpleEdgeList =
            simpleEdgeListFromString str

        sourceNodeNames =
            simpleEdgeList |> List.map sourceNameOfSimpleEdge

        sinkNodeNames =
            simpleEdgeList |> List.map sinkNameOfSimpleEdge
    in
        sourceNodeNames ++ sinkNodeNames |> unique |> List.sort


nodesFromString : String -> List Node
nodesFromString str =
    nodeNamesFromString str
        |> List.map (\str_ -> createNode str_ "")


type NodeUrl
    = NodeUrl String String


node : NodeUrl -> String
node (NodeUrl name _) =
    name


info : NodeUrl -> String
info (NodeUrl _ info_) =
    info_


nodeUrlListParser : Parser (List NodeUrl)
nodeUrlListParser =
    many nodeUrlParser


nodeUrlParser : Parser NodeUrl
nodeUrlParser =
    succeed NodeUrl
        |. spaces
        |= identifier
        |. symbol ","
        |. spaces
        |= endsWithChar ';'
        |. symbol ";"
