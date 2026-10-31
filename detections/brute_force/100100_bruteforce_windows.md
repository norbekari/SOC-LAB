# [100100] Série d'échecs d'authentification sur un compte Windows

| Élément | Contenu |
|---|---|
| Nom | Série d'échecs de connexion sur un même compte |
| Objectif | Repérer une tentative de deviner un mot de passe avant qu'elle n'aboutisse |
| Sources de logs | Windows Security, événement 4625, agent Wazuh sur win-pc01 |
| Logique | Règle parente 60122 (échec de connexion, niveau 5). Alerte si 5 échecs sur le même `targetUserName` en 120 s |
| Niveau | 10 |
| Faux positifs | Utilisateur qui a oublié son mot de passe ; service ou tâche planifiée avec un ancien mot de passe |
| Tests | T-100100-01 (positif), T-100100-02 (négatif) : voir tests/detection_test_cases.md |
| MITRE ATT&CK | T1110.001 (Password Guessing). Le mapping natif de 60122 (T1531, suppression d'accès à un compte) ne correspond pas à un simple échec de connexion |
| Remédiation | Vérifier si un succès suit (règle 100101), contacter l'utilisateur, réinitialiser le mot de passe, bloquer l'IP source si elle est externe |
| Limites | Regroupe par compte et non par IP : ne détecte pas le password spraying (un mot de passe testé sur de nombreux comptes). Une attaque lente sous le seuil de 5 en 120 s échappe à la règle |

## Observations
- L'alerte est émise au **5e échec** : on observe 4 alertes 60122, puis 100100 (14:22:07, soit 27 s après le premier échec).
- La règle native 60204 (« Multiple Windows Logon Failures ») regroupe par adresse IP source avec un seuil plus élevé : elle n'a pas réagi à la série. 100100 la complète.

## Remarque de configuration
Politique du poste de test : seuil de verrouillage à 10 échecs, longueur minimale de mot de passe à 0. À durcir.

## Preuve
Capture : dashboards/screenshots/s1_alerte_100100.png
