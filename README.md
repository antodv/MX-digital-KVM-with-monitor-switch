# KVM to switch your bluetooth mouse and monitor (ddc) when switching your keyboard 

A lightweight, invisible PowerShell solution to swicth your HMI and monitor input when you switch your HMI to another computer. This solution was designed for Logitech MX keyboard and Keys. 

Disclaimer: WORKS ONLY WITH 2 CLIENTS.

🚀 The Problem
Switching a monitor, mouse and keyboard can be tedious. This links everything together and changes the mouse/keyboard automatically and the monitor input too.

✅ The Solution
This script uses "Hardware Polling". It detects when the keyboard disconnects from PC 1 (because you pressed "2") and immediately sends a USB command to the mouse to force it to switch to PC 2.

📦 Prerequisites
- 2 Windows PCs.
- **hidapitester.exe** (Command line tool to talk to USB devices).
- This repository's scripts.

🚀 Installation
   1. Download
      1. Create a folder `C:\LogiSwitch` on BOTH computers.
      2. Download `hidapitester_windows_x64.zip` from [todbot/hidapitester](https://github.com/todbot/hidapitester/releases) and extract `hidapitester.exe` into that folder.
      3. Download the scripts from this repository (`0_Get_IDs.ps1`, `PC1_SwitchTo2.ps1`, `PC2_SwitchTo1.ps1`) and place them in the folder.
      4. Download ControlMyMonitor from https://www.controlmymonitor.com/ and place it into that folder.
      
   2. Prepare: Get your Hardware IDs on one of your computers:
         1. Right-click `0_Get_IDs.ps1` and select **Run with PowerShell**.
         2. Note the IDs for your Keyboard (e.g., `046D:B378`) and Mouse (e.g., `046D:B034`).
   
   3. Configure the Scripts
      On PC 1 (The PC linked to Key 1)
         1. Open `PC1_SwitchTo2.ps1` with Notepad.
         2. Replace `$KeyboardID` and `$MouseID` with your own codes.
         3. Ensure `$TargetForMouse` is set to the correct channel for PC 2 (usually `0x01`).
         4. Open ControlMyMonitor.exe and find the input select (VCP 60) ID of your input.
         5. Save. 
      On PC 2 (The PC linked to Key 2)
         1. Open `PC2_SwitchTo1.ps1` with Notepad.
         2. Replace `$KeyboardID` and `$MouseID` with your own codes.
         3. Ensure `$TargetForMouse` is set to the correct channel for PC 1 (usually `0x00`).
         4. Save.
   
   4. Auto-Start (Set and Forget) run the script on background:
      1. Press `Win + R`, type `shell:startup`, and press Enter.
      2. Create a shortcut in this folder.
      3. Set the shortcut target to:
         `cmd.exe /c start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\LogiSwitch\PC1_SwitchTo2.ps1"`
         *(Change the filename accordingly for PC 2).*

⚠️ Disclaimer
This script relies on `hidapitester` to send raw HID commands. Use at your own risk. This is not an official Logitech product.
