# Cas de test des détections

Environnement : WIN-PC01 (agent Wazuh), serveur wazuh-srv. Heures en UTC.

| ID test | Règle | Type | Action réalisée | Résultat attendu | Résultat obtenu | Date |
|---|---|---|---|---|---|---|
| T-100100-01 | 100100 | Positif | 6 échecs `net use` sur user.test | Alerte niveau 10 | OK : alerte à 14:22:07, au 5e échec | 2026-10-31 |
| T-100100-02 | 100100 | Négatif | 2 échecs seulement | Pas de 100100 | OK : deux 60122 (14:38:54, 14:39:01), aucune 100100 | 2026-10-31 |
| T-100101-01 | 100101 | Positif | Série d'échecs (100100) puis connexion réussie sur user.test | Alerte niveau 12 | OK : alerte à 14:23:25, 78 s après 100100 | 2026-10-31 |
| T-100101-02 | 100101 | Négatif | Connexion réussie isolée, plus de 10 min après les derniers échecs | 60106 seule | OK : 60106 à 14:34:41, pas de 100101 | 2026-10-31 |
| T-100101-03 | 100101 | Négatif | 2 échecs puis connexion réussie | Ni 100100 ni 100101 | OK : 60106 à 14:40:22 | 2026-10-31 |
| T-100200-01 | 100200 | Positif | `powershell -NoProfile -WindowStyle Hidden -EncodedCommand ...` | Alerte niveau 10 | OK : alerte 100200 (niveau 10) à 15:45:07 UTC | 2026-10-31 |
| T-100201-01 | 100201 | Positif | `powershell -ExecutionPolicy Bypass -Command ...` | Alerte niveau 8 | OK : alerte 100201 (niveau 8) à 15:45:07 UTC | 2026-10-31 |
| T-100200-02 | 100200 / 100201 | Négatif | `powershell -NoProfile -Command "Get-Date"` | Aucune alerte | OK : aucune nouvelle alerte 100200 ni 100201 | 2026-10-31 |
| T-100200-03 | 100200 / 100201 | Négatif | `cmd /c powershell -nop -c "Get-Process ..."` | Aucune alerte de ces règles | OK : seules les alertes 67027 (niveau 3) | 2026-10-31 |
| T-100210-01 | 100210 / 92058 | Négatif (filtre) | `sdbinst` lancé par PcaSvc | Pas d'alerte 92058 | En attente : prochain lancement de sdbinst par PcaSvc | 2026-10-31 |
| T-100210-02 | 92058 | Positif (conservé) | `sdbinst.exe -?` depuis un terminal PowerShell | Alerte 92058 niveau 12 | En attente : alerte 92058 à 19:54:54 UTC, parent à confirmer | 2026-10-31 |
