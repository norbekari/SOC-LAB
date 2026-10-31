<#
 Scenario   : 01b - Tests negatifs des regles 100100 et 100101
 Machine    : WIN-PC01, PowerShell administrateur
 Test A     : connexion reussie isolee (attendre au moins 6 min apres le dernier echec) -> 60106 seule
 Test B     : 2 echecs puis un succes -> ni 100100 ni 100101
 ATTENTION  : le mot de passe de user.test est saisi a l'invite. Labo isole uniquement.
#>
# Test A
net use \\127.0.0.1\IPC$ /user:user.test *
net use \\127.0.0.1\IPC$ /delete

# Test B (apres une nouvelle pause de 6 minutes)
1..2 | ForEach-Object { net use \\127.0.0.1\IPC$ /user:user.test "MauvaisMdp$_" ; Start-Sleep -Seconds 2 }
net use \\127.0.0.1\IPC$ /user:user.test *
net use \\127.0.0.1\IPC$ /delete
