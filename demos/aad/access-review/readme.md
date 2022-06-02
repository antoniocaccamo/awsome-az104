# Demo: AD Access Review

Create the groups and members:

```bash
terraform init
terraform apply -auto-approve
```

Add two Guest users in the Portal, or using PowerShell (not available in the cli):

```ps1
New-MgInvitation -InvitedUserDisplayName "User2" -InvitedUserEmailAddress '<email>' -InviteRedirectUrl "https://myapplications.microsoft.com" -SendInvitationMessage:$true
New-MgInvitation -InvitedUserDisplayName "UserB" -InvitedUserEmailAddress '<email>' -InviteRedirectUrl "https://myapplications.microsoft.com" -SendInvitationMessage:$true
```

For testing purposes you can create a [temp mail][1].

To add Guests to groups first get the Object ID:

```bash
az ad user list --display-name 'User2'
az ad user list --display-name 'UserB'
```

Then add each to the specific testing group with the group `object_id` available in the TF output.

```bash
# User2 to Group1
az ad group member add -g '<GROUP_OBJECT_ID>' --member-id '<USER_OBJECT_ID>'

# UserB to Group2
az ad group member add -g '<GROUP_OBJECT_ID>' --member-id '<USER_OBJECT_ID>'
```

Delete everything when done.

[1]: https://temp-mail.org/en/