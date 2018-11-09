module Strings exposing(..)


nodeAAsJson = """
  {"name": "A" }
"""

nodeBAsJson = """
  {"name": "B"}
"""

edgeABAsJson = """
  {
     "from": {"name": "A" }, 
     "to": {"name": "B" },
     "amount": 17.3
  }
"""

netAsJson = """
  {
    "nodes": [
      {"name": "U1" }, 
      {"name": "U2" },
      {"name": "U3" }, 
      {"name": "U4" }
    ], 
    "edges": [
        {
          "from": "U1", 
          "to": "U4",
          "amount": 30
        },
        {
          "from": "U1", 
          "to": "U2",
          "amount": 90.4
        },
        {
          "from": "U4", 
          "to": "U3",
          "amount": 22
        },
        {
          "from": "U2", 
          "to": "U3",
          "amount": 31.4
        }
    ]
  }

"""


simpleEdgeListAsJson = """
   { "edges": [
        {
          "from": "U1", 
          "to": "U4",
          "amount": 30
        },
        {
          "from": "U1", 
          "to": "U2",
          "amount": 90.4
        },
        {
          "from": "U4", 
          "to": "U3",
          "amount": 22
        },
        {
          "from": "U2", 
          "to": "U3",
          "amount": 31.4
        }
    ]
  }
"""



netAsString = "U1, U4, 30; U1, U2, 90.4; U4, U3, 22; U2, U3, 31.4;"

---
--- Json.Decode Tests
---

nodeA = """
  {"name": "A" }
"""

nodeB = """
  {"name": "B"}
"""

edgeAB = """
  {
     "from": {"name": "A" }, 
     "to": {"name": "B" },
     "amount": 17.3
  }
"""

simpleEdgeAB = """
  {
     "from": "A", 
     "to": "B",
     "amount": 17.3
  }
"""

tinyNetAsJson = """
  { 
    "nodes": [
      {"name": "A" }, 
      {"name": "B" }
    ], 
    "edges": [
        {
          "from": "A", 
          "to": "B",
          "amount": 17.3
        }
    ]

  }
"""

graphData = """
  {"data":[
      {"value":"1 BES","to":"james1111111","symbol":"BES","memo":"","from":"lucca1111111","block_time":"2018-11-03T18:48:52.500"}
      ,{"value":"2 BES","to":"karla1111111","symbol":"BES","memo":"","from":"lucca1111111","block_time":"2018-11-05T19:57:06.000"}
      ,{"value":"10 BES","to":"karla1111111","symbol":"BES","memo":"","from":"lucca1111111","block_time":"2018-11-06T19:45:50.500"}
      ,{"value":"15 BES","to":"lucca1111111","symbol":"BES","memo":"","from":"lucca1111141","block_time":"2018-11-06T20:09:07.500"}
    ]
    }
"""


