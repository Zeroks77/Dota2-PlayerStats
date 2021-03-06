﻿. .\src\functions\apiCalls.ps1
. .\src\functions\badge.ps1

function Get-Stats {
    [Player] $Player = [Player]::new();
    $PlayerActivity = New-Object PlayerActivity
    $PlayerPerformance = New-Object Performance;
    $Activity = Build-GenerellActivityString -PlayerActivity $PlayerActivity
    $RankedActivity = Build-RankedActivityString -PlayerActivity $PlayerActivity
    $Performance = Build-PerformanceString -Performance $PlayerPerformance
    $templateText = (Get-Content ".\template\Markdown\template.md" -Raw);
    $placeholderForQuote = (New-Guid).Guid;
    $templateText = $templateText.Replace('"', $placeholderForQuote);
    $templateText = Invoke-Expression """$templateText""";
    $templateText = $templateText.Replace($placeholderForQuote, '"');
    Out-File -Force -FilePath ".\Readme.md" -InputObject $templateText;
}

function Build-GenerellActivityString {
    param (
        [PlayerActivity] $PlayerActivity
    )
    [string] $outputString = "|      Hero        | Games               | Won with                     | Win Rate| Main Role|`r`n| ------------| ------------ | ------------ | ----------------------- | --------------------------- |";
    
    $PlayerActivity.GenerellHeroes = $PlayerActivity.GenerellHeroes | sort Games -descending;
    foreach ($item in $PlayerActivity.GenerellHeroes) {
        $winrate = [math]::Round($item.WinCount / $item.Games * 100, 2);
        $outputString += "`r`n|$($item.Name)|$($item.Games)|$($item.WinCount)|$winrate %|$($item.MainRole)| ";
    }
    return $outputString;
}

function Build-RankedActivityString {
    param (
        [PlayerActivity] $PlayerActivity
    )
    [string] $outputString = "|      Hero        | Games               | Won with                     | Win Rate| Main Role| Recommended to Play|`r`n| ------------| ------------| ------------ | ------------ | ----------------------- | --------------------------- |";
    
    $PlayerActivity.RankedHeroes = $PlayerActivity.RankedHeroes | sort Games -descending;
    foreach ($item in $PlayerActivity.RankedHeroes) {
        $winrate = [math]::Round($item.WinCount / $item.Games * 100, 2);
        $outputString += "`r`n|$($item.Name)|$($item.Games)|$($item.WinCount)|$winrate %|$($item.MainRole)| ";
        if ($winrate -gt 59) {
            $outputString += "<img src=""https://image.flaticon.com/icons/png/512/2268/2268453.png"" alt=""Recommended"" width=""25""/>"
        }
        elseif ($winrate -lt 60 -and $winrate -gt 45) {
            $outputString += "<img src=""https://image.flaticon.com/icons/png/512/2268/2268506.png"" alt=""Playable but not recommended"" width=""25""/>"
        }
        else {
            $outputString += "<img src=""https://image.flaticon.com/icons/png/512/2268/2268512.png"" alt=""Not Recommended"" width=""25""/>"
        }
    }
    return $outputString;
}

function Build-PerformanceString {
    param (
        [Performance] $Performance
    )
    $Performance.HeroPerformance = $Performance.HeroPerformance | sort Games -descending; 
    [string] $outputString = "|      Hero        | Games               | Won with                     | Win Rate|`r`n| ------------ | ------------ | ----------------------- | --------------------------- |";
    foreach ($item in $Performance.HeroPerformance) {
        if ($item.WinCount -eq 0) {
            $winrate = 0;
        }
        else {
            $winrate = [math]::Round($item.WinCount / $item.Games * 100, 2);   
        }
        $outputString += "`r`n|$($item.Name)|$($item.Games)|$($item.WinCount)|$winrate %|";
    }
    return $outputString;
}

class Performance {
    [Hero[]] $HeroPerformance;
    Performance() {
        $MetaData = Get-AllTimeHeroPerformance;
        $heroesMetadata = Get-Heros;
        foreach ($item in $MetaData) {
            $this.HeroPerformance += Get-HeroWithoutRole -HeroId $item.hero_id -heroData $heroesMetadata -winCount $item.win -matchCount $item.games
        }
    }
}


class PlayerActivity {
    [Hero[]] $GenerellHeroes;
    [Hero[]] $RankedHeroes;
    [int] $WinRate;
    PlayerActivity() {
        $PlayerActivityMetadata = Get-PlayerActivity;
        $RankedActivity = Get-PlayerRankedActivity;
        $heroesMetadata = Get-Heros;
        $this.WinRate = [math]::Round(($PlayerActivityMetadata.winCount / 25) * 100, 2);  
        foreach ($item in $PlayerActivityMetadata.heroes) {
            $this.GenerellHeroes += Get-Hero -HeroId $item.heroId -heroData $heroesMetadata -winCount $item.winCount -matchCount $item.matchCount -roles $item.roles
        }
        foreach ($item in $RankedActivity.heroes) {
            $this.RankedHeroes += Get-Hero -HeroId $item.heroId -heroData $heroesMetadata -winCount $item.winCount -matchCount $item.matchCount -roles $item.roles
        }
    }
}
function Get-HeroWithoutRole {
    param( [int] $HeroId, $heroData, $winCount, $matchCount)

    for ($i = 1; $i -lt 130; $i++) {
        if ($herodata.$i.id -eq $HeroId) {
            return [Hero]::new($herodata.$i.id, $herodata.$i.DisplayName, $winCount, $matchCount, $null)
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
    Hero([int] $id, [string]$name , [int]$winCount, [int]$games, $Roles) {
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
    [string] $RankBadge;
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
        $this.RankBadge = Get-RankBadge -Rank $metaData.steamAccount.seasonRank;
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
