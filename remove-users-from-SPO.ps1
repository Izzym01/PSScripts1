#Config Parameters
$AdminSiteURL="https://foresightgroupllp-admin.sharepoint.com"
$UserAccount = "sbaugh@foresightgroup.eu"

$SitesCollections = Get-SPOSite -Limit ALL
 
#Iterate through each site collection
ForEach($Site in $SitesCollections)
{
    Write-host -f Yellow "Checking Site Collection:"$Site.URL
  
    #Get the user from site collection
    $User = Get-SPOUser -Limit All -Site $Site.URL | Where {$_.LoginName -eq $UserAccount}
  
    #Remove the User from site collection
    If($User)
    {
        #Remove the user from the site collection
        Remove-SPOUser -Site $Site.URL -LoginName $UserAccount
        Write-host -f Green "`tUser $($UserAccount) has been removed from Site collection!"
    }
}
