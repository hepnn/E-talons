
Scanning [E-talons](https://www.rigassatiksme.lv/lv/biletes/e-talonu-veidi/dzeltenais-e-talons/), used by [Rigas satiksme](https://www.rigassatiksme.lv/lv/), processing the hex data. 

UI done in Flutter, functions in Kotlin (root/android/app/src/main/kotlin/) using method channels

## About

There are people already that have deciphered the hex data and there exists an app for this. I did this solely because none of the available apps are open source or with any documentation. Might have wasted my time on this, but hv a look. By the way, there are still two things I couldn't find in the hex data - 1. stop name 2. purchase date of e-talons 

## The technical side
Read my blog about it here: [hepn.me](https://hepn.me/2023/03/17/etalons-and-its-insides)

- The E-talons uses [Mifare Ultralight](https://www.nxp.com/docs/en/data-sheet/MF0ICU2.pdf) which uses 64 bytes (16*4)
- The hex data contains these following things:
  - Cards UID
  - Amount of initial tickets on card
  - Amount of remaining tickets
  - Date of ticket purchase
  - Two past rides which both include: 
    - Transport type
    - Time and date of scan
    - Direction of ride (stop name) 
    - Bus number
    - Whether the ticket has been checked by an inspector

<img align="center" width="250" height="500" src="https://i.imgur.com/wRitqLO.png">

## The App

- Dynamic theme (Riverpod)
- Hive for local storage of history
- Firebase Analytics & Crashlytics
- Logging
- The manipulation with hex is done in Kotlin n then sent to Flutter

      
## Screenshots

<img align="center" width="250" height="500" src="https://i.imgur.com/AczYDO0.jpg">
<img align="center" width="250" height="500" src="https://i.imgur.com/0vqXkPA.jpg">
<img align="center" width="250" height="500" src="https://i.imgur.com/pAReFhQ.jpg">


## Setup

Feel free to remove any firebase related code as nothing will break without it.

You will wanna run `flutter packages pub run build_runner build --delete-conflicting-outputs`



