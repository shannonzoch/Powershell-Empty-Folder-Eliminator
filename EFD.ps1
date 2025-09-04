# Empty Folder Destroyer (EFD)
<#
.SYNOPSIS
    Finds and deletes empty subdirectories within a specified path.
.PARAMETER Path
    The root directory to start the scan from. This path must exist and be a directory.
.EXAMPLE
    .\Delete-EmptyFolders.ps1 -Path "C:\Users\YourUser\Documents"
Vibe coded by SMZ with Gemini
#>
param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Enter the full path to the directory you want to scan.")]
    [ValidateScript({
        if (Test-Path $_ -PathType Container) {
            return $true
        } else {
            throw "The path '$_' does not exist or is not a directory."
        }
    })]
    [string]$Path
)

# GET ALL FOLDERS AND SORT THEM BY DEEPEST-FIRST
# This prevents errors by ensuring child folders are deleted before their parents.
$folders = Get-ChildItem -Path $Path -Recurse -Directory | Sort-Object -Property {$_.FullName.Length} -Descending

# LOOP THROUGH EACH FOLDER AND DELETE IF EMPTY
foreach ($folder in $folders) {
    # Check if the folder is empty (the -Force switch includes hidden items)
    if ((Get-ChildItem -Path $folder.FullName -Force).Count -eq 0) {
        # Display which folder is being deleted and then remove it
        Write-Host "Deleting empty folder: $($folder.FullName)"
        Remove-Item -Path $folder.FullName -Force
    }
}

Write-Host "Scan complete for path: $Path"
