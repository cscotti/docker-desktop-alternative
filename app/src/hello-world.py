import pyjq
import json

print("Hello World")

f = open("/data/test.json", "r")
data = json.load(f)
print(json.dumps(data,indent=4,sort_keys=False))
#return the first records with jq command
print(pyjq.first('.Actors[] | {"name": .name, "age":.age}', data))
