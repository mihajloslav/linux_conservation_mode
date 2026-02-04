# Conservation Mode Toggle

Flutter aplikacija za Linux koja omogućava upravljanje battery conservation modom na Lenovo laptopovima.

## Opis

Ova aplikacija omogućava jednostavno uključivanje i isključivanje conservation moda koji ograničava punjenje baterije na 80% radi produženja njenog veka trajanja.

## Funkcionalnosti

- Zeleni Cupertino toggle dugme (Apple stil)
- Automatsko čitanje trenutnog statusa conservation moda
- Uključivanje/isključivanje conservation moda
- Refresh dugme za ažuriranje statusa
- Koristi `pkexec` za root privilegije (ne zahteva direktan sudo)

## Zahtevi

- Flutter SDK
- Linux (testiran na Ubuntu/Debian baziranim distribucijama)
- Lenovo laptop sa podrškom za conservation mode
- `pkexec` (obično već instaliran kao deo PolicyKit)

## Instalacija

1. Klonirati repozitorijum:
```bash
git clone <repo-url>
cd linux_conservation_mode
```

2. Instalirajte zavisnosti:
```bash
flutter pub get
```

3. Pokrenite aplikaciju:
```bash
flutter run -d linux
```

## Kako radi

Aplikacija čita i piše u:
```
/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

- `1` = conservation mode uključen (maksimalno punjenje 80%)
- `0` = conservation mode isključen (punjenje do 100%)

## Napomena o privilegijama

Aplikacija koristi `pkexec` umesto direktnog `sudo` komande. Kada kliknete na toggle, pojaviće se dijalog za autentifikaciju koji traži vašu lozinku.

## Build za produkciju

```bash
flutter build linux --release
```

Izvršni fajl će biti u: `build/linux/x64/release/bundle/`
