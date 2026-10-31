# SOC Lab : détection, investigation et réponse aux incidents

Mini-SOC construit en laboratoire isolé : simulations d'attaques contrôlées, règles de détection personnalisées sous Wazuh, investigations documentées comme un analyste SOC N1/N2.

> Projet éducatif réalisé dans un laboratoire isolé. Toutes les simulations sont inoffensives et ne ciblent que les VM du labo.

## Architecture

    Hôte Ubuntu 24.04 (KVM / virt-manager), réseau virtuel isolé 10.10.10.0/24
      |- wazuh-srv  10.10.10.10  Wazuh 4.14 (manager, indexer, dashboard)
      |- win-pc01   10.10.10.20  Windows 11, Sysmon, agent Wazuh
      |- lnx-srv01  10.10.10.30  Ubuntu Server (prévu, phase 3)

## Stack
KVM, Wazuh, Sysmon (config SwiftOnSecurity), journaux Windows, MITRE ATT&CK, Git.

## Avancement
| Scénario | Statut | Règles | MITRE | Détail |
|---|---|---|---|---|
| 1. Force brute Windows | Terminé | 100100, 100101 | T1110.001, T1078 | detections/brute_force/ et investigations/s1_bruteforce_user_test.md |
| 2. PowerShell suspect | À venir | | | |
| 3. Intégrité des fichiers | À venir | | | |
| 4. Activité réseau | À venir | | | |
| 5. Linux / SSH | À venir | | | |
| 6. Incident complet | À venir | | | |

## Résultats du scénario 1
- 2 règles personnalisées, 5 cas de test (2 positifs, 3 négatifs), tous validés
- Détection de la série d'échecs 27 s après le premier échec, du succès suivant 1 min 45 après
- La règle native 60204 n'a pas détecté la série (regroupement par IP) : 100100 regroupe par compte

## Structure du dépôt
- detections/ : règles XML et fiches de détection
- simulations/ : scripts de simulation inoffensifs
- investigations/ : rapports d'incident
- tests/ : cas de test des détections
- dashboards/screenshots/ : preuves
- config/ : réseau KVM, Sysmon, Wazuh
- notes/journal.md : journal de bord, incidents compris

## Limites et pistes
- Source des échecs simulée en local (127.0.0.1) : à refaire depuis une VM distincte
- Les règles regroupent par compte : le password spraying n'est pas couvert
