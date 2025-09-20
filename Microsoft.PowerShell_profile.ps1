oh-my-posh init pwsh --config "C:\Users\tyler\AppData\Local\Programs\oh-my-posh\themes\aliens.omp.json" | Invoke-Expression

Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

Import-Module posh-git

Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f'
#Set-PsFzfOption -PSReadlineChordForwardHistory 'Ctrl+t'

Set-PSReadLineOption -PredictionSource HistoryAndPlugin -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows