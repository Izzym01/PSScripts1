$mailbox = Get-Recipient -Identity "cadams@foresightgroup.eu"

$DN = $mailbox.DistinguishedName

$Filter = "Members -like '$DN'"

$DistributionGroupsList = Get-DistributionGroup -ResultSize Unlimited -Filter $Filter

Write-host `n
Write-host "Listing all Distribution Groups:"
Write-host `n
$DistributionGroupsList | ft

    ForEach ($item in $DistributionGroupsList) {
        Remove-DistributionGroupMember -Identity $item.DisplayName –Member $mailbox –BypassSecurityGroupManagerCheck -Confirm:$false
    }
    
    Write-host `n
    Write-host "Successfully removed"

    Remove-Variable * -ErrorAction SilentlyContinue