# Project 03: Hex Counter Golden Model
# Purpose: Generate the expected 7-segment patterns (Active Low)

print("--- Golden Model Output ---")
print("Count | Hex Code (seg) | Display")
print("-" * 35)

# Dictionary of expected Hex values (Active Low)
# 0 = ON, 1 = OFF
patterns = {
    0: "40", 1: "79", 2: "24", 3: "30",
    4: "19", 5: "12", 6: "02", 7: "78",
    8: "00", 9: "10", 10:"08", 11:"03",
    12:"46", 13:"21", 14:"06", 15:"0E"
}

for i in range(16):
    print(f"  {i:2}  |      {patterns[i]}      |   {i:X}")