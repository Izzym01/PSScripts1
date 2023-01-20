#Config Parameters
$AdminSiteURL="https://foresightgroupllp-admin.sharepoint.com"
$UserAccount = "jsteven@foresightgroup.eu"

$SitesCollections = Get-SPOSite -Limit ALL
 
#Loop through each site and remove site collection admin
Foreach ($Site in $Sites)
{
    
    #Get All Site Collection Administrators
    $Admins = Get-SPOUser -Site $site.Url | Where {$_.IsSiteAdmin -eq $true}
 
    #Iterate through each admin
    Foreach($Admin in $Admins)
    {
        #Check if the Admin Name matches
        If($Admin.LoginName -eq $AdminAccount)
        {
            #Remove Site collection Administrator
            Write-host "Removing Site Collection Admin from:"$Site.URL -f Green
            Set-SPOUser -site $Site -LoginName $AdminAccount -IsSiteCollectionAdmin $False
        }
    }
}

