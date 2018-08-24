# Bluezのインストール

本ハンズオンのサンプルプログラムは，Bluezのバージョンが5.37である必要があります．

- 参考
    - https://github.com/Azure/iot-edge-v1/blob/master/v1/samples/ble_gateway/iot-hub-iot-edge-physical-device.md#install-bluez-537


## Bluetoohデーモンを停止

```
systemctl stop bluetooth
```

## 依存モジュールのインストール
```
apt-get install bluetooth bluez-tools build-essential autoconf glib2.0 libglib2.0-dev libdbus-1-dev libudev-dev libical-dev libreadline-dev
```

## BlueZ 5.37のソースコードをダウンロード

```
wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.37.tar.xz
```

##  解凍します
```
tar xvf bluez-5.37.tar.xz 
```

## ソースコードのディレクトリに移動します
```
cd bluez-5.37/
```

## BlueZコードをコンフィグします．
```
./configure --disable-udev --disable-systemd --enable-experimental
```

## BlueZをビルドします．
```
make
```

## Bluezをインストールします
```
make install
```

## Bluetoohのシステムサービスファイルを修正します．

`/lib/systemd/system/bluetooth.service`ファイルの、`ExecStart`の行を以下で置き換えます
```
ExecStart=/usr/local/libexec/bluetooth/bluetoothd -E
```

## Armadillo-IoT G3を再起動します

```
reboot
```

## バージョンを確認します

```
bluetoothctl --version
```
