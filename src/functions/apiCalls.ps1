function Get-Games {
    $response = Invoke-WebRequest -Uri 'https://api.opendota.com/api/players/183063377/counts' -Method GET
    return $response | ConvertFrom-Json
}
function Get-PlayerData {
    $response = Invoke-WebRequest -Uri 'https://api.stratz.com/api/v1/Player/183063377' -Method GET
    return $response | ConvertFrom-Json;
}

function Get-PlayerActivity {
    $response = Invoke-WebRequest -Uri 'https://api.stratz.com/api/v1/Player/183063377/behaviorChart' -Method GET
    return $response | ConvertFrom-Json
}

function Get-PlayerRankedActivity {
    $response = Invoke-WebRequest -Uri 'https://api.stratz.com/api/v1/Player/183063377/behaviorChart?lobbyType=7' -Method GET
    return $response | ConvertFrom-Json
}

function Get-Heros {
    $response = Invoke-WebRequest -Uri 'https://api.stratz.com/api/v1/Hero' -Method GET
    return $response | ConvertFrom-Json
}

function Get-AllTimeHeroPerformance {
    $response = Invoke-WebRequest -Uri 'https://api.opendota.com/api/players/183063377/heroes' -Method GET
    return $response | ConvertFrom-Json
}