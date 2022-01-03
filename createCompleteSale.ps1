$merchantCode = 'MERCHANT_CODE'
$secret = 'SECRET_KEY'

$url = "API_URL"
$date = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId((Get-Date), 'Greenwich Standard Time')
$date =  Get-Date $date -Format "yyyy-MM-dd HH:mm:ss"

$message = "$($merchantCode.Length)$($merchantCode)$($date.Length)$($date)"

$hmacmd5 = New-Object System.Security.Cryptography.HMACMD5
$hmacmd5.key = [Text.Encoding]::ASCII.GetBytes($secret)
$signature = $hmacmd5.ComputeHash([Text.Encoding]::UTF8.GetBytes($message))
$signature = ($signature | ForEach-Object ToString x2 ) -join ''
$authenticationHeader = "code=`"MERCHANT_CODE`" date=`"$date`" hash=`"$signature`""

$productCode = "PRODUCT_CODE"
$productName = "PRODUCT_NAME"

$body = @"
{
  'payload' : null
}
"@

$headers = @{
    "Content-Type" = 'application/json';
    'Cache-Control' = 'no-cache';
    'Accept' = 'application/json';
    "Content-Length" = $body.Length;
}

$request = Invoke-RestMethod -Uri $url -Headers $headers -Body $body -ContentType 'application/json' -Method Post
$referenceNumber = $request.RefNo 
Write-Output "ReferenceNumber: $referenceNumber"

# ------------------------------------------

$url = "get_saleid_by_reference_number_url"
$saleId = $request = Invoke-RestMethod -Uri $url -Method Get
Write-Output "SaleId: $saleId"

# ------------------------------------------

Start-process "chrome.exe" "SALE_URL"'

Write-Output "`n`nSaleId: $saleId"

