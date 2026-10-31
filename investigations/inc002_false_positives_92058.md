# INC-002 : alerte de niveau 12 (92058) et rafale PowerShell, deux faux positifs

**Statut** : clos · **Analyste** : Nor Bekari · **Date** : 2026-10-31 · **Heures** : UTC

## 1. Triage
- Alerte 92058 « Application Compatibility Database launched » (niveau 12, MITRE T1546.011 : persistance par shim de compatibilité), vue à 16:47, 17:47 et 19:31
- Rafale d'alertes 92021, 92031, 92066 (niveaux 3 à 4) et 92205 (niveau 9) entre 15:52:40 et 15:52:50
- Système concerné : WIN-PC01. Exploitable ? Oui : le niveau 12 impose une vérification

## 2. Preuves collectées
| Heure (UTC) | Règle | Processus | Parent / ligne de commande parent |
|---|---|---|---|
| 16:47:11, 17:47:12, 19:31:26 | 92058 | sdbinst.exe | svchost.exe -k LocalSystemNetworkRestricted -p -s PcaSvc |
| 15:52:43 et 15:52:46 | 92066 | SecEdit.exe | powershell (SysWOW64) : `secedit /export /cfg $env:TEMP\secpol.cfg; ... Select-String "LockoutBadCount"` puis `"ResetLockoutCount"` ; `Remove-Item` |
| 15:52:44, 15:52:47, 15:52:50 | 92205 | powershell.exe (SysWOW64) | fichiers `C:\Windows\SystemTemp\__PSScriptPolicyTest_*.ps1` |

## 3. Corrélation
- 92058 : apparition périodique, toujours avec le même parent (service PcaSvc, Assistant de compatibilité des programmes)
- Rafale : 12 à 22 s après le redémarrage de l'agent Wazuh (15:52:28), avec un PowerShell 32 bits comme l'agent, et des contrôles de politique de verrouillage de compte

## 4. Qualification
**Faux positifs.**
- 92058 : démontré par le parent (service Windows PcaSvc), le chemin System32 et la périodicité. La règle native ne contrôle que le nom du fichier, jamais le parent
- Rafale : hypothèse d'un scan de configuration (SCA) de l'agent. **Vérification** : À COMPLÉTER (journal `modulesd:sca`, parent du processus PowerShell dans Sysmon)
- 92205 : les fichiers `__PSScriptPolicyTest_*.ps1` sont créés par PowerShell lui-même ; ce sont des scripts et non des exécutables, la règle est trop large

## 5. Réponse
Aucun confinement. Règle de réduction du bruit 100210 (niveau 0) : ignore 92058 quand le parent est PcaSvc. Une exécution de `sdbinst.exe` par un autre parent continue d'alerter (test : `sdbinst -?` depuis un terminal).

## 6. Retour d'expérience
- Un niveau 12 ne signifie pas incident : vérifier le parent avant toute conclusion
- Une alerte sur un événement lié à l'agent de supervision lui-même est un faux positif classique
- Ne pas exclure la rafale PowerShell : un parent PowerShell reste une piste d'attaque, il faut d'abord confirmer l'origine
- Amélioration : mesurer le bruit généré par les règles natives 92xxx et décider quelles exclusions documenter
