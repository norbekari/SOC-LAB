
## Observations (2026-10-31)
- Alerte émise à 14:23:25, **78 s** après 100100 et 1 min 45 après le premier échec, avec logonType 3 (réseau) et IP source 127.0.0.1.
- Deux tests négatifs validés : un succès isolé et un succès après seulement 2 échecs ne déclenchent pas la règle (T-100101-02 et T-100101-03).
- Le bruit du compte `Système` (logonType 5, règle 60106 niveau 3) est ignoré, car la règle exige le même `targetUserName` que 100100.
