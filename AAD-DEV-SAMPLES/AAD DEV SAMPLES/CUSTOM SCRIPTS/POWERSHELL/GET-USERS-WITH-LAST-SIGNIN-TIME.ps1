$clientId = "000" 
$tenantId = "0000" 
$clientSecret = "000"  
 
 
$scope = "https://graph.microsoft.com/.default"  #application permissions “AuditLog.Read.All” and “User.Read.All“.
 
$body = @{
 
    client_id = $clientId
 
    scope = $scope
 
    client_secret = $clientSecret
 
   grant_type = "client_credentials"
 
}
 
$response = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
 
$accessToken = $response.access_token
 
$accessToken
 
$header = @{
 
    "Authorization" = "Bearer $accessToken"
 
}
 
$ApiUrl = "https://graph.microsoft.com/beta/users?`$select=displayName,userPrincipalName,signInActivity,userType,createdDateTime,assignedLicenses&$top=999" 
 
$Result = @()
While ($ApiUrl -ne $Null) #Perform pagination if next page link (odata.nextlink) returned.
{
$Response =  Invoke-RestMethod -Method Get -Uri $ApiUrl -Headers $header
if($Response.value)
{
$Users = $Response.value
ForEach($User in $Users)
{
 
$Result += New-Object PSObject -property $([ordered]@{ 
Id= $User.Id
DisplayName = $User.displayName
UserPrincipalName = $User.userPrincipalName
LastSignInDateTime = if($User.signInActivity.lastSignInDateTime) { [DateTime]$User.signInActivity.lastSignInDateTime } Else {$null}
LastNonInteractiveSignInDateTime = if($User.signInActivity.lastNonInteractiveSignInDateTime) { [DateTime]$User.signInActivity.lastNonInteractiveSignInDateTime } Else { $null }
CreatedDateTime= $User.createdDateTime
UserType= $User.UserType
})
}
 
}
$ApiUrl=$Response.'@odata.nextlink'
}
 
 
 
$Result | Export-CSV "new-last-9.csv" -NoTypeInformation -Encoding UTF8