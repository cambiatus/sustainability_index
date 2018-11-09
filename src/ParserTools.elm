module ParserTools exposing(flowRateFromString)

import Parser exposing(..)

type NetworkValue = NetworkValue Float String

flowRateFromString : String -> Float   
flowRateFromString str = 
  case run parseValue str of   
    Ok data -> flowRateFromNetworkValue data   
    Err _ -> 0

flowRateFromNetworkValue : NetworkValue -> Float 
flowRateFromNetworkValue (NetworkValue flowRate _) = flowRate

parseValue : Parser NetworkValue 
parseValue = 
  succeed NetworkValue
    |= float 
    |. spaces
    |= currencyName


currencyName : Parser String
currencyName =
  getChompedString <|
    succeed ()
      |. chompWhile Char.isAlpha

-- isStartChar : Char -> Bool
-- isStartChar char =
--   Char.isAlpha char

-- isInnerChar : Char -> Bool
-- isInnerChar char =
--   isStartChar char || Char.isDigit char