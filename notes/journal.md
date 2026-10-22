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
