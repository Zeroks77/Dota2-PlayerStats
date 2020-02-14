function Get-Games {
    $response = Invoke-WebRequest -Uri 'https://api.opendota.com/api/players/183063377/counts' -Method GET
    return $response | ConvertFrom-Json
}
function Get-PlayerData {
        $response = Invoke-WebRequest -Uri 'https://api.stratz.com/api/v1/Player/183063377' -Method GET
        return $response | ConvertFrom-Json;
}
function Get-Player {
    [Player] $Player = [Player]::new();
    $templateText = (Get-Content ".\template\template.md" -Raw);
	$placeholderForQuote = (New-Guid).Guid;
    $templateText = $templateText.Replace('"', $placeholderForQuote);
    $templateText = Invoke-Expression """$templateText""";
    $templateText = $templateText.Replace($placeholderForQuote, '"');
    Out-File -Force -FilePath ".\Readme.md" -InputObject $templateText;
}

class Player {
    [string] $Name;
    [string] $SupportBadge;
    [string] $CoreBadge;
    [Int] $TotalGames;
    [Int] $TotalRankedGames;
    [Int] $TotalUnrankedGames;
    [Int] $TotalWins;
    [Int] $TotalLose
    [Double] $TotalWinRate;
    [Int] $RankedWins;
    [Int] $RankedLose
    [Double] $RankedWinRate;
    [Int] $UnrankedWins;
    [Int] $UnrankedLose;
    [Double] $UnrankedWinRate;

    Player() {
        . ".\src\functions\badge.ps1";
        $metaData = Get-PlayerData;
        $this.Name = $metaData.steamAccount.name;
        $this.CoreBadge = Get-RankBadge -Rank $metaData.steamAccount.seasonRankCore;
        $this.SupportBadge = Get-RankBadge -Rank $metaData.steamAccount.seasonRankSupport;
        $this.TotalGames = $metaData.matchCount;
        $this.TotalWins = $metaData.winCount;
        $this.TotalLose = $this.TotalGames - $this.TotalWins;
        $this.TotalWinRate = [math]::Round(($this.TotalWins / $this.TotalGames) * 100, 2);
        $metaData = Get-Games;
        $this.TotalRankedGames = $metaData.lobby_type.'7'.games;
        $this.RankedWins = $metaData.lobby_type.'7'.win;
        $this.RankedLose = $this.TotalRankedGames - $this.RankedWins;
        $this.RankedWinRate = [math]::Round(($this.RankedWins / $this.TotalRankedGames) * 100, 2);
        $this.TotalUnrankedGames = $metaData.lobby_type.'0'.games;
        $this.UnrankedWins = $metaData.lobby_type.'0'.win;
        $this.UnrankedLose = $this.TotalUnrankedGames - $this.UnrankedWins;
        $this.UnrankedWinRate = [math]::Round(($this.UnrankedWins / $this.TotalUnrankedGames) * 100, 2);
    }
    
}