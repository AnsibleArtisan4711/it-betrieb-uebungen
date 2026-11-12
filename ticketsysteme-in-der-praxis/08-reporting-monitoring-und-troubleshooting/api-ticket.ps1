# Beispiel, nicht ausgefuehrt, Felder nicht gegen die Ticket-Endpunkt-Dokumentation geprueft.
# Das Token wird interaktiv abgefragt und nie gespeichert.
$token = Read-Host "API-Token" -AsSecureString
$klar  = [System.Net.NetworkCredential]::new("", $token).Password
$body = @{
  title    = "Monitoring: Festplatte voll auf srv01"
  group    = "1st-Level-Support"
  customer = "schmidt@example.internal"
  article  = @{ subject = "Disk-Alarm"; body = "Fuellstand 91 %"; type = "note"; internal = $false }
} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Method Post -Uri "http://zammad.example.internal/api/v1/tickets" `
  -Headers @{ Authorization = "Token token=$klar" } -ContentType "application/json" -Body $body
