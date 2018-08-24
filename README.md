# aiotg3_azure_handson
armadillo IoT G3 + Azureのハンズオン資料です

rootユーザーで作業します．シリアル接続の場合は，rootでログイン可能です．
sshによる接続の場合は，atmarkユーザーでログイン後 `sudo su` コマンドでrootユーザーになります．

## Armadillo-IoT G3をWiFiへ接続

`nmcli`コマンドを使いWiFiへ接続します．

```
nmcli device wifi connect [ssid] password [PASSWORD]
```


## Mobyのインストール

本ハンズオンでは，導入済みのDockerイメージを利用します．そのためDocker環境をインストールします．※ハンズオン環境では既に導入済みです．

[Mobyインストール方法](install_moby.md)

## TI CC2650センサータグのペアリング

Armadillo-IoT G3とSensor Tagのペアリングを行います．

#### 0.シェル上で以下を実行
```
root@armadillo:~# rfkill unblock bluetooth
```
※`rfkill unblock bluetooth`は、 Armadillo-IoT G3の電源On時に必ず一度実行します．

#### 1.`bluetoothctl`コマンドを入力し，ユーティリティを実行します．
```
root@armadillo:~# bluetoothctl
```

#### 2.`version`と入力し，バージョンが`5.37`と表示されていることを確認します．
```
[bluetooth]# version
Version 5.37
```

Versionが異なる場合は，version 5.37をインストールします．

- [Bluezインストール方法](install_bluez.md)

#### 3.`power on` と入力します．

```
[bluetooth]# power on
Changing power on succeeded
```

#### 4.`scan on`と入力し，スキャンを開始します．
```
[bluetooth]# scan on
```
スキャンが開始され．．．
```
Discovery started
[NEW] Device AA:BB:CC:DD:EE:FF CC2650 SensorTag
```

#### 5.SensorTagが表示されたら，`scan off`コマンドを入力します．
```
[bluetooth]# scan off 
```
センサータグのMAC Addressの`AA:BB:CC:DD:EE:FF`をメモしておきます．

#### 6.センサータグとペアリングします．(AA:BB:CC:DD:EE:FFはスキャン中に表示された、SensorTagのMAC Address)
```
[bluetooth]# connect AA:BB:CC:DD:EE:FF
```
`Connection successful`と表示されたらペアリング完了
```
Connection successful
[CC2650 SensorTag]#
```

#### 7.`quit`と入力しユーティリティを終了します．
```
[bluetooth]# quit
```


## ハンズオン用のGatewayアプリケーションイメージを取得

[Azure IoT Edge v1](https://github.com/Azure/iot-edge) に [Sample Extension of Azure IoT Edge(Gateway) SDK](https://github.com/ms-iotkithol-jp/AzureIoTGatewaySDKExtention)を適用したBLE Gatewayサンプルのビルド済みイメージを用意しました．

[Docker Hubサイト](https://hub.docker.com/)から以下のコマンドでイメージを取得します．

```
docker pull ngi644/azedge-ble-aiotg3-armv7hf
```

※イメージの作成方法については，[こちら](https://github.com/ngi644/iotedge/tree/aiotg3_stretch/edge-modules/ble)を参照してください．


## サンプルアプリケーション起動用スクリプト類の取得

Gatewayアプリケーションイメージを起動するためのスクリプトやセンサータグとIoT Hubデバイスとのマッピング等を行うjsonファイルを取得します．

```
git clone https://github.com/ngi644/aiotg3_azure_handson.git
```

ディレクトリに移動します．
```
cd aiotg3_azure_handson
```

## jsonファイルの修正

`gateway_filter_cc2650.json`のファイルを編集します．

- 11行目 `<<IoT Hub Name>>`をIoT Hub名に置き換えます．
    ```
    "IoTHubName": "<<IoT Hub Name>>",
    ```

- 33,53,78行目の `<<Sensor Tag MAC ADDRESS - AA:BB:CC:DD:EE:FF>>` をペアリングしたセンサータグのMAC Addressに置き換えます．

    33行目
    ```
    "sensor-tag": "<<Sensor Tag MAC ADDRESS - AA:BB:CC:DD:EE:FF>>",
    ```

    53行目
    ```
    "macAddress": "<<Sensor Tag MAC ADDRESS - AA:BB:CC:DD:EE:FF>>",
    ```

    78行目
    ```
    "device_mac_address": "<<Sensor Tag MAC ADDRESS - AA:BB:CC:DD:EE:FF>>",
    ```

- 54行目の`<<Device ID for IoT Hub>>` をデバイスIDに置き換えます．

    ```
    "deviceId": "<<Device ID for IoT Hub>>",
    ```

- 55行目の`<<Device Key>>`をデバイスIDのプライマリキーに置き換えます．

    ```
    "deviceKey": "<<Device Key>>"
    ``` 


## Gatewayアプリケーションのイメージを起動

`aiotg3_ble_docker_run.sh`に実行権限をつけます．

```
chmod +x aiotg3_ble_docker_run.sh
```

`aiotg3_ble_docker_run.sh`を実行してBLE Gatewayアプリケーションを起動します

```
./aiotg3_ble_docker_run.sh --registry ngi644 --ble_config_file gateway_filter_cc2650.json
```


## データの確認

 [device explorer](https://github.com/Azure/azure-iot-sdk-csharp/tree/master/tools/DeviceExplorer) や [iothub-explorer](https://github.com/Azure/iothub-explorer) ツールを使って確認を行います



