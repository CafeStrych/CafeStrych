# Domowy Plan
Gotowa statyczna aplikacja z Supabase Auth, wspólnym grafikiem, rezerwacjami, listą zakupów, rolami admin/user i RLS.

## Instalacja
1. Załóż osobny e-mail administracyjny. Włącz MFA i zapisz kody odzyskiwania poza komputerem.
2. Załóż nowe konto GitHub i Supabase na ten e-mail. Na obu włącz MFA. Nie udostępniaj hasła.
3. W Supabase utwórz projekt Free. Zapisz hasło bazy w menedżerze haseł.
4. Otwórz SQL Editor, utwórz zapytanie, wklej `supabase/schema.sql` i wybierz Run.
5. Otwórz Authentication > Users > Add user. Utwórz konto Kuby i zaznacz automatyczne potwierdzenie e-maila, jeśli panel pokazuje taką opcję.
6. W Table Editor > profiles znajdź konto Kuby i ustaw `role` na `admin` oraz popraw `full_name`. Alternatywnie uruchom ostatnie polecenie z `schema.sql` po wpisaniu e-maila.
7. W Project Settings > API skopiuj Project URL oraz publiczny anon/publishable key. Nigdy nie kopiuj service_role/secret key do aplikacji.
8. Otwórz `config.js`, wklej URL i anon key zamiast dwóch wartości `WPISZ_...`.
9. W Supabase Authentication > URL Configuration ustaw Site URL na adres GitHub Pages aplikacji, np. `https://NAZWA.github.io/domowy-plan/`. Dodaj ten sam adres do Redirect URLs.
10. W GitHub utwórz nowe publiczne repozytorium `domowy-plan`. Wgraj zawartość folderu aplikacji, nie sam folder nadrzędny.
11. W repozytorium wybierz Settings > Pages > Deploy from a branch > `main` > `/ (root)` > Save.
12. Po publikacji otwórz stronę i zaloguj się kontem Kuby.
13. Kolejnych użytkowników twórz w Supabase Authentication > Users > Add user. Ich profil zostanie utworzony automatycznie z rolą `user`.

## Kontrola bezpieczeństwa
- `service_role`, secret key i hasło bazy nigdy nie trafiają do GitHub ani `config.js`.
- Publiczny anon/publishable key może znajdować się w froncie, bo dostęp chronią logowanie i RLS.
- Repozytorium GitHub Pages Free jest publiczne. Nie umieszczaj w nim danych użytkowników, eksportów ani sekretów.
- Co miesiąc eksportuj ważne dane i sprawdzaj listę użytkowników.
- Usuń konto natychmiast, gdy ktoś nie powinien już mieć dostępu.
- Darmowy projekt może mieć ograniczenia i może nie być odpowiedni jako docelowe środowisko komercyjne. Przed realnym gromadzeniem danych przygotuj politykę prywatności, procedurę kopii i ocenę zgodności.

## Pliki
- `index.html` interfejs
- `assets/app.js` logika i Supabase
- `assets/style.css` wygląd
- `config.js` konfiguracja projektu
- `supabase/schema.sql` baza, role i RLS
- `manifest.webmanifest` instalacja jako aplikacja
