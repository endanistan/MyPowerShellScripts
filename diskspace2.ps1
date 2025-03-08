#Script collects data about diskspace.
#Use -free, -used or -max to only collect some data. No parameters collects all 3.
param (

    [Switch]$free,
    [Switch]$used,
    [Switch]$max

)

    #Collects all potential data.
    $drives = Get-Volume | Where-Object {$_.Driveletter -ne $null} -ErrorAction Inquire

#Loops data into array $everything based on set parameters.
foreach ($volume in $drives) {
    #Ignores disks with a driveletters that are empty. Mainly to avoid potential issues with mounted dvd-drives.
    if ($null -eq $volume.Size -or $volume.Size -eq 0) {
        continue
    }

        $everything = @()
        $whole = $volume.Size
        $part = $volume.SizeRemaining
        $remaining = ($part / $whole * 100)
        $usednr = ($volume.Size - $volume.SizeRemaining)
        $usedp = ($usednr / $volume.Size * 100)
        $wholegb = $volume.Size/1gb

            if ($free) {
            
                $everything += [PSCustomObject]@{
                    "Driveletter" = $volume.Driveletter
                    "Free drive capacity %" = $remaining
                }

            }
    
            if ($used) {
            
                $everything += [PSCustomObject]@{
                    "Driveletter" = $volume.Driveletter
                    "Used drive capacity %" = $usedp
                }

            }  
    
            if ($max) {
            
                $everything += [PSCustomObject]@{
                    "Driveletter" = $volume.Driveletter
                    "Drive max capacity" = $wholegb
                }

            }

            if (-not ($free -or $used -or $max)) {

                $everything += [PSCustomObject]@{
                    "Driveletter" = $volume.Driveletter
                    "Drive max capacity gb" = $wholegb
                    "Used drive capacity %" = $usedp
                    "Free drive capacity %" = $remaining
                }

        }
    
    Write-Output $everything | Format-Table
                   
}