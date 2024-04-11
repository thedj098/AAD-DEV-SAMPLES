# Define your Microsoft Graph API variables
$clientId = "xxxxxxxxxxxxxxxxxxxxxx" 
$tenantId = "xxxxxxxxxxxxxxxxxxx" 
$clientSecret = "xxxxxxxxxxxxxxxx"  

# Define the user's email domain you want to filter
$emailDomain = "@gmail.com"

# Construct the token endpoint
$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Construct the authentication header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("${clientId}:${clientSecret}")))

# Define Microsoft Graph API endpoint for users
$graphUsersEndpoint = "https://graph.microsoft.com/v1.0/users"

# Request a token
$tokenResponse = Invoke-RestMethod -Uri $tokenEndpoint -Method Post -Body @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://graph.microsoft.com/.default"
} -Headers @{ "Authorization" = "Basic $base64AuthInfo" }

# Extract the access token
$accessToken = $tokenResponse.access_token

# Make the request to Microsoft Graph API to retrieve all users
$uri = "$graphUsersEndpoint"
$usersResponse = Invoke-RestMethod -Uri $uri -Method Get -Headers @{ "Authorization" = "Bearer $accessToken" }

# Filter users on the client side based on email domain
$filteredUsers = $usersResponse.value | Where-Object { $_.mail -like "*$emailDomain" }

# Output the filtered users
$filteredUsers | Select-Object DisplayName, UserPrincipalName, Mail
