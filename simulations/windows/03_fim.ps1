<#
 Scenario   : 03 - Integrite des fichiers (FIM)
 Machine    : WIN-PC01, PowerShell administrateur
 Prerequis  : dossier C:\SOC-Lab\Sensible avec config.ini et notes.txt, bloc <syscheck> dans agent.conf, regles 100300 a 100302
 Effet      : cree, modifie puis supprime un fichier du dossier surveille ; test negatif hors dossier
 Attendu    : 100302, 100300, 100301 ; aucune alerte pour le fichier hors zone
 Nettoyage  : les fichiers de test sont supprimes par le script
 ATTENTION  : a executer uniquement dans le labo isole
#>
New-Item -ItemType Directory -Path C:\SOC-Lab\Sensible -Force | Out-Null
(Get-Date).ToUniversalTime().ToString('HH:mm:ss') + " creation"
Set-Content C:\SOC-Lab\Sensible\test5.txt "a"
Start-Sleep -Seconds 10
(Get-Date).ToUniversalTime().ToString('HH:mm:ss') + " modification"
Add-Content C:\SOC-Lab\Sensible\notes.txt "ligne ajoutee"
Start-Sleep -Seconds 10
(Get-Date).ToUniversalTime().ToString('HH:mm:ss') + " suppression"
Remove-Item C:\SOC-Lab\Sensible\test5.txt
# Test negatif : hors dossier surveille
Set-Content C:\SOC-Lab\hors_zone.txt "x"
Add-Content C:\SOC-Lab\hors_zone.txt "y"
Remove-Item C:\SOC-Lab\hors_zone.txt
