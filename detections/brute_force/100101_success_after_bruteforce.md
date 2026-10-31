# [100101] Connexion réussie après une série d'échecs

| Élément | Contenu |
|---|---|
| Nom | Authentification réussie sur un compte venant de subir une série d'échecs |
| Objectif | Distinguer une tentative ratée d'une tentative qui a abouti : c'est le moment où la menace devient probable |
| Sources de logs | Windows Security 4624 (règle native 60106) corrélé à l'alerte 100100 |
| Logique | Un succès (60106) sur le même `targetUserName` dans les 300 s qui suivent une alerte 100100 |
| Niveau | 12 |
| Faux positifs | Utilisateur qui retrouve son mot de passe après plusieurs essais ; script qui réessaie avec un nouveau mot de passe |
| Tests | T-100101-01 (positif), T-100101-02 et T-100101-03 (négatifs) : voir tests/detection_test_cases.md |
| MITRE ATT&CK | T1110.001 (Password Guessing) et T1078 (Valid Accounts) |
| Remédiation | Vérifier l'IP source et le type de connexion, examiner l'activité du compte après le succès, réinitialiser le mot de passe, fermer les sessions ouvertes, isoler le poste si une activité suspecte suit |
| Limites | Dépend de 100100, donc hérite de ses limites (pas de détection du password spraying). La fenêtre de 5 minutes laisse passer un succès tardif. Ne dit rien de ce qui se passe après la connexion |

## Observations (2026-10-31)
- Alerte émise à 14:23:25, **78 s** après 100100 et 1 min 45 après le premier échec, avec logonType 3 (réseau) et IP source 127.0.0.1.
- Deux tests négatifs validés : un succès isolé et un succès après seulement 2 échecs ne déclenchent pas la règle (T-100101-02 et T-100101-03).
- Le bruit du compte `Système` (logonType 5, règle 60106 niveau 3) est ignoré, car la règle exige le même `targetUserName` que 100100.

## Preuve
Capture : dashboards/screenshots/s1_alerte_100101.png
