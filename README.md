# Soojong Station

This repository is used as the public release channel for Soojong Station.

The source code is maintained in the development repository. This repository publishes runtime release files for Raspberry Pi 4 / DietPi ARM64 devices.

## One-line install

On DietPi / Raspberry Pi 4:

```bash
curl -fsSL https://raw.githubusercontent.com/NokMyo/Soojong-Station/main/install.sh | sh
```

The installer downloads the latest ARM64 release, installs it to `~/soojong-station`, installs required packages, and prints run/autostart/update commands.

## Manual install

```bash
cd ~
curl -L -o soojong-station-arm64.tar.gz https://github.com/NokMyo/Soojong-Station/releases/latest/download/soojong-station-arm64.tar.gz
tar -xzf soojong-station-arm64.tar.gz
mv soojong-station-*-arm64 soojong-station
cd soojong-station
sudo STATION_DEPS_MODE=device sh scripts/install-pak.sh
sh scripts/run.sh
```

## Run

```bash
cd ~/soojong-station
sh scripts/run.sh
```

`run.sh` defaults to KMSDRM mode for DietPi console use. For Ubuntu Desktop testing, run:

```bash
STATION_VIDEO_MODE=desktop sh scripts/run.sh
```

## Enable autostart

```bash
cd ~/soojong-station
sudo sh scripts/station-autostart.sh enable
```

## Update

After the first install:

```bash
cd ~/soojong-station
sh scripts/update.sh
```

## Release files

Use the latest ARM64 runtime package from Releases:

```text
soojong-station-arm64.tar.gz
```

Versioned files such as the following are kept for archive purposes:

```text
soojong-station-v0.5.1-arm64.tar.gz
```

Files ending with `.sha256` are checksum files for verifying downloads.
