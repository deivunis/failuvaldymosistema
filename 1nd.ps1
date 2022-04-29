#Set-ExecutionPolicy RemoteSigned
#Set-ExecutionPolicy Restricted
#Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

#Nauju komandu sarasas:
#clear-content
#compare-object
#Get-FileHash
#Invoke-WebRequest
#Start-MpScan
#unblock-file

#atsisiuntimo nuoroda: https://drive.google.com/uc?export=download&id=1-I85kpgXtSvv5wYVliuGq1fbXpaG99Hz
#cd "C:\Users\20194573\OneDrive - Vilniaus Gedimino technikos universitetas\Operacinės sistemos\Atsiskaitymai\1 Namų darbas"
#cd "C:\Users\d3ivu\OneDrive - Vilniaus Gedimino technikos universitetas\Operacinės sistemos\Atsiskaitymai\1 Namų darbas"
#cd ~


Write-Host -ForegroundColor DarkGreen "`nSveiki! Tai failu valdymo programa"
$vieta = Read-Host "Iveskite pilna kelia iki darbinio katalogo"
cd $vieta
$veikia = $true
while($veikia)
{
    Write-Host "
    1 - Rodyti dabartinio katalogo/failo turini;
    2 - Sukurti nauja faila/aplanka;
    3 - Istrinti faila/aplanka;
    4 - Failo pletinio keitimas;
    5 - Palyginti failu turini;
    6 - Failu arba failu turinio sifravimas;
    7 - Failo dekodavimas;
    8 - Failo saugumo nuskenavimas;
    9 - Failo uzblokavimas/atblokavimas;
    10 - Failo atsisiuntimas;
    11 - Baigti programos darba; "
    $ans = Read-Host "`nIveskite pasirinkima"
    switch($ans) {
        1 {#rodymas
           $pasirinkimas = Read-Host "1 - Rodyti dabartinio katalogo turini;`n2 - Rodyti pasirinkto failo turini;`n" #iskaidomas pasirinkimas
           if($pasirinkimas -eq 1)#jei vartotojas pasirinko katalogo perziura
              {
              Write-Host -ForegroundColor Green "Dabartinio katalogo visas turinys: " #informacinis pranesimas
              get-childitem | Select-Object @{N='Pavadinimas';E={$_.Name}} ,@{N='Dydis';E={$_.Length}}, @{N='Sukurimo data';E={$_.CreationTime}} | format-table #saraso isvedimas, su pervadintom reiksmem
              }
            elseif($pasirinkimas -eq 2)#failo turinys
              {
              $f_pav = Read-Host "Iveskite norimo failo pavadinima:"
              $files = Get-ChildItem -Name
               if($files -match $f_pav) #tikrinama ar darbiniame kataloge egzistuoja vartotojo ivesta reiksme
                  {
                  Write-Host -ForegroundColor Green "Rodomas '$f_pav' failo turinys:`n"
                  $a=1; (get-content $f_pav*) | foreach{"{0,1} {1}" -f $a,$_;$a++}#patogumui rodoma su eiluciu numeriais
                  }
               else{ write-host -ForegroundColor Red "Tokio failo/aplanko nera!" } #informacinis pranesimas
              }
              else{Write-Host -ForegroundColor Red "Neteisingas pasirinkimas!"}
          }
        2 {#naujo failo ar aplanko sukurimas
           $pasirinkimas = Read-Host "1 - Sukurti faila;`n2 - Sukurti aplanka;`n3 - Prideti turinio i faila;`n"
           if($pasirinkimas -eq 1)#failo kurimas
              {
                $f_pav = Read-Host "Iveskite busimo failo pavadinima su galune"
                $files = Get-ChildItem -Name
                if($files -match $f_pav) {write-host -ForegroundColor Red "Toks failas jau yra sukurtas"} #tikrinimas ivedimas, si salyga bus daugelyje uzduociu
                else {
                      Write-Host -ForegroundColor Green "Failas sekmingai sukurtas!"
                      New-Item -ItemType File $f_pav
                      $tn = Read-Host "Ar noresite ka nors prideti i faila? T/N" #gal vartotojas iskart papildomai nori prideti turinio
                      if($tn -eq 'T')
                         {
                         $prideti = Read-Host "Pridekite"
                         Add-Content -Path $f_pav -Value $prideti #turinio pridejimas per masyva
                         }
                      else {break}
                    }
               }
           elseif($pasirinkimas -eq 2)#aplanko kurimas
               {
                $a_pav = Read-Host "Iveskite busimo aplanko pavadinima"
                $files = Get-ChildItem -Name
                if($files -match $a_pav) {write-host -ForegroundColor Red "Toks aplankas jau yra sukurtas"}
                else
                  {
                    Write-Host -ForegroundColor Green "Failas sekmingai sukurtas!"
                    New-Item -ItemType Directory $a_pav
                  }
               }
           elseif($pasirinkimas -eq 3)#turinio pridejimas i faila
               {
                $f_pav = Read-Host "Iveskite failo pavadinima"
                $files = Get-ChildItem -Name
                if($files -match $f_pav)
                   {
                   $prideti = Read-Host "Iveskite norima teksta"
                   Add-Content -Path $f_pav -Value $tekstas
                   }
                else {Write-Host -ForegroundColor Red "Tokio failo nera!"}
               }
            else {write-host -ForegroundColor Red "Neteisingai ivestas pasirinkimas!"}
          }
        3 {#failu/aplanku trynimas
            $pasirinkimas = Read-Host "1 - Istrinti failus/aplankus pagal varda;`n2 - Istrinti failus pagal data;`n3 - Istrinti failo turini (faila palikti);`n"
            if($pasirinkimas -eq 1)#pagal pavadinima
               {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite naikinamo failo pavadinima"
               if($files -match $f_pav)
                  {
                  Remove-Item $f_pav* #istrinamas failas, atkreiptinas demesys, jog istrinama su bet kokia galune, nes tai gali buti ir failas
                  Write-Host -ForegroundColor Green "Failas sekmingai istrintas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo/aplanko nera!" }
               }
            elseif($pasirinkimas -eq 2)#pagal data
               {
               $dienos = Read-Host "Iveskite keliu dienu senumo failus/aplankus norite istrinti"
               Get-ChildItem | where{$_.LastWriteTime -lt (get-date).adddays(-$dienos)} | #prie where tikrinimo pridedama minusine reiksme
               ForEach-Object {$_ | del -Force} #tikrinamas kiekvienas failas ir istrinama be patvirtinimo
               Write-Host -ForegroundColor Green "Failas sekmingai istrintas!"
               }
            elseif($pasirinkimas -eq 3)#failo turini
                {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite failo, kurio turini noresite istrinti pavadinima"
               if($files -match $f_pav)
                  {
                  Clear-Content $f_pav* -Confirm #nauja komanda
                  Write-Host -ForegroundColor Green "Failas turinys sekmingai istrintas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo nera!" }
                }
            else {write-host -ForegroundColor Red "Neteisingai ivestas pasirinkimas!"}

          }
        4 {#extension keitimas
          $f_pav = Read-Host "Iveskite failo pavadinima, kurio pletini noresite pakeisti"
          $files = Get-ChildItem -Name
          if($files -match $f_pav)
             {
             $e_pav = Read-Host "Iveskite pletinio pavadinima i kuri noresite pakeisti"
             $p_pav = Get-ChildItem $f_pav* | select Extension #atrenkamas dabartinio failo pletinys, kadangi replace reikalingas tik pletinys, be failo vardo
             Get-ChildItem $f_pav* | Rename-Item -NewName {$_.Name -replace $p_pav.Extension,$e_pav}
             Write-Host -ForegroundColor Green "Failo '$f_pav' pletinys sekmingai pakeistas i '$epav'"
             }
          else {Write-Host -ForegroundColor Red "Tokio failo nera!"}
          }
        5 {#failu palyginimas
          $f_pav1 = Read-Host "Iveskite pirmo lyginamo failo pavadinima"
          $f_pav2 = Read-Host "Iveskite antro lyginamo failo pavadinima"
          $files = Get-ChildItem -Name
          if(($files -match $f_pav1) -or ($files -match $f_pav2)) #tikrinama ar bent kazkuris egzistuoja
             {
             $turinys1 = Get-Content -Path $f_pav1* #isgaunamas failu turinys
             $turinys2 = Get-Content -Path $f_pav2*
             Write-Host -ForegroundColor Green "Failu turinio skirtumai: "
             Compare-Object -ReferenceObject $turinys1 -DifferenceObject $turinys2 #nauja lyginimo komanda
             #Compare-Object @objects -ExcludeDifferent neveikia kazkodel
             }
          else {Write-Host -ForegroundColor Red "Vienas is lyginamu failu nerastas!"}
          }
        6 {#kodavimas
          $pasirinkimas = Read-Host "`n1 - Failo uzsifravimas;`n2 - Failo turinio uzsifravimas;`n"
            if($pasirinkimas -eq 1)#failo sifravimas
               {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite failo pavadinima"
               if($files -match $f_pav)
                  {
                  (Get-Item -path $f_pav*).Encrypt()
                  Write-Host -ForegroundColor Green "Failas sekmingai uzsifruotas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo nera!" }
               }
            elseif($pasirinkimas -eq 2)#turinio sifravimas
               {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite failo pavadinima"
               if($files -match $f_pav)
                  {
                  $hash = (Get-FileHash $f_pav* -Algorithm MD5).hash #nauja komanda, pasirenkamas lengvesnis hash tipas, del demonstravimo 
                  Clear-Content $f_pav* #isvalomas neuzkoduotas turinys
                  Add-Content -Path $f_pav* -Value $hash #irasomas uzkoduotas turinys
                  Write-Host -ForegroundColor Green "Failo turinys sekmingai uzsifruotas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo nera!" }
               }
          }
        7 {#dekodavimas
          $f_pav = Read-Host "Iveskite failo pavadinima"
          $files = Get-ChildItem -Name
          if($files -match $f_pav)
             {
             (Get-Item -path $f_pav*).Decrypt() #gali neveikti prie kito kompiuterio, del sertifikatu
             Write-Host -ForegroundColor Green "Failas sekmingas atkoduotas!"
             }
          else {Write-Host -ForegroundColor Red "Tokio failo nera!"}
          }
        8 {#failo skenavimas
          $files = Get-ChildItem -Name
          $f_pav = Read-Host "Iveskite failo pavadinima"
          if($files -match $f_pav)
             {
             Start-MpScan -ScanType Quick -ScanPath $f_pav* #nauja komanda, skenuojama per microsoft defenderi, pasirenkamas greitas paieskos tipas del demonstravimo patogumo
             Write-Host -ForegroundColor Green "Failas nuskenuotas!"
             }
          else{ write-host -ForegroundColor Red "Tokio failo nera!" }
          }
        9 {#uzblokuoti/atblokuoti
            $pasirinkimas = Read-Host "`n1 - Failo uzblokavimas;`n2 - Failo atblokavimas;`n"
            if($pasirinkimas -eq 1)#failo uzblokavimas
               {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite failo pavadinima"
               if($files -match $f_pav)
                  {
                  $data = "[ZoneTransfer]
                          ZoneId=3" #irasomas id i masyva del patogumo
                  Set-Content $f_pav* -Stream "Zone.Identifier" -Value $data #pakeiciamas failo saugumo lygmuo
                  Write-Host -ForegroundColor Green "Failas sekmingai uzblokuotas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo nera!" }
               }
            elseif($pasirinkimas -eq 2)#atblokavimas
               {
               $files = Get-ChildItem -Name
               $f_pav = Read-Host "Iveskite failo pavadinima"
               if($files -match $f_pav)
                  {
                  Unblock-File -Path $f_pav* -Confirm #nauja komanda, pries atblokuojant butinai paklausiam ar tikrai vartotojas to nori
                  Write-Host -ForegroundColor Green "Failas sekmingai atblokuotas!"
                  }
               else{ write-host -ForegroundColor Red "Tokio failo nera!" }
               }
          }
        10 {#failo atsisiuntimas
           $nuoroda = Read-Host "Iveskite atsisiuntimo nuoroda"
           Invoke-WebRequest -Uri $nuoroda -OutFile failas.zip #pasirenkame zipa del saugumo, nes galime netycia exe faila konvertuoti i txt ir pns
           Expand-Archive -Path failas.zip -DestinationPath .\ #isarchyvuojam
           Write-Host -ForegroundColor Green "Failas sekmingas atsiustas ir isarchyvuotas!"
           }
        11 {$veikia = $false} #jeigu vartotojas nusprendzia baigti programos darba, tai pakeiciama while veikimo salyga

        default {Write-Host -ForegroundColor Red "`nBlogas pasirinkimas!`n"} #jeigu vartotojo ivedamas pasirinkimas neatitinka 1-11
        }
}
