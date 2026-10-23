# [100100] Série d'échecs d'authentification sur un compte Windows

| Élément | Contenu |
|---|---|
| Nom | Série d'échecs de connexion sur un même compte |
| Objectif | Repérer une tentative de deviner un mot de passe avant qu'elle n'aboutisse |
| Sources de logs | Windows Security, événement 4625, agent Wazuh sur win-pc01 |
| Logique | Règle parente 60122 (échec de connexion, niveau 5). Alerte si 5 échecs sur le même `targetUserName` en 120 s |
| Niveau | 10 |
| Faux positifs | Utilisateur qui a oublié son mot de passe ; service ou tâche planifiée avec un ancien mot de passe |
| Test | T-100100-01 : 6 échecs `net use` sur user.test, alerte 100100 observée dans Wazuh |
| MITRE ATT&CK | T1110.001 (Password Guessing). Le mapping natif de 60122 (T1531) n'est pas adapté : il désigne la suppression d'accès à un compte |
| Remédiation | Vérifier si un succès suit (règle 100101), contacter l'utilisateur, réinitialiser le mot de passe, bloquer l'IP source si elle est externe |
| Limites | Regroupe par compte, pas par IP : ne détecte pas le password spraying (un mot de passe testé sur de nombreux comptes). Une attaque lente sous le seuil échappe aussi à la règle |

## Comparaison avec la règle native
La règle 60204 regroupe par adresse IP source et se déclenche à partir d'un seuil plus élevé ; elle n'a pas réagi à 6 échecs sur un seul compte. 100100 complète ce dispositif.

## Remarque de configuration
Politique du poste de test : seuil de verrouillage à 10 échecs, longueur minimale de mot de passe à 0. À durcir.
