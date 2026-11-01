# [100300 / 100301 / 100302] Intégrité du dossier sensible C:\SOC-Lab\Sensible

## Éléments communs
| Élément | Contenu |
|---|---|
| Objectif | Détecter toute création, modification ou suppression de fichier dans un dossier sensible, et savoir qui l'a faite |
| Sources de logs | Module FIM (syscheck) de l'agent Wazuh, configuré dans agent.conf avec `realtime`, `report_changes` et `whodata` |
| Logique | Règles natives 550 (modifié), 553 (supprimé), 554 (ajouté), restreintes par le champ décodé `file` au dossier sensible |
| Faux positifs | Modifications légitimes par un administrateur ou un outil de déploiement, sauvegardes, antivirus qui touche aux fichiers |
| Remédiation | Identifier l'auteur et le processus (champs `audit`), comparer à un ticket de changement, examiner le `diff` et les empreintes avant/après, restaurer le fichier si le changement n'est pas autorisé, examiner l'activité du compte |
| Limites | Seuls les dossiers déclarés dans la configuration sont surveillés (un fichier créé hors zone ne génère rien, test négatif validé). `report_changes` conserve le contenu des fichiers texte : à réserver aux fichiers sans secret. L'auteur (`whodata`) dépend de l'audit Windows : en cas d'échec, l'agent bascule en `realtime` sans auteur. Un attaquant administrateur peut arrêter l'agent |

## Par règle
| Règle | Niveau | Événement | MITRE ATT&CK | Test |
|---|---|---|---|---|
| 100302 | 7 | Fichier créé | aucun (une création n'est pas en soi une technique) | T-100302-01 |
| 100300 | 10 | Fichier modifié | T1565.001 (Stored Data Manipulation), mapping hérité de la règle native 550 | T-100300-01, T-100300-02 |
| 100301 | 10 | Fichier supprimé | T1485 (Data Destruction). La règle native 553 cite aussi T1070.004 (suppression de fichiers) : le choix dépend du contexte, à justifier à chaque incident | T-100301-01 |

## Observations
- Délai de détection : environ 2 secondes au plus entre l'action et l'alerte (13:43:07 → 13:43:08.993, 13:43:56 → 13:43:57.737, 13:46:28 → 13:46:29.838, pour les règles natives).
- Alertes 100300 à 100302 : 14:26:33, 14:26:44 et 14:26:54 UTC, auteur lab.admin.
- Contenu conservé de la modification de `config.ini` : ligne ajoutée `admin=true`, taille 13 → 25 octets.
- Les règles natives portent des étiquettes de conformité (PCI DSS 11.5, NIST 800-53 SI-7, HIPAA, GDPR) : c'est le mapping de Wazuh, pas le résultat d'un audit.

## Note technique
Dans une règle, le champ décodé s'appelle `file` ; l'alerte l'affiche sous `syscheck.path`. Utiliser `syscheck.path` dans une règle ne fonctionne pas (testé : aucune alerte).

## Preuves
dashboards/screenshots/s3_fim_modification.png et s3_alertes_100300_100302.png
