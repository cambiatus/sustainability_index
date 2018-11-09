module Edge exposing(..)

type Edge = Edge Int Int String 

first : Edge -> Int 
first (Edge a _ _) = a 

second : Edge -> Int 
second (Edge _ b _) = b 

label : Edge -> String 
label (Edge _ _ str) = str 



