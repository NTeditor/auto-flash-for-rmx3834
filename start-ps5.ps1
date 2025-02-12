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
3 �������� boot
4 �������� GSI
5 ��������� Platform-Tools ����� winget
Q �����
"@






Do {
    Switch (Invoke-Menu -menu $menu -title Auto-Flash-for-RMX3834 -clear) {
     "1" {Write-Host "������������ � FastbootD" -ForegroundColor Green
          Read-Host -Prompt "�������, ����� ����������."
          adb reboot fastboot
          sleep -seconds 5
         }
     "2" {Write-Host "������������ �� Bootloader � FastbootD" -ForegroundColor Green
          Read-Host -Prompt "�������, ����� ����������."
          fastboot reboot fastboot
          sleep -seconds 5
          }
     "3" {Write-Host "�������� Boot" -ForegroundColor Yellow
          fastboot devices
          Write-Host ""
          Write-Host "�������� ���� ������� �����..."
          Write-Host "�������� ���� -> $FilePath"


          [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null
 
          $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
          $OpenFileDialog.initialDirectory = $initialDirectory
          $OpenFileDialog.filter = "����� (*.img)|*.img|��� ����� (*.*)|*.*"
          $OpenFileDialog.ShowDialog() | Out-Null
          $FilePath = $OpenFileDialog.filename
          $FilePath

          if ( "" -eq $FilePath ) {
            throw '������ ������ ������!'
          }

          Write-Host "�������� boot_a.."
          fastboot flash boot_a $FilePath
          Write-Host "�������� boot_b.."
          fastboot flash boot_b $FilePath
          sleep -seconds 5
          }
     "4" {Write-Host "�������� GSI" -ForegroundColor Green
          

          [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null
 
          $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
          $OpenFileDialog.initialDirectory = $initialDirectory
          $OpenFileDialog.filter = "����� (*.img)|*.img|��� ����� (*.*)|*.*"
          $OpenFileDialog.ShowDialog() | Out-Null
          $FilePath = $OpenFileDialog.filename
          $FilePath

          if ( "" -eq $FilePath ) {
            throw '������ ������ ������!'
          }

          Write-Host "�������� ���� -> $FilePath"


          Write-Host "�������������� �������������� ������������ � FastbootD."
          fastboot reboot fastboot
          Write-Host "������� system.."
          fastboot erase system
          Write-Host "�������� product_a.."
          fastboot delete-logical-partition product_a
          Write-Host "�������� product_b.."
          fastboot delete-logical-partition product_b
          Write-Host "�������� system.."
          fastboot flash system $FilePath
          Write-Host "������������ � recovery.."
          fastboot reboot recovery
          Read-Host -Prompt "�������� ���������, ������� ��������� ����� recovery � ��������������� � �������."
          sleep -seconds 2
         }
     "5" {Write-Host "��������� Platform-Tools ����� winget" -ForegroundColor Green
          winget search platformtool
          sleep -seconds 1
          winget install --id Google.PlatformTools --source winget
          sleep -seconds 5
      }
#    "6" {Write-Host "��������� Platform-Tools" -ForegroundColor Red
#      sleep -seconds 2
#      sudo apt install android-sdk-platform-tools
#      sleep -seconds 5
#         }
     "Q" {Write-Host "�����..."
         Return
         }
     Default {Write-Warning "Invalid Choice. Try again."
              sleep -milliseconds 750}
    } #switch
} While ($True)

