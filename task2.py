import sys
import json
from collections import defaultdict

with open(sys.argv[1], "r") as file:
    lines = file.readlines()
    data = defaultdict(dict)
    data["testName"] = lines[0].split(' ]')[0][2:]
    
    success = 0
        
    data["tests"] = []
    for line in lines[2:-2]:
        current = {}
        current["name"] = ",".join(line.split(",")[:-1]).split("  ")[2]
        current["status"] = line.split()[0] != "not"
        current["duration"] = line.split(",")[-1].strip()
        data["tests"].append(current)
        
        success += current["status"]
    
    data["summary"]["success"] = success
    data["summary"]["failed"] = len(lines)-4-success
    data["summary"]["rating"] = float(lines[-1].split("%")[0].split(" ")[-1])
    data["summary"]["duration"] = lines[-1].split(" ")[-1]
        
    with open("./output.json", "w") as write_file:
        json.dump(data, write_file, indent=1)

"""
[ Asserts Samples ], 1..2 tests
-----------------------------------------------------------------------------------
not ok  1  expecting command finishes successfully (bash way), 7ms
ok  2  expecting command prints some message (the same as above, bats way), 10ms
-----------------------------------------------------------------------------------
1 (of 2) tests passed, 1 tests failed, rated as 50%, spent 17ms
"""