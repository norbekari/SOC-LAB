# Journal de bord — SOC Lab

## Phase 0 — Préparation (22/10/2026)
- Hôte : HP ProBook 430 G8, Ubuntu 24.04.5, i5-1135G7 (4c/8t), 16 Go RAM, ~95 Go libres
- Hyperviseur : KVM + virt-manager (choisi plutôt que VirtualBox : Secure Boot activé, performances natives)
- Problème : libvirt inaccessible après ajout aux groupes → résolu par reconnexion de session
- ISO : Ubuntu Server 24.04.5 LTS (SHA256 vérifié), Windows 11 Enterprise Eval 26H2
- Choix Ubuntu 24.04 LTS (et non 26.10) : version supportée par Wazuh 4.14, support long terme
