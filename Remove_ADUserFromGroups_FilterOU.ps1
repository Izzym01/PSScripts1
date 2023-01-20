$Token = (Get-ADGroup "Domain Users" -Properties PrimaryGroupToken).PrimaryGroupToken

Get-ADUser -Filter 'Enabled -eq "False"' -SearchBase "OU=" -Properties PrimaryGroup,MemberOf | ForEach-Object {

#If User Primary Group is not Domain Users, then Set Domain User as Primary Group.

If ($_.PrimaryGroup -notmatch "Domain Users"){
             Set-aduser -Identity $_ -Replace @{PrimaryGroupID = $Token } -Verbose
                                               } #If

#If User is a member of more than 1 Group. Remove All Group except Domain Users.

If ($_.memberof) {
            $Group = Get-ADPrincipalGroupMembership -Identity $_ | Where-Object {$_.Name -ne 'Domain Users'}
                     Remove-ADPrincipalGroupMembership -Identity $_ -MemberOf $Group -Confirm:$false -Verbose
                  }

}


#Add group members via CSV:

Import-Csv C:\ | %{ Add-ADGroupMember "Group NAme" -Members $_.sAMAccountName }
