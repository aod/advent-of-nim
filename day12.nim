import std/[json, strutils]
import ./core

func sumAllNumbers(node: JsonNode): int =
  case node.kind:
  of JArray:
    for item in node.items:
      result += item.sumAllNumbers
  of JObject:
    when IsPart2:
      for _, val in node.pairs:
        if val.getStr == "red":
          return
    for _, obj in node.pairs:
      result += obj.sumAllNumbers
  of Jint:
    result = node.getInt
  else:
    discard

when isMainModule:
  echo "Part ", Part, ": ", stdin.readAll.strip.parseJson.sumAllNumbers

  static:
    when IsPart1:
      assert """[1,2,3]""".parseJson.sumAllNumbers == 6
      assert """{"a":2,"b":4}""".parseJson.sumAllNumbers == 6
      assert """[[[3]]]""".parseJson.sumAllNumbers == 3
      assert """{"a":{"b":4},"c":-1}""".parseJson.sumAllNumbers == 3
      assert """{"a":[-1,1]}""".parseJson.sumAllNumbers == 0
      assert """[-1,{"a":1}]""".parseJson.sumAllNumbers == 0
      assert "[]".parseJson.sumAllNumbers == 0
      assert "{}".parseJson.sumAllNumbers == 0
    else:
      assert """[1,2,3]""".parseJson.sumAllNumbers == 6
      assert """[1,{"c":"red","b":2},3]""".parseJson.sumAllNumbers == 4
      assert """[1,"red",5]""".parseJson.sumAllNumbers == 6
      assert """{"d":"red","e":[1,2,3,4],"f":5}""".parseJson.sumAllNumbers == 0
