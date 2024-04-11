$clientId = "" 
$tenantId = "" 
$clientSecret = ""  



$scope = "https://graph.microsoft.com/.default"  #application permissions “AuditLog.Read.All” and “User.Read.All“.

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
