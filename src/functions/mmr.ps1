. .\src\functions\apiCalls.ps1
. .\src\functions\badge.ps1

function Get-Stats {
    [Player] $Player = [Player]::new();
    $PlayerActivity = New-Object PlayerActivity
    $Activity = Build-ActivityString -PlayerActivity $PlayerActivity
    $templateText = (Get-Content ".\template\Markdown\template.md" -Raw);
    $placeholderForQuote = (New-Guid).Guid;
    $templateText = $templateText.Replace('"', $placeholderForQuote);
    $templateText = Invoke-Expression """$templateText""";
    $templateText = $templateText.Replace($placeholderForQuote, '"');
    Out-File -Force -FilePath ".\Readme.md" -InputObject $templateText;
}

function Build-ActivityString {
    param (
        [PlayerActivity] $PlayerActivity
    )
    [string] $outputString = "|      Hero        | Games               | Won with                     | Win Rate| Main Role|`r`n| ------------| ------------ | ------------ | ----------------------- | --------------------------- |";
    foreach ($item in $PlayerActivity.heroes) {
        $winrate = [math]::Round($item.WinCount / $item.Games * 100, 2);
        $outputString += "`r`n|$($item.Name)|$($item.Games)|$($item.WinCount)|$winrate %|$($item.MainRole)| ";
    }
    return $outputString;
}



class PlayerActivity {
    [Hero[]] $heroes;

    PlayerActivity() {
        $PlayerActivityMetadata = Get-PlayerActivity;
        $heroesMetadata = Get-Heros;
        foreach ($item in $PlayerActivityMetadata.heroes) {
            $this.heroes += Get-Hero -HeroId $item.heroId -heroData $heroesMetadata -winCount $item.winCount -matchCount $item.matchCount -roles $item.roles
        }
    }
}

function Get-Hero {
    param( [int] $HeroId, $heroData, $winCount, $matchCount, $roles)

    for ($i = 1; $i -lt 130; $i++) {
        if ($herodata.$i.id -eq $HeroId) {
            return [Hero]::new($herodata.$i.id, $herodata.$i.DisplayName, $winCount, $matchCount, $roles )
        }
    }


}
enum Role {
    Support
    Carry
    Both
}
class Hero {
    [string] $Name;
    [int] $Games;
    [int] $WinCount;
    [int] $Id;
    [Role] $MainRole
    Hero([int] $id, [string]$name , [int]$winCount, [int]$games, $Roles ) {
        [int] $CarryCount = 0;
        [int] $SupportCount = 0;
        foreach ($item in $Roles) {
            if ($item.role -eq 0) {
                $CarryCount++;
            }
            else {
                $SupportCount++;
            }
        }
        if ($CarryCount -gt $SupportCount) {
            $this.MainRole = [Role]::Carry;
        }
        elseif ($SupportCount -gt $CarryCount) {
            $this.MainRole = [Role]::Support;
        }
        else {
            $this.MainRole = [Role]::Both;
        }
        $this.Name = $name;
        $this.Id = $id;
        $this.Games = $games
        $this.WinCount = $winCount;
    }
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