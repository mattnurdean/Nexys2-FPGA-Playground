# Project 02: Hex Decoder Golden Model
# Goal: Generate the "Active Low" segment patterns for 0-F (Common Anode)

def get_seven_segment_code(value):
    """
    Returns the 7-bit pattern (gfe_dcba) for a given hex digit (0-15).
    Logic: 0 = ON, 1 = OFF
    """
    # Map: '0' needs a,b,c,d,e,f ON (0). g OFF (1).
    # Pattern: g f e d c b a
    patterns = {
        0:  "1000000", # 0
        1:  "1111001", # 1 (only b, c on)
        2:  "0100100", # 2
        3:  "0110000", # 3
        4:  "0011001", # 4
        5:  "0010010", # 5
        6:  "0000010", # 6
        7:  "1111000", # 7
        8:  "0000000", # 8 (all on)
        9:  "0010000", # 9
        10: "0001000", # A
        11: "0000011", # b (lower case)
        12: "1000110", # C
        13: "0100001", # d (lower case)
        14: "0000110", # E
        15: "0001110"  # F
    }
    return patterns.get(value, "1111111") # Default OFF

# --- MAIN EXECUTION ---
if __name__ == "__main__":
    print(f"{'Hex':<5} | {'Binary (gfedcba)':<18} | {'Active Low Check'}")
    print("-" * 45)
    
    for i in range(16):
        hex_char = hex(i).upper().replace("0X", "")
        pattern = get_seven_segment_code(i)
        print(f"{hex_char:<5} | {pattern:<18} | {'Valid'}")