# Overview about $($Player.Name)

## Rank

 <img src="$($Player.SupportBadge)" alt="SupportRank Badge" width="100" /> |

## Game Stats

|              | Total                    | Ranked                      | Unranked                      |
| ------------ | ------------------------ | --------------------------- | ----------------------------- |
| Games Played | $($Player.TotalGames)    | $($Player.TotalRankedGames) | $($Player.TotalUnrankedGames) |
| Games Won    | $($Player.TotalWins)     | $($Player.RankedWins)       | $($Player.UnrankedWins)       |
| Games Lost   | $($Player.TotalLose)     | $($Player.RankedLose)       | $($Player.UnrankedLose)       |
| Win Rate     | $($Player.TotalWinRate)% | $($Player.RankedWinRate)%   | $($Player.UnrankedWinRate)%   |

## Generell Activity over Last 25 Matches

$Activity

## Ranked Activity over Last 25 Ranked Matches

$RankedActivity
