# Investigation S3 : modification de config.ini dans un dossier sensible

**Statut** : clos (simulation) · **Analyste** : Nor Bekari · **Date** : 2026-11-01 · **Heures** : UTC

## 1. Triage
- Alerte : règle native 550 (niveau 7) à 13:43:57, remplacée depuis par 100300 (niveau 10)
- Système concerné : WIN-PC01, fichier `c:\soc-lab\sensible\config.ini`
- Exploitable ? Oui : un fichier de configuration d'un dossier sensible a changé

## 2. Preuves collectées
| Élément | Valeur |
|---|---|
| Événement | modifié (mode `whodata`) |
| Auteur | lab.admin |
| Processus | `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` (PID 9528) |
| Taille | 13 → 25 octets |
| Contenu ajouté (`diff`) | `admin=true` |
| SHA-256 avant | `beeed812cd2df637b97a23d9c196c0d8fc12c517938604bf6c7ae8aedc83df52` |
| SHA-256 après | `c50a8470c33f04c74656d7d0b795f1dfab4b8609d1126920d66e0c83e375e425` |
| Date de modification | 2026-11-01T13:43:56 |

## 3. Corrélation
Le fichier est passé de `admin=false` à `admin=true`, ce qui change une option de privilège. L'action est faite en PowerShell 64 bits par un compte administrateur interactif. Aucune autre alerte liée à ce moment : pas de connexion suspecte ni de commande encodée.

## 4. Qualification
**Activité suspecte nécessitant des vérifications** (ici : simulation connue de l'analyste).
- Pour : une option de type administrateur activée dans un fichier de configuration sensible
- Contre : compte administrateur interactif, processus PowerShell standard
- À vérifier en production : un ticket de changement correspond-il ? Quelle est l'application qui lit ce fichier ? Le compte a-t-il d'autres activités inhabituelles ?

## 5. Réponse recommandée
Contacter l'auteur, vérifier le ticket de changement. Sans justification : restaurer la version précédente (empreinte `beeed812…`), examiner l'activité du compte, vérifier les autres fichiers du dossier.

## 6. Retour d'expérience
- `whodata` fournit l'auteur et le processus : sans lui, on saurait que le fichier a changé, mais pas qui l'a fait
- Une règle FIM utilise le champ décodé `file` ; `syscheck.path` est le nom côté alerte, et l'utiliser dans une règle ne fonctionne pas (testé)
- `report_changes` stocke le contenu du fichier : à éviter pour tout fichier contenant un secret
- La détection ne couvre que les dossiers déclarés : un fichier créé hors zone passe inaperçu
- Amélioration : ajouter aux règles personnalisées les étiquettes de conformité des règles natives, pour garder le lien avec les référentiels
