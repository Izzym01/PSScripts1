# Arrays for capturing the actions
$owned      = @()
$memberof   = @()

# Get all of the Office 365 groups
$azgroups = Get-AzureADMSGroup -All:$true
Write-Output "$($azgroups.Count) 365 groups were found"

# Get info for departing user
$upn = "jsteven@foresightgroup.eu"
$AZuser = Get-AzureADUser -ObjectID $upn

# Get info for delegate
$delegate = "wanstorim@foresightgroup.eu"
$AZdelegate = Get-AzureADUser -ObjectID $delegate

# Check each group for the user
foreach ($group in $azgroups) {
    $members = (Get-AzureADGroupMember -ObjectId $group.id).UserPrincipalName
    If ($members -contains $upn) {
        Remove-AzureADGroupMember -ObjectId $group.Id -MemberId $AZuser.ObjectId
        Write-Output "$upn was removed from $($group.DisplayName)"
        $memberof += $group

        $owners  = Get-AzureADGroupOwner -ObjectId $group.id
        foreach ($owner in $owners) {
            If ($upn -eq $owner.UserPrincipalName) {
                # Add a new owner to prevent orphaned
                Write-Output "$delegate was added as a new owner"
                Add-AzureADGroupOwner -ObjectId $group.Id -RefObjectId $AZdelegate.ObjectId
                
                # Now we can remove the user
                Write-Output "$upn was removed as owner of $($group.DisplayName)"
                Remove-AzureADGroupOwner -ObjectId $group.Id -OwnerId $AZuser.ObjectId
                $owned += $group
            }
        }
    }
}

# Groups that the user owned:
Write-Output "$upn was removed as Owner of:"
$owned | Select-Object DisplayName, Id

#Groups that the user was a member of:
Write-Output "$upn was removed as Member of:"
$memberof | Select-Object DisplayName, Id