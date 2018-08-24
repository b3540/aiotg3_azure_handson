# Mobyのインストール

## 作業用ディレクトリの作成

```
root@armadillo:~# mkdir tmp
root@armadillo:~# cd tmp/
```

## Mobyをダウンロードしてインストール

### moby-engine
```
curl -L https://aka.ms/moby-engine-armhf-latest -o moby_engine.deb
dpkg -i ./moby_engine.deb
```

### moby-cli
```
curl -L https://aka.ms/moby-cli-armhf-latest -o moby_cli.deb
dpkg -i ./moby_cli.deb
```

### apt-get の実行
```
sudo apt-get install -f
```
