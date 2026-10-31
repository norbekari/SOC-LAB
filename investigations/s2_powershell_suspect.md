# Investigation S2 : PowerShell lancé avec options suspectes

**Statut** : clos (simulation) · **Analyste** : Nor Bekari · **Date** : 2026-10-31 · **Heures** : UTC

## 1. Triage
- Alertes : 100200 (niveau 10) et 100201 (niveau 8), toutes deux à 15:45:07
- Système concerné : WIN-PC01 (agent win-pc01)
- Exploitable ? Oui : une commande encodée en mode caché est suffisante pour ouvrir une investigation

## 2. Preuves collectées
| Heure (UTC) | Règle | Source | Compte | Processus (parent) | Ligne de commande |
|---|---|---|---|---|---|
| 15:45:07.686 | 100200 | Security 4688 / 67027 | lab.admin | powershell.exe (powershell.exe) | `-NoProfile -WindowStyle Hidden -EncodedCommand VwByAGkAdABl…` |
| 15:45:07.712 | 100201 | Security 4688 / 67027 | lab.admin | powershell.exe (powershell.exe) | `-ExecutionPolicy Bypass -Command "Write-Output 'SOC-Lab test bypass'"` |

Contenu décodé de la commande encodée : `Write-Output 'SOC-Lab test encode'`, un simple affichage de texte.

## 3. Corrélation
Les deux événements viennent du même compte, du même poste, à 26 ms d'écart. Ils forment une séquence de tests. Aucune connexion réseau ni modification de fichier n'a été observée à ce moment dans ce labo.

## 4. Qualification
**Activité suspecte nécessitant des vérifications** (ici : simulation connue de l'analyste).
- Pour : combinaison d'options typiques de l'obfuscation (commande encodée, fenêtre cachée, contournement de la politique d'exécution)
- Contre : un compte administrateur interactif, un parent PowerShell, un contenu décodé anodin
- À vérifier en production : l'origine du script, un ticket de changement, la fréquence, ce que l'hôte fait ensuite (réseau, fichiers, nouveaux comptes)
- Comparaison légitime : `powershell -NoProfile -Command "Get-Date"` et un `Get-Service` n'ont déclenché aucune alerte

## 5. Réponse recommandée
Décoder la commande, identifier son initiateur, vérifier s'il existe une demande de changement, élargir la recherche aux autres postes. Si la commande est malveillante : isoler le poste, réinitialiser le compte, rechercher la persistance.

## 6. Retour d'expérience
- Les événements viennent du journal Sécurité (4688), pas de Sysmon : mes noms de champs prévus pour Sysmon étaient faux, et la vérification sur les données réelles les a corrigés
- Une seule alerte par événement : le test encodé + caché n'a produit que 100200, pas 100201
- Le parent est `powershell.exe` parce que le test est lancé depuis un terminal : la simulation ne reproduit pas une chaîne réaliste (Office, script, navigateur)
- `cmd /c powershell -nop …` ne déclenche rien : une règle sur la chaîne cmd → powershell serait très bruyante
- L'événement 4688 dépend de l'audit et de l'option de ligne de commande, que les systèmes de production n'activent pas toujours
- Amélioration : exploiter Sysmon (hashes, parent complet) et l'événement 4104 (contenu des scripts) pour lire ce que la commande exécute réellement
