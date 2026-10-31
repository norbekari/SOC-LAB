# Investigation S1 : série d'échecs puis connexion réussie sur user.test

**Statut** : clos (simulation) · **Analyste** : Nor Bekari · **Date** : 2026-10-31 · **Heures** : UTC
**Délai de détection** : 27 s (alerte 100100), 1 min 45 (alerte 100101) après le premier échec

## 1. Triage
- Alertes : 100100 (niveau 10, 14:22:07), puis 100101 (niveau 12, 14:23:25)
- Système concerné : WIN-PC01 (agent win-pc01)
- Exploitable ? Oui : une série d'échecs suivie d'un succès sur le même compte est atypique

## 2. Preuves collectées
| Heure (UTC) | Source / règle | Compte | IP source | Logon Type | Détail |
|---|---|---|---|---|---|
| 14:21:40 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | status 0xc000006d, sous-statut 0xc000006a |
| 14:21:47 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | idem |
| 14:21:53 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | idem |
| 14:21:59 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | idem |
| 14:22:07 | 4625 / **100100** | user.test | 127.0.0.1 | 3 | 5e échec : alerte niveau 10 |
| 14:22:19 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | idem |
| 14:22:52 | 4625 / 60122 | user.test | 127.0.0.1 | 3 | idem |
| 14:23:25 | 4624 / **100101** | user.test | 127.0.0.1 | 3 | succès : alerte niveau 12 |

Le sous-statut 0xc000006a désigne un mot de passe incorrect pour un compte **existant**.

## 3. Corrélation
Les sept échecs et le succès visent le même compte, dans une fenêtre de 105 s, avec le même type de connexion (réseau) et la même source. Les cinq premiers échecs sont espacés de 6 à 8 s, un rythme régulier typique d'un outil automatisé. Le 7e échec (14:22:52), isolé, est probablement un mot de passe mal saisi à l'invite (**à confirmer**).

## 4. Qualification
**Activité suspecte nécessitant des vérifications.**
- Pour : enchaînement échecs → succès sur un compte valide, cadence régulière
- Contre : un utilisateur qui retrouve son mot de passe produit le même schéma
- À vérifier : l'IP source est-elle habituelle pour ce compte ? Le type de connexion est-il attendu ? Que fait le compte après le succès ?
- Limite de la simulation : la source est 127.0.0.1, donc il n'y a pas d'IP externe à analyser. Vérité terrain : activité simulée par l'analyste

## 5. Réponse recommandée
1. Contacter l'utilisateur pour confirmer l'activité
2. Sans confirmation : réinitialiser le mot de passe, fermer les sessions ouvertes, bloquer l'IP source si elle est externe
3. Surveiller le compte pendant 24 h

## 6. Retour d'expérience
- La règle native 60204 n'a pas réagi (regroupement par IP, seuil plus élevé) : 100100 regroupe par compte
- Faiblesses du poste : seuil de verrouillage à 10 échecs, longueur minimale de mot de passe à 0
- Source simulée en local : refaire le test depuis lnx-srv01 pour obtenir une IP distante (phase 3)
- Bruit : de nombreuses alertes 60106 sur le compte `Système` (logonType 5) encombrent le dashboard, d'où une règle de réduction du bruit à écrire
- Horloge de la VM décalée après une pause : la synchronisation est indispensable pour une chronologie fiable
- Piste d'amélioration : détecter le password spraying (une IP, plusieurs comptes), angle mort de 100100
