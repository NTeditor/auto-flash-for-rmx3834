# menu by https://fixmypc.ru/post/kak-rabotat-s-iskliucheniiami-i-oshibkami-v-powershell-s-try-i-catch-na-primerakh/



Function Invoke-Menu {
[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory=$True)]
[ValidateNotNullOrEmpty()]
[string]$Menu,
[Parameter(Position=1)]
[ValidateNotNullOrEmpty()]
[string]$Title = "Auto-Flash-RMX3834",
[Alias("cls")]
[switch]$ClearScreen
)
#clear the screen if requested
if ($ClearScreen) {
 Clear-Host
}
#build the menu prompt
$menuPrompt = $title
#add a return
$menuprompt+="`n"
#add an underline
$menuprompt+="-"*$title.Length
#add another return
$menuprompt+="`n"
#add the menu
$menuPrompt+=$menu
Read-Host -Prompt $menuprompt
} #end function


$menu=@"
v0.0.1



1 ADB -> FastbootD
2 Bootloader -> FastbootD
3 Прошивка boot
4 Прошивка GSI
5 Установка Platform-Tools через winget
Q Выход
"@






Do {
    Switch (Invoke-Menu -menu $menu -title Auto-Flash-for-RMX3834 -clear) {
     "1" {Write-Host "Перезагрузка в FastbootD" -ForegroundColor Green
          Read-Host -Prompt "Нажмите, чтобы продолжить."
          adb reboot fastboot
          sleep -seconds 5
         }
     "2" {Write-Host "Перезагрузка из Bootloader в FastbootD" -ForegroundColor Green
          Read-Host -Prompt "Нажмите, чтобы продолжить."
          fastboot reboot fastboot
          sleep -seconds 5
          }
     "3" {Write-Host "Прошивка Boot" -ForegroundColor Yellow
          fastboot devices
          Write-Host ""
          Write-Host "Открытие окна запроса файла..."
          Write-Host "Выбраный файл -> $FilePath"


          [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null
 
          $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
          $OpenFileDialog.initialDirectory = $initialDirectory
          $OpenFileDialog.filter = "Образ (*.img)|*.img|Все файлы (*.*)|*.*"
          $OpenFileDialog.ShowDialog() | Out-Null
          $FilePath = $OpenFileDialog.filename
          $FilePath

          if ( "" -eq $FilePath ) {
            throw 'Нажата кнопка отмены!'
          }

          Write-Host "Прошивка boot_a.."
          fastboot flash boot_a $FilePath
          Write-Host "Прошивка boot_b.."
          fastboot flash boot_b $FilePath
          sleep -seconds 5
          }
     "4" {Write-Host "Прошивка GSI" -ForegroundColor Green
          

          [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null
 
          $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
          $OpenFileDialog.initialDirectory = $initialDirectory
          $OpenFileDialog.filter = "Образ (*.img)|*.img|Все файлы (*.*)|*.*"
          $OpenFileDialog.ShowDialog() | Out-Null
          $FilePath = $OpenFileDialog.filename
          $FilePath

          if ( "" -eq $FilePath ) {
            throw 'Нажата кнопка отмены!'
          }

          Write-Host "Выбраный файл -> $FilePath"


          Write-Host "Автоматическая принудительная перезагрузка в FastbootD."
          fastboot reboot fastboot
          Write-Host "Очистка system.."
          fastboot erase system
          Write-Host "Удаление product_a.."
          fastboot delete-logical-partition product_a
          Write-Host "Удаление product_b.."
          fastboot delete-logical-partition product_b
          Write-Host "Прошивка system.."
          fastboot flash system $FilePath
          Write-Host "Перезагрузка в recovery.."
          fastboot reboot recovery
          Read-Host -Prompt "Прошивка завершина, сбросте настройки через recovery и перезагрузитесь в систему."
          sleep -seconds 2
         }
     "5" {Write-Host "Установка Platform-Tools через winget" -ForegroundColor Green
          winget search platformtool
          sleep -seconds 1
          winget install --id Google.PlatformTools --source winget
          sleep -seconds 5
      }
#    "6" {Write-Host "Установка Platform-Tools" -ForegroundColor Red
#      sleep -seconds 2
#      sudo apt install android-sdk-platform-tools
#      sleep -seconds 5
#         }
     "Q" {Write-Host "Выход..."
         Return
         }
     Default {Write-Warning "Invalid Choice. Try again."
              sleep -milliseconds 750}
    } #switch
} While ($True)

