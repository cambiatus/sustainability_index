module Flow exposing(..)

import Network exposing(..)


{-  
  Functions for the model
 -}

efficiencyOfEdge : Float ->  Network -> Edge ->Float 
efficiencyOfEdge totalFlow_ network (Edge sourceNode sinkNode flow)  = 
   let
     edge = (Edge sourceNode sinkNode flow)
     edgeFlow_ = edgeFlow edge
     denominator = (outflowFromNode network sourceNode) * (inflowToNode network sinkNode)
     numerator = (edgeFlow_) * totalFlow_
     logRatio = (logBase 2)(numerator/denominator)
   in
     roundTo 3 (edgeFlow_ * logRatio)

resilienceOfEdge : Float ->  Network -> Edge ->Float 
resilienceOfEdge totalFlow_ network (Edge sourceNode sinkNode flow)  = 
   let
     edge = (Edge sourceNode sinkNode flow)
     edgeFlow_ = edgeFlow edge
     denominator = (outflowFromNode network sourceNode) * (inflowToNode network sinkNode)
     numerator = edgeFlow_* edgeFlow_
     logRatio = (logBase 2)(numerator/denominator)
   in
     edgeFlow_ * logRatio

efficiency : Network -> Float 
efficiency (Network nodes edges) =
  let   
    network = (Network nodes edges)
    totalFlow_ = totalFlow network 
  in 
    List.map (efficiencyOfEdge totalFlow_ network) edges  
      |> List.sum
      |> \x -> roundTo 3 x

resilience : Network -> Float 
resilience (Network nodes edges) =
  let   
    network = (Network nodes edges)
    totalFlow_ = totalFlow network 
  in 
    List.map (resilienceOfEdge totalFlow_ network) edges  
      |> List.sum
      |> \x -> -(roundTo 3 x)  

alpha : Network -> Float 
alpha network = 
  let 
    ratio = 1 + ((resilience network) / (efficiency network))
  in   
    1/ratio  

sustainability : Network -> Float 
sustainability network = 
  let   
    a = alpha network 
    aa = a^1.288
    s =  -1.844 * aa * (logBase 2 aa)
  in 
    roundTo 4 s

sustainabilityPercentage : Network -> Float  
sustainabilityPercentage network = 
  roundTo 2 (100 * (sustainability network))

{-

 Auxiliary functions

-}

roundTo : Int -> Float -> Float 
roundTo places quantity = 
  let   
    factor = 10^places
    ff = (toFloat factor)
    q2 = ff * quantity
    q3 = round q2
  in   
    (toFloat q3) / ff 