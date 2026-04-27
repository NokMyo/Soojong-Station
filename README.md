# Soojong Station

This repository is used as the public release channel for Soojong Station.

The source code is maintained in the development repository. This repository only publishes runtime release files for Raspberry Pi 4 / DietPi ARM64 devices.

## Download

Use the latest ARM64 runtime package from Releases:

```text
soojong-station-arm64.tar.gz
```

Versioned files such as the following are kept for archive purposes:

```text
soojong-station-v0.5.1-arm64.tar.gz
```

Files ending with `.sha256` are checksum files for verifying downloads.

## Install on DietPi / Raspberry Pi 4

```bash
cd ~
curl -L -o soojong-station-arm64.tar.gz https://github.com/NokMyo/Soojong-Station/releases/latest/download/soojong-station-arm64.tar.gz
tar -xzf soojong-station-arm64.tar.gz
mv soojong-station-*-arm64 soojong-station
cd soojong-station
sudo STATION_DEPS_MODE=device sh scripts/install-pak.sh
STATION_VIDEO_MODE=kmsdrm sh scripts/run.sh
```

## Update

After the first install:

```bash
cd ~/soojong-station
sh scripts/update.sh
```
