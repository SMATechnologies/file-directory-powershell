param
(
    [String]$path,
    [String]$info,
    [String]$user,
    [String]$login,
    [String]$option
)

#Checks number of files/folders in a directory
if($option -eq "checknum")
{
    if (($path -ne "") -and (test-path $path))
    {
        if ((get-childitem $path | measure-object).count -eq 0) 
        {
            Write-Host "0 files in $path"
            Exit 101
        }
    }
    else
    {
        Write-Host "Invalid directory"
        Exit 100
    }
}
elseif($option -eq "new")
{
    # Creates a new directory in the target location
    New-Item $path -itemtype directory
}
elseif($option -eq "checkfile")
{
    if(test-path "$path")
    {
    	    write-host "File found, exiting..."
	    Exit
    }
    else
    {
    	    write-host "File not found!!"
	    Exit 100
    }
}
elseif($option -eq "findNum")
{
    # Gets count of line, word, or character in a file
    if (("$path" -ne "") -and (test-path "$path"))
    {
        $command = "(Get-Content ""$path"" | Measure-Object -$info).$info" + "s"
        iex $command
        if ($?)
        {
            Write-Host "Script complete"
        }
        else
        {
            Write-Host "Script error"
            Exit 100
        }
    }
    else
    {
        Write-Host "Invalid or blank directory"
        Exit 101
    }
}
elseif($option -eq "createShare")
{
    New-Item “$path" –type directory
    New-SMBShare –Name “$user” –Path “$path” –FullAccess $login #-ChangeAccess domain\deptusers -ReadAccess “domain\authenticated users”
}
elseif($option -eq "deleteShare")
{
    Remove-SmbShare -Name "$user" -Force
    Remove-Item "$path" -Confirm:$false
}

