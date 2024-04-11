# Configuration
$ClientId = "27b8eb81-e1c8-4152-8928-29f3c42ba07d" 
$TenantId = "beb63dc3-dd0c-40d6-b1d2-db518fd2a8c4" 
$ClientSecret = "gdj8Q~jRiy~rcP-~--L4fQRRWyK1flay4XveWc_J"  

# Convert the client secret to a secure string
$ClientSecretPass = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force

# Create a credential object using the client ID and secure string
$ClientSecretCredential = New-Object `
    -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $ClientId, $ClientSecretPass

# Connect to Microsoft Graph with Client Secret
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential

$applications = Get-MgApplication -Property "id,appId,displayName,passwordCredentials"

# Iterate through the applications and print out the details
foreach ($application in $applications)
{
    # Print out the application ID, app ID, display name, and password credentials
    Write-Output "ID: $($application.id)"
    Write-Output "App ID: $($application.appId)"
    Write-Output "Display name: $($application.displayName)"
    Write-Output "Password credentials:"

    foreach ($passwordCredential in $application.passwordCredentials)
    {
        $currentDate = Get-Date
        $dateToCheck = $passwordCredential.endDateTime
        $daysToCheckAgainst = 3000  # Check within the 30 days window
        $daysUntilDate = (New-TimeSpan -Start $currentDate -End $dateToCheck).Days

        if ($daysUntilDate -lt $daysToCheckAgainst -and $daysUntilDate -ge 0) {
            Write-Output "Days left: $daysUntilDate"
            Write-Output "  Type: Password"
            Write-Output "  Value: $($passwordCredential.value)"
            Write-Output "  End date time: $($passwordCredential.endDateTime)"
            Write-Output "  Key ID: $($passwordCredential.keyId)"


            #ADD YOU EMAIL SENDING CODE HERE


        }
    }
}
