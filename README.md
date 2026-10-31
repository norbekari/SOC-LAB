# SOC Lab : détection, investigation et réponse aux incidents

Mini-SOC construit en laboratoire isolé : simulations d'attaques contrôlées, règles de détection personnalisées sous Wazuh, investigations documentées comme un analyste SOC N1/N2.

> Projet éducatif réalisé dans un laboratoire isolé. Toutes les simulations sont inoffensives et ne ciblent que les VM du labo.

## Architecture

    Hôte Ubuntu 24.04 (KVM / virt-manager), réseau virtuel isolé 10.10.10.0/24
      |- wazuh-srv  10.10.10.10  Wazuh 4.14 (manager, indexer, dashboard)
      |- win-pc01   10.10.10.20  Windows 11, Sysmon, agent Wazuh
      |- lnx-srv01  10.10.10.30  Ubuntu Server (prévu, scénarios 4 et 5)

## Stack
KVM, Wazuh, Sysmon (config SwiftOnSecurity), journaux Windows, MITRE ATT&CK, Git.

## Avancement
| Scénario | Statut | Règles | MITRE | Détail |
|---|---|---|---|---|
| 1. Force brute Windows | Terminé | 100100, 100101 | T1110.001, T1078 | detections/brute_force/ et investigations/s1_bruteforce_user_test.md |
| 2. PowerShell suspect | Terminé | 100200, 100201 | T1059.001, T1027 | detections/suspicious_powershell/ |
| Incident 002 : faux positifs | Terminé | 100210 (filtre) | T1546.011 (règle native 92058) | investigations/inc002_false_positives_92058.md et detections/tuning/ |
| 3. Intégrité des fichiers | En cours | | | |
| 4. Activité réseau | À venir | | | |
| 5. Linux / SSH | À venir | | | |
| 6. Incident complet | À venir | | | |

## Résultats
- **Scénario 1** : 2 règles personnalisées, 5 cas de test validés. La série d'échecs est détectée 27 s après le premier échec, la connexion réussie suivante 1 min 45 après. La règle native 60204 ne détecte pas la série (regroupement par IP) : 100100 regroupe par compte.
- **Scénario 2** : 2 règles personnalisées sur le journal Sécurité (événement 4688), 4 cas de test validés (2 positifs, 2 négatifs). Une commande PowerShell lancée par `cmd.exe` sans option suspecte ne déclenche rien, ce qui évite un bruit important.
- **Incident 002** : une alerte de niveau 12 (règle native 92058) et une rafale d'alertes PowerShell, toutes deux qualifiées de faux positifs avec preuves : parent `PcaSvc` pour la première, parent `wazuh-agent.exe` (scan de configuration SCA) pour la seconde. Un filtre documenté (100210) réduit le bruit sans masquer les exécutions suspectes.

## Structure du dépôt
- detections/ : règles XML et fiches de détection, filtres dans detections/tuning/
- simulations/ : scripts de simulation inoffensifs
- investigations/ : rapports d'incident
- tests/ : cas de test des détections
- dashboards/screenshots/ : preuves
- config/ : réseau KVM, Sysmon, Wazuh
- notes/journal.md : journal de bord, incidents compris

## Limites et pistes
- Les échecs de connexion du scénario 1 sont simulés en local (127.0.0.1) : à refaire depuis une VM distincte
- Les règles du scénario 1 regroupent par compte : le password spraying n'est pas couvert
- Les règles PowerShell s'appuient sur le journal 4688, qui dépend de l'audit activé sur le poste
