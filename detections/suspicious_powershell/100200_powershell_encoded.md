# [100200] PowerShell avec commande encodée

| Élément | Contenu |
|---|---|
| Nom | Exécution de PowerShell avec `-EncodedCommand` |
| Objectif | Repérer une commande masquée en Base64, technique d'obfuscation courante |
| Sources de logs | Windows Security 4688 (création de processus avec ligne de commande), règle native 67027. Nécessite l'audit « Création du processus » et l'option « inclure la ligne de commande » |
| Logique | Processus `powershell.exe` ou `pwsh.exe` dont la ligne de commande contient `-e`, `-ec` ou `-en…` suivi d'un espace |
| Niveau | 10 |
| Faux positifs | Outils de déploiement et d'administration (SCCM, Intune, agents de supervision) qui passent leurs scripts encodés ; scripts d'installation |
| Tests | T-100200-01 (positif), T-100200-02 (négatif) : voir tests/detection_test_cases.md |
| MITRE ATT&CK | T1059.001 (PowerShell), T1027 (Obfuscated Files or Information) |
| Remédiation | Décoder la commande (`[Text.Encoding]::Unicode.GetString([Convert]::FromBase64String(...))`), examiner le processus parent et le compte, chercher les connexions réseau et les fichiers créés ensuite, isoler le poste si le contenu est malveillant |
| Limites | Les champs dépendent du journal 4688, qu'un attaquant administrateur peut désactiver. La règle ne voit pas le contenu du script, seulement la ligne de commande : l'événement 4104 serait nécessaire pour le lire. Une commande encodée lancée autrement que par `powershell.exe` échappe à la règle |

## Preuve
Capture : dashboards/screenshots/s2_alerte_100200.png
