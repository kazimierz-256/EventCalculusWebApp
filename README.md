# Event Calculus Web App

Knowledge representation and reasoning logic documentation (written in polish):

[Event Calculus Documentation](../master/EventCalculusDocumentation.pdf)
___

## Folder z treścią
Część frontowa i backendowa znajduje się w folderze `apps/concurrent`.

## Uruchomienie serwera
`swipl run.pl`
Login i hasło podałem na slacku  
Otwieramy w przeglądarce http://localhost:3030/

## Uruchomienie testów
`swipl apps/concurrent/test/all_tests.pl`

## Tworzenie Pull Requestów itp
Do każdego feature'a/ poprawki tworzymy osobnego branch'a.
Jak wasz branch jest gotowy do mergowania z masterem to robimy tak:

1. `git checkout branchname`
2. `git merge master` albo `git rebase master`, w zaleznosci od preferencji
3. sprawdź, czy na pewno wszystkie testy przechodzą poprzez wywołanie `swipl apps/concurrent/test/all_tests.pl`
4. `git push origin branchname`
5. stwórz PR
6. obejrz dokladnie wsystkie zmiany => czy to jest dokladnie to co chcesz zmienić?
8. popros o review innej osoby
9. poczekaj na `approve`
10. możesz zrobic `merge`.

## Docelowy styl kodowania:
https://arxiv.org/pdf/0911.2899.pdf
