# [100201] PowerShell en fenêtre cachée ou avec contournement de politique

| Élément | Contenu |
|---|---|
| Nom | PowerShell lancé avec `-WindowStyle Hidden` ou `-ExecutionPolicy Bypass` |
| Objectif | Repérer des options souvent utilisées pour masquer l'exécution ou contourner la restriction des scripts |
| Sources de logs | Windows Security 4688 (règle native 67027) |
| Logique | Processus `powershell.exe` ou `pwsh.exe` dont la ligne de commande contient `-w… hidden` ou `-ep` / `-ex…` suivi de `bypass` |
| Niveau | 8 |
| Faux positifs | Scripts d'installation et d'administration, nombreux outils légitimes qui utilisent `-ExecutionPolicy Bypass`. Niveau volontairement plus bas que 100200 |
| Tests | T-100201-01 (positif), T-100200-02 (négatif) : voir tests/detection_test_cases.md |
| MITRE ATT&CK | T1059.001 (PowerShell). Le contournement de la politique d'exécution n'est pas une protection de sécurité, donc je n'ai pas ajouté de technique d'évasion |
| Remédiation | Vérifier le processus parent, le compte, la fréquence ; comparer à une liste blanche d'outils approuvés ; investiguer si l'option est combinée à une commande encodée |
| Limites | Mêmes limites que 100200. Très bruyante dans un parc réel : à coupler à une liste blanche par parent ou par compte de service |

## Preuve
Capture : dashboards/screenshots/s2_alerte_100201.png

## Observations (2026-10-31)
- Test b : alerte 100201 à 15:45:07.712 UTC, ligne de commande `-ExecutionPolicy Bypass -Command ...`.
- Le test a contient aussi `-WindowStyle Hidden` mais n'a produit qu'une alerte 100200 : une seule règle déclenche l'alerte d'un événement.
