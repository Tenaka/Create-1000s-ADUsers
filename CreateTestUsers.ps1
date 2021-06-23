#get OU for users
import-module activedirectory

#Get Targetted OU
$orgOU = Get-ADOrganizationalUnit "ou=Test Users,ou=Org,dc=sh,dc=loc"
$orgOU.distinguishedname

#set password length
$length = "14"

#Outs the account and password created
$results =  "c:\Downloads\results.txt"
  
#current number of users in OU
$aduE = get-aduser -filter {samaccountname -like "*"} -SearchBase $orgOU
$existing = $aduE.count

#Import list of first and surnames
$Names = "C:\Downloads\names.csv"

#imports and works out max possible users that can be created
$impName = Import-Csv -path $Names
$FNCT = ($impName.firstname | where {$_.trim() -ne ""}).count 
$SNCT = ($impName.surname | Where {$_.trim() -ne ""}).count
$maxUN = $FNCT * $SNCT
$total = ($maxUn.ToString()) -10

do {$enter = ([int]$NOS = (read-host "Max User accounts is "$total", how many do you need"))
}
until ($nos -le $total)

$UserLists=@{}

#Randomises first and surnames
do {

    $FName = ($impName.firstname | where {$_.trim() -ne ""})|sort {get-random} | select -First 1
    $SName = ($impName.surname | Where {$_.trim() -ne ""}) |sort {get-random} | select -First 1
      
    $UserIDs = $Fname + "." + $Sname 
    
try {$UserLists.add($UserIds,$UserIDs)} catch {}
       $UserIDs = $null

     Write-Host $UserLists.count  
            
} until ($UserLists.count -eq $nos)

    $UserLists.count
    $userlists.GetEnumerator()
    $UserLists.key
    $ADUs = $UserLists.values
    

foreach ($ADu in $ADus)
    {
        #set var for random passwords
        $Assembly = Add-Type -AssemblyName System.Web
        $RandomComplexPassword = [System.Web.Security.Membership]::GeneratePassword($Length,4)

    foreach ($pwd in $RandomComplexPassword) 
        {
        #Splits username to be used to create first and surname        
        $ADComp = get-aduser -filter {samaccountname -eq $ADU}
        $spUse = $ADu.Split('.') 
        $firstNe = $spUse[0]
        $surNe = $spUse[1]

       $pwSec = ConvertTo-SecureString "$pwd" -AsPlainText -Force 

        #Creates user accounts
        if ($ADComp -eq $null)
            {
        new-aduser -Name "$ADU" `
        -SamAccountName "$ADU" `
        -AccountPassword $pwSec `
        -GivenName "$firstNe" `
        -Surname "$surNe" `
        -Displayname "$FnS" `
        -Description "TEST $ADu" `
        -Path $orgOU `
        -Enable $true `
        -ProfilePath "\\shdc1\Profiles$\$ADU" `
        -HomeDirectory "\\shdc1\Home$\$ADU" `
        -HomeDrive "H:" `

        #Add Group membership
        Add-ADGroupMember -Identity "DFSAccess"-Members $ADU

        #Outs results to Results file
        $adu | out-file $results -Append
        $pwd | out-file $results  -Append
        "  " | out-file $results -Append
                }
       else {"nope exists "}
       
       write-host $ADU
               
            }
      }  
 
# Total users in OU
$aduC = get-aduser -filter {samaccountname -like "*"} -SearchBase $orgOU
$TotalU = $aduC.count

#Total users created
write-host "Total New Users"
$TotalU - $existing
