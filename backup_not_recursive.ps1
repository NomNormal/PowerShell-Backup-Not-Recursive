<#
Backup on a desired directory all the files without being recursive.
#>

# Set the path
$pathSource = "E:\"
$pathDestination = "D:\Users\Documents"

# Select exclusively the files in each directory
$listSource = Get-ChildItem $pathSource -File
$listDestination = Get-ChildItem $pathDestination -File

# Compare each file in the source directory
ForEach ($fileSource in $listSource) {
    # Create the file by default if the file doesn't exist in the directory
    $fileStatut = "create"

    # Compare each file in the destination directory
    ForEach ($fileDestination in $listDestination) {
        # Ignore the existing and updated file
        if ($fileSource.Name -eq $fileDestination.Name -and $fileSource.LastWriteTime -eq $fileDestination.LastWriteTime) {
            $fileStatut = "exist"
            break
        }

        # Set the update need
        if ($fileSource.Name -eq $fileDestination.Name -and $fileSource.LastWriteTime -ne $fileDestination.LastWriteTime) {
            $fileStatut = "update"
            break
        }
    }

    # Set full file path
    $itemCreate = $pathSource + $fileSource

    # Create the file
    if ($fileStatut -eq "create") {
        "CREATE - $fileSource"
        Copy-Item $itemCreate $pathDestination
    } 

    # Update the file
    if ($fileStatut -eq "update") {
        "UPDATE - $fileSource"
        $itemRemove = $pathDestination + "\" + $fileDestination
        Remove-Item $itemRemove
        Copy-Item $itemCreate $pathDestination
    }
}

"- - - DONE - - -"
