import re
import xml.etree.ElementTree as ET

# Parse SVG
svg_tree = ET.parse("c:/Users/hp/Downloads/Tamil Nadu.svg")
svg_root = svg_tree.getroot()
svg_paths = svg_root.findall('.//{http://www.w3.org/2000/svg}path') or svg_root.findall('.//path')

# We have the bipartite matches from the previous script
# Let's hardcode the matches index to district name mapping
matched_districts = {
    0: 'Tiruvallur',
    1: 'Chennai',
    2: 'Krishnagiri',
    3: 'Tiruvannamalai',
    4: 'Dharmapuri',
    5: 'Salem',
    6: 'Erode',
    7: 'Nilgiris',
    8: 'Namakkal',
    9: 'Perambalur',
    10: 'Coimbatore',
    11: 'Tiruchirappalli',
    12: 'Ariyalur',
    13: 'Tiruppur',
    14: 'Thanjavur',
    15: 'Karur',
    16: 'Tiruvarur',
    17: 'Dindigul',
    18: 'Madurai',
    19: 'Theni',
    20: 'Virudhunagar',
    21: 'Thoothukudi',
    22: 'Kanyakumari',
    23: 'Viluppuram',
    24: 'Cuddalore',
    25: 'Pudukkottai',
    26: 'Sivaganga',
    27: 'Ramanathapuram',
    28: 'Nagapattinam',
    29: 'Kallakurichi',
    30: 'Tenkasi',
    31: 'Tirunelveli',
    32: 'Vellore',
    33: 'Ranipet',
    34: 'Tirupathur',
    35: 'Kanchipuram',
    36: 'Chengalpattu'
}

# Coordinate translation parameters
# Fx = (Tx - 10.9) * 1.08 + 5.0
# Fy = (278.1 - Ty) * 1.08 + 5.0
scale = 1.05
margin = 5.0

print("Generating Dart code...")
dart_output = []

for idx, path in enumerate(svg_paths):
    d = path.attrib.get('d', '')
    district_name = matched_districts[idx]
    
    # Parse path commands
    # Split on letters M, L, Z, z
    tokens = re.split(r'([MLZz])', d)
    
    dart_commands = []
    current_cmd = ''
    
    for token in tokens:
        token = token.strip()
        if not token:
            continue
        if token in ['M', 'L', 'Z', 'z']:
            current_cmd = token
            if current_cmd in ['Z', 'z']:
                dart_commands.append("..close()")
            continue
            
        # Parse coordinates
        coords = [float(x) for x in re.split(r'[,\s]+', token) if x.strip()]
        for i in range(0, len(coords), 2):
            tx, ty = coords[i], coords[i+1]
            fx = round((tx - 10.9) * scale + margin, 1)
            fy = round((278.1 - ty) * scale + margin, 1)
            
            if current_cmd == 'M':
                dart_commands.append(f"paths['{district_name}'] = Path()..moveTo({fx}, {fy})")
            elif current_cmd == 'L':
                dart_commands.append(f"..lineTo({fx}, {fy})")
                
    dart_output.append("".join(dart_commands) + ";")

# Write output to file
with open("d:/Helper/tn_party_connect/svg_paths.txt", "w") as out:
    for line in dart_output:
        out.write(line + "\n")

print(f"Generated {len(dart_output)} Dart Path code lines in D:/Helper/tn_party_connect/svg_paths.txt")
