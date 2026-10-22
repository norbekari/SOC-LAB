# SOC Lab — Détection, investigation et réponse aux incidents

Mini-SOC construit en laboratoire isolé pour simuler des attaques contrôlées,
détecter les comportements suspects et documenter des investigations comme un analyste SOC N1/N2.

## Stack
- KVM / virt-manager (hôte Ubuntu 24.04)
- Wazuh (SIEM) · Sysmon · Windows Event Logs · Wireshark
- MITRE ATT&CK · GitHub

## Architecture (prévue)
| Machine | Rôle | IP |
|---|---|---|
| wazuh-srv | Serveur Wazuh | 10.10.10.10 |
| win-pc01 | Poste Windows surveillé | 10.10.10.20 |
| lnx-srv01 | Serveur Linux surveillé | 10.10.10.30 |

## Statut
🚧 En construction — phase 0 : préparation de l'environnement.

> Projet éducatif réalisé dans un laboratoire isolé. Toutes les simulations sont inoffensives.
