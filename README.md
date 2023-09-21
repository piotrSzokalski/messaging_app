# messaging_app

Aplikacja do wysyłania i odczytywania wiadomości na Androida na zajęcia 'Wprowadzenie do programowania aplikacji mobilnych - projekt'

# Potrzebne oprogramowane
- Flutter
- Android sdk

# Instrukcja, uruchomienie

## Aplikacja korzysta z firesbase, wymaga połączenia z internetem

1. Otworzenie lokalizacji projektu w konsoli
4. ```fluttter build apk```
5. ```flutter install <nazwa urządzenia>``` urządzenie musi być podłączone

Można użyć również komedy ```flutter run <nazwa urządzenia>```

# Instrukcja uzycia aplikacji

## Aplikacja wydala od uzytkowania zalogowana się


</br>

![Screenshot_2023-09-18-07-10-37-17_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/c1495469-ee1f-4abf-84de-19114d47453a)

</br>

## Nowi uzytkownicy będą musieli zarejestrować się do serwisu podświetlonego na niebiesko tekstu 'Sing up'



</br>
![Screenshot_2023-09-18-07-11-06-06_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/360a4cbd-89e6-43b3-be70-a551b3d4bc72)
</br>

</br>

## W celu rejestracji należy podać:
- Nazwe uzytkownika
- Adres email w poprawnym formice, nie musi być to prawdy email, ale jest on wykorzystywany do odzyskania hasła więc podanie nie prawidłowego adresu, uniemożliwi zmiane hasła
- Hasło minimum 6 znaków

## Po rejestracji lub logowaniu uzytkownik przeniesiony jest do ekran wyboru kanałów

</br>

![Screenshot_2023-09-18-07-12-45-79_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/4f955eef-b558-4824-a498-ae944cf20879)

![Screenshot_2023-09-18-07-13-51-15_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/29f083d8-e720-40c9-b287-fdbcb8015461)

</br>

## Z tąd może przeglądać, otworzyć kanał, stoczyć kanał lub wylogować się

## Kanały mooga być zablokowane hasłem, any zablokować kanał hasłem należy wybrać opcje zabezpieczani hasłem 'secure with password' przy tworzeniu kanału i podać hasło

</br>

![Screenshot_2023-09-18-07-14-11-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/8836ab7c-7420-479c-a38c-5cff32a92231)

</br>

## W celu utworzenia kanału zablokowanego hasłem należy je podać, chyba że jest się uzytkownikiem który stworzył ten kanał

</br>

![Screenshot_2023-09-18-07-12-57-91_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/fe033f6d-f569-4114-bbcd-2c4be77ef1bd)

</br>

## Po otworzeniu kału wyświetli się lista widoki, w kolejności od najnowszej na szczycie do najstarszej na dnie, starsze wiadomości ładują się po scrolowaniu do dna


## Wiadomość może zawierać tekst i zdjęcia, przy czym zięcia mogą się ładować przez jakiś czas

</br>

![Screenshot_2023-09-18-14-06-06-36_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/61e96988-3253-4dac-aa12-ab6bc88ce4eb)

</br>

## Po dotknieciu zięcia można je powiększyć

</br>

![Screenshot_2023-09-18-14-06-10-30_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/002d21f7-e7f8-4d1a-ad24-38d6d70083e9)

</br>

## Na dole interfejsu zadjue się pole do wprowadzani tekstu nowych wiadomości, po dotknięciu można wprowadzać tekst, są również dwie ikony pozwalające na dodanie zięcia z apretu lub galerii

</br>

![Screenshot_2023-09-20-07-33-07-46_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/79c79264-1d42-4b14-a9bc-77e5743f6f53)

![Screenshot_2023-09-20-07-32-04-41_5734e8eb49b4234b62f913f831715b0f](https://github.com/piotrSzokalski/messaging_app/assets/101019797/69c4b933-0810-4988-a9e3-e2c0983c2729)

</br>

## Po dotnięci strzałki wiadomość zostanie wysłan, jeżeli zwiera zdięcia może to zająć chwile, po czym powwina pojawić się na szczycie wiamoaścli 
</br>

![Screenshot_2023-09-20-07-35-41-77_f50fd8f2266ac0141bc0c1d96454d785](https://github.com/piotrSzokalski/messaging_app/assets/101019797/bde81bfd-ac4a-44c7-9708-0d116aebf1ac)

</br>


# Problemy

Jeli aplikacja nie dział jak opisano możliwe że są problemy z połączeniem do sieci lub (co zdarzył się raz przy testowaniu) serwisami firbase, w tym przypadku powinny zniknąć w przeciągu kilku godzin

