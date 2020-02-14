# Overview about $($Player.Name)

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}
.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;border-color:black;}
.tg .tg-9wq8{text-align:center;vertical-align:middle}
.tg .tg-vpz4{font-weight:bold;font-size:22px;font-family:"Arial Black", Gadget, sans-serif !important;;border-color:inherit;text-align:center;vertical-align:middle}
.tg .tg-xwyw{border-color:#000000;text-align:center;vertical-align:middle}
</style>
<table class="tg">
  <tr>
    <th class="tg-vpz4"> Core Rank</th>
    <th class="tg-vpz4"> Support Rank</th>
  </tr>
  <tr>
    <td class="tg-lboi" align="center">><img src="$($Player.CoreBadge)" alt="CoreRank Badge" width="100"/></td>
    <td class="tg-lboi" align="center">><img src="$($Player.SupportBadge)" alt="SupportRank Badge" width="100" /></td>
  </tr>
</table>

## Game Stats

|              | Total                   | Ranked                      | Unranked                      |
| ------------ | ----------------------- | --------------------------- | ----------------------------- |
| Games Played | $($Player.TotalGames)   | $($Player.TotalRankedGames) | $($Player.TotalUnrankedGames) |
| Games Won    | $($Player.TotalWins)    | $($Player.RankedWins)       | $($Player.UnrankedWins)       |
| Games Lost   | $($Player.TotalLose)    | $($Player.RankedLose)       | $($Player.UnrankedLose)       |
| Win Rate     | $($Player.TotalWinRate) | $($Player.RankedWinRate)    | $($Player.UnrankedWinRate)    |
