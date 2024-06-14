A very slightly "make like" tool that can be used to package PowerShell scripts into IntuneWin files. 

Instructions: 
1) Put your code in the "source" folder. Leave Detect-Version.ps1. 
2) Update Make-IntuneWin.ps1 with your titles, description and the master ps1 file you want to run. 
2a) The make script will replace <!TAGS> in your source script with values you specify. 
3) Run Make-IntuneWin.ps1

Output: 
- art/ will contain a time/dated zip of your source and the .intunewin file
- arch/ will contain <>
- bin/ will contain a .intunewin

Detection 
Intune offers the ability to have a "Detection Script" to check your app installed. This tool will make a JSON file in the target directory and a suitable "Detect-Version" script to read it, updated on every run with a time/date version.
