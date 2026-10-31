# Journal de bord — SOC Lab

## Phase 0 — Préparation (22/10/2026)
- Hôte : HP ProBook 430 G8, Ubuntu 24.04.5, i5-1135G7 (4c/8t), 16 Go RAM, ~95 Go libres
- Hyperviseur : KVM + virt-manager (choisi plutôt que VirtualBox : Secure Boot activé, performances natives)
- Problème : libvirt inaccessible après ajout aux groupes → résolu par reconnexion de session
- ISO : Ubuntu Server 24.04.5 LTS (SHA256 vérifié), Windows 11 Enterprise Eval 26H2
- Choix Ubuntu 24.04 LTS (et non 26.10) : version supportée par Wazuh 4.14, support long terme

## Phase 1 — Infrastructure (22/10/2026)
- Réseau KVM isolé `soclab` (10.10.10.0/24, NAT) créé et versionné dans config/kvm/
- VM wazuh-srv : Ubuntu Server 24.04.5, 2 vCPU, 4 Go RAM, 50 Go, IP 10.10.10.10
- Problème : `ubuntu-lv` n'occupait que 24 Go sur 48 → corrigé avec `lvextend -r -l +100%FREE`
- Hostname corrigé de `wazuhsrv` en `wazuh-srv` (cohérence dans les logs)
- Snapshot `ubuntu-propre` pris avant l'installation de Wazuh
- Wazuh 4.14 installé en tout-en-un (indexer, manager, dashboard, filebeat) sur wazuh-srv, dashboard accessible sur https://10.10.10.10
- Dépôt apt Wazuh désactivé pour éviter une montée de version non maîtrisée
- Snapshot `phase1-wazuh-ok`
- VM win-pc01 : Windows 11 Enterprise Eval 26H2, 2 vCPU, 4 Go RAM, 60 Go, UEFI + TPM émulé, IP 10.10.10.20
- Problèmes : commande TPM invalide (`emulated` → `emulator`) ; règle ICMP : syntaxe netsh incompatible avec PowerShell → `New-NetFirewallRule`
- Comptes : lab.admin (administrateur), user.test (cible des scénarios)
- Snapshot `windows-propre`

## Phase 2 — Scénario 1, force brute (31/10/2026)
- Observation des règles natives : 60122 (échec, niveau 5), 60204 (échecs multiples, regroupement par IP), 60106 (succès, niveau 3)
- Règles personnalisées 100100 (5 échecs sur un compte en 120 s) et 100101 (succès après 100100 en 300 s) déployées dans /var/ossec/etc/rules/
- Problèmes : règle 100101 écrite avec `frequency="2"` par erreur, donc jamais déclenchée → supprimé ; commandes de déploiement lancées sur l'hôte au lieu de la VM (vérifier `hostname` avant)
- Tests : 1 positif et 2 négatifs pour 100101, 1 positif et 1 négatif pour 100100, tous OK
- Délais de détection : 27 s (100100), 1 min 45 (100101)

## Phase 2 — Scénario 2, PowerShell suspect (31/10/2026)
- Constat : les événements de création de processus arrivent du journal Sécurité (4688, règle native 67027, niveau 3), avec les champs `newProcessName`, `commandLine`, `parentProcessName`. Mes noms de champs prévus pour Sysmon (`image`, `parentImage`) ne correspondaient pas
- Règles 100200 (commande encodée, niveau 10) et 100201 (mode caché ou contournement de politique, niveau 8) écrites sur le 4688 et déployées
- Tests : 2 positifs et 2 négatifs, tous OK ; PowerShell lancé par cmd ne déclenche rien à lui seul
- Erreur de ma part : j'avais supposé que l'agent Windows collectait Sysmon par sa configuration locale. Vérification : ossec.conf ne contient pas Sysmon, donc le bloc dans agent.conf est nécessaire → restauré
- Limite : la ligne de commande n'est visible que si l'audit 4688 et l'option de ligne de commande sont actifs
