# INC-002 : alerte de niveau 12 (92058) et rafale PowerShell, deux faux positifs

**Statut** : clos, avec deux points non vérifiés (voir section 4) · **Analyste** : Nor Bekari · **Date** : 2026-10-31 · **Heures** : UTC

## 1. Triage
- Alerte 92058 « Application Compatibility Database launched » (niveau 12, MITRE T1546.011 : persistance par shim de compatibilité), vue à 16:47, 17:47, 19:31 et 19:54
- Rafale d'alertes 92021, 92031, 92066 (niveaux 3 à 4) et 92205 (niveau 9) entre 15:52:40 et 15:52:50
- Système concerné : WIN-PC01. Exploitable ? Oui : un niveau 12 impose une vérification

## 2. Preuves collectées
| Heure (UTC) | Règle | Processus | Parent | Compte |
|---|---|---|---|---|
| 16:47:11, 17:47:12, 19:31:26 | 92058 | sdbinst.exe | `svchost.exe -k LocalSystemNetworkRestricted -p -s PcaSvc` | n/a |
| 15:52:04 (Sysmon, événement 1) | 92066 | SecEdit.exe, via PowerShell 32 bits (SysWOW64) | **`C:\Program Files (x86)\ossec-agent\wazuh-agent.exe`** | AUTORITE NT\Système |
| 15:52:43 et 15:52:46 | 92066 | SecEdit.exe | PowerShell : `secedit /export /cfg $env:TEMP\secpol.cfg; ... "LockoutBadCount"` puis `"ResetLockoutCount"` ; `Remove-Item` | AUTORITE NT\Système |
| 15:52:44, 15:52:47, 15:52:50 | 92205 | powershell.exe (SysWOW64) | n/a | AUTORITE NT\Système, fichiers `C:\Windows\SystemTemp\__PSScriptPolicyTest_*.ps1` |

La commande exécutée est identique à celle de la politique SCA `cis_win11_enterprise.yml` de Wazuh (`grep` sur `/var/ossec/ruleset/sca/`).

## 3. Corrélation
- 92058 : les trois alertes ont le même parent, le service Windows PcaSvc (Assistant de compatibilité des programmes)
- Rafale : 18 événements de processus contenant `secedit` entre 15:52:04 et 15:52:44, tous sous le compte SYSTEM. Le premier a pour parent `wazuh-agent.exe`. Les alertes 92021 (suppression de fichiers) correspondent au `Remove-Item` de la commande SCA

## 4. Qualification
**Faux positifs.**
- 92058 : démontré par le parent (service PcaSvc, chemin System32). La règle native ne contrôle que le nom du fichier, jamais le parent
- Rafale : **démontré** par le parent `wazuh-agent.exe`, le compte SYSTEM et la commande identique à la politique SCA CIS de Wazuh
- Non vérifié : (a) la date exacte du redémarrage de l'agent par rapport à la rafale (la requête sur le journal Système n'a rien renvoyé) ; (b) l'origine de l'alerte 92058 de 19:54, dont les champs de parent sont vides dans l'alerte

## 5. Réponse
Aucun confinement. Règle de réduction du bruit 100210 (niveau 0) : ignore 92058 quand le parent est PcaSvc. Une exécution de `sdbinst.exe` par un autre parent continue d'alerter. Pour la rafale : aucune exclusion pour l'instant ; un PowerShell sous SYSTEM est aussi une piste d'attaque, donc toute exclusion devra porter sur le parent `wazuh-agent.exe` et non sur le nom du processus

## 6. Retour d'expérience
- Un niveau 12 ne signifie pas incident : le parent a tranché
- Les règles natives 92xxx sont bruyantes sur un poste surveillé : l'agent de supervision déclenche des alertes sur lui-même
- J'avais d'abord avancé une périodicité horaire pour 92058 : les horodatages la contredisent, preuve qu'une hypothèse doit être vérifiée sur les données
- Amélioration : mesurer le bruit des règles 92xxx et documenter chaque exclusion avec sa preuve
