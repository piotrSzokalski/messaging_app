# messaging_app

Aplikacja do wysyłania i odczytywania wiadomości na Androida na zajęcia 'Wprowadzenie do programowania plikacji moblicych - projekt'

## Potrzebne oprogramowaie
- Flutter
- Android sdk

## Intlacja, uruchomienie

### Aplikacja korzysta z firesbase, wymaga połączenia z internetem

1. Otworzenie lokalizacji projektu w konsoli
4. ```fluttter build apk```
5. ```flutter install <nazwa urządzenia>``` urządzenie musi być podłączone

Można urzyć również komędy ```flutter run <nazwa urządzenia>```

## Instrukcja urzycia aplikacji

### Aplikajca wymala od urzytkowania zalogowana się

![Screenshot_2023-09-18-07-10-37-17_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/c1495469-ee1f-4abf-84de-19114d47453a)

### Nowyi urzytkownicy będoą musieli zarejstrować się do seriwsu podświetlonego na niebiesko tekstu 'Sing up'

![Screenshot_2023-09-18-07-11-06-06_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/360a4cbd-89e6-43b3-be70-a551b3d4bc72)

### W celu rejestracji należy podać:
- Nazwe urzytkowani
- Adres email w poprawnym formiace, nie musi być to prawdiy emial, ale jest on wykorzystywany do odyskania chasł więc podanie nie prawidłowefo adresu, unimożliwi zmiane hasła
- Hasło minimum 6 znaków

Po rejstracji lub logowaniu urzytkowni przeniesiony jest do ekrau wybour kanałów
![Screenshot_2023-09-18-07-13-51-15_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/29f083d8-e720-40c9-b287-fdbcb8015461)

![Screenshot_2023-09-18-07-12-45-79_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/4f955eef-b558-4824-a498-ae944cf20879)

### Z tąd moźa przeglądać, otworzyć kanal, storzyć kanał lub wylogować się

### Kanały mogoą być zablokowane hasłem, any zablokować kanał hasłem nazleży wybrać opcej zabezpieczeani haśłem 'secure passwrd' przy torzeniu kanału i podać hasło

![Screenshot_2023-09-18-07-14-11-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/8836ab7c-7420-479c-a38c-5cff32a92231)

### W celu otorzenia kanłu zablokowanego hałem należy je podać, chyba że jest się urzytkonikme który storzył ten kanał

![Screenshot_2023-09-18-07-12-57-91_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/fe033f6d-f569-4114-bbcd-2c4be77ef1bd)

### Po otworzeniu kanłu wyświtli się lista widości, w kolejności od najdowszej na szczycie do najstarszej na dnie, stsze wiadomścli ładują się po scolowniu do dna
### Wiadomość może zawierać tekst i zdjęcia, przy czym zdięcia mogą się ładować przez jakiś czas

![Screenshot_2023-09-18-14-06-06-36_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/61e96988-3253-4dac-aa12-ab6bc88ce4eb)
### Po dotkniżiu zdięcia można je powiększyć

![Screenshot_2023-09-18-14-06-10-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/002d21f7-e7f8-4d1a-ad24-38d6d70083e9)

### Na dole interfejus zadjue się pole do wprowadzani textu nowych wiadomości, po dotkniusi można wrowadzać tekst, są również dwie ikony pozaljące na doanie zdięcia z apratu lub galeri

![Screenshot_2023-09-18-07-14-11-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/186c14dc-2471-4dcd-a4db-9b7d8a121ef5)

![Screenshot_2023-09-18-14-06-06-36_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/96ca2709-a2d9-48b2-8700-e180d006ca81)

### Po dotnięci strzałki wiadomość zostanie wysłan, jeżeli zwiera zdięcia może to zająć chwile, po czym powwina pojawić się na szczycie wiamoaścli 

![Screenshot_2023-09-18-14-06-10-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/8e793e81-fda3-4881-b312-853edd0ee0cb)

## Problemu

Jeżli aplikacja nie dział jak opisano możlie że są problemy z połącznie do sieci lub (co zdarzył się raz przy testoaniu) serwisami firbase, w tym przypadku powwinyzniknąć w przciągu kilku godzin

