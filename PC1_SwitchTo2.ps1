# for MX keys:
# 0x00 = PC 1 (Channel 1)
# 0x01 = PC 2 (Channel 2)
# 0x02 = PC 3 (Channel 3)

# Inputs
$KeyboardID = "046D:B378"
$MouseID = "046D:B034"
$TargetDorMouse = "0x01"
$TargetMonitorInput = "17" 

# --- HID config ---
$ExePath = Join-Path $PSScriptRoot "hidapitester.exe"
$CmdPush = "0x11,0x00,0x0a,0x1b,$TargetDorMouse,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00"
# --- DDC Monitor Configuration ---
$ControlMyMonitorPath = Join-Path $PSScriptRoot "ControlMyMonitor.exe"
$VcpInputCode = "60" 

$WasPresent = $true
if (-not (Test-Path $ExePath)) { 
    Write-Host "hidapitester.exe manquant!"
    exit 
}
if (-not (Test-Path $ControlMyMonitorPath)) { 
    Write-Host "ControlMyMonitor.exe manquant!"
    exit 
}

while ($true) { 
    $output = & $ExePath --vidpid $KeyboardID --list 2>&1
    $IsPresent = [bool]($output -match ($KeyboardID -replace ":", "/"))

    if ($WasPresent -and -not $IsPresent) { 
        # 1. Switch the monitor input first as it takes more time
        & $ControlMyMonitorPath /SetValue Primary $VcpInputCode $TargetMonitorInput | Out-Null

        # 2. Try to move the mouse to the target PC
        $startTime = [Diagnostics.Stopwatch]::StartNew()
        $mouseSwitched = $false

        while ($startTime.Elapsed.TotalSeconds -lt 5 -and -not $mouseSwitched) {
            # Check if the mouse is still connected/present
            $mouseCheck = & $ExePath --vidpid $MouseID --list 2>&1
            $isMousePresent = [bool]($mouseCheck -match ($MouseID -replace ":", "/"))

            if ($isMousePresent) {
                & $ExePath --vidpid $MouseID --usage 0x0202 --usagePage 0xFF43 --open --length 20 --send-output $CmdPush | Out-Null
                Start-Sleep -Milliseconds 500
            } else {
                # Mouse is no longer present; switch was successful
                $mouseSwitched = $true
            }
        }
        $startTime.Stop()
    }

    # Only updates once the mouse loop completes or times out
    $WasPresent = $IsPresent 
    Start-Sleep -Seconds 1
}
