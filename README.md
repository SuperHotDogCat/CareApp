# CareApp

solution challenge 2024 product

## iOS でのシミュレーション方法

### iOS のシミュレータを起動する

VSCode の右下にあるデバイス指定の欄をクリックして「Select a device to use」と表示されたら、その中から「Start iPhone xx」を選択する。

これで立ち上がらない場合は、Xcode を開いて、ツールバーから「Xcode」→「Open Developer Tool」→「Simulator」を選択する。

### cocoapods の確認

cocoapods のバージョンを確認

```sh
$pod --version
```

これで 1.15.2 くらいが出てくれば最新なはず、最新じゃなかったら以下のコマンドでアップデートする

```sh
$sudo gem uninstall cocoapods
$bew install cocoapods
```

### ファイルの整理

```zsh
$cd app
$flutter clean
$flutter pub get
$cd ios
$rm Podfile
$rm Podfile.lock
$pod install
```

このあと XCode を立ち上げて、このサイトの手順 2 に従ってパッケージの依存関係をなくす。（2 だけ）
[ipyleaflet.readthedocs.io/en/latest/layers/divicon.html](https://stackoverflow.com/questions/70760326/flutter-on-ios-redefinition-of-module-firebase)

その後、XCode 上で、Product -> Run を選択すると動いた。
