# Conservation Mode Toggle

A simple Flutter desktop application for Linux that toggles battery Conservation Mode on Lenovo IdeaPad Gaming 3 15ACH6.

## Overview

This project provides a minimal, user-friendly interface for enabling or disabling Lenovo Conservation Mode.

Conservation Mode helps extend battery lifespan by limiting maximum charge (commonly to around 80%).

## Features

- Clean, simple UI with an iOS-style green Cupertino toggle
- Reads current conservation mode state from sysfs
- Switches between mode values `0` and `1`
- Manual refresh button for state sync
- Uses `pkexec` to request elevated privileges when writing system values

## Device and Platform

- Target device: Lenovo IdeaPad Gaming 3 15ACH6
- Platform: Linux
- UI framework: Flutter (Linux desktop)

## How It Works

The app reads and writes the following sysfs node:

```text
/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

- `1` = Conservation Mode enabled
- `0` = Conservation Mode disabled

## Requirements

- Flutter SDK installed and configured for Linux desktop
- Linux environment with `ideapad_acpi` conservation mode support
- `pkexec` available (usually provided by PolicyKit)

## Run in Development

```bash
flutter pub get
flutter run -d linux
```

## Build Release

```bash
flutter build linux --release
```

Release bundle output:

```text
build/linux/x64/release/bundle/
```

## Security and Permissions

Writing to sysfs requires root privileges. The app uses `pkexec` so the user is prompted for authentication only when needed.

## Disclaimer

This is a simple utility created specifically for Lenovo IdeaPad Gaming 3 15ACH6 on Linux. Behavior may differ on other Lenovo models or kernel/driver versions.
