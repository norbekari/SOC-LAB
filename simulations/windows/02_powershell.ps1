<#
 Scenario   : 02 - PowerShell suspect
 Machine    : WIN-PC01, PowerShell administrateur
 Prerequis  : audit "Creation du processus" + ligne de commande activee, agent Wazuh actif, regles 100200 et 100201 deployees
 Effet      : commandes inoffensives (affichage de texte uniquement)
 Attendu    : a -> 100200 ; b -> 100201 ; c et d -> aucune de ces deux regles
 Nettoyage  : aucun
 ATTENTION  : a executer uniquement dans le labo isole
#>
# a : commande encodee, fenetre cachee
$cmd = "Write-Output 'SOC-Lab test encode'"
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
powershell.exe -NoProfile -WindowStyle Hidden -EncodedCommand $enc

# b : politique d'execution contournee
powershell.exe -ExecutionPolicy Bypass -Command "Write-Output 'SOC-Lab test bypass'"

# c : chaine cmd -> powershell, sans option suspecte
cmd.exe /c powershell -nop -c "Get-Process | Select-Object -First 3"

# d : administration legitime
Get-Service | Where-Object Status -eq 'Running' | Select-Object -First 3
