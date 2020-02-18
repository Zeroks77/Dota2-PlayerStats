. .\src\functions\mmr.ps1

function Get-PlayerData {
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