# mecab-service-ruby

## What's this?

Ruby + MeCab (natto) + win32-service

## Install

64bit 版の Ruby もしくは JRuby を使う場合は MeCab のビルドが必要かもしれません。
詳細は natto の [Installation on Windows](https://github.com/buruzaemon/natto#installation-on-windows) を参照してください。

gem のインストール

```
>gem install natto win32-service
```

`C:\mecab` などの適当な場所に natto-mecab-service.rb を配置し、エディタで開いて辞書のパスやポート番号等を修正します。

サービスの作成（管理者権限のコマンドプロンプト）

```
>sc create MeCabService binPath= "C:\Ruby26-x64\bin\rubyw.exe -C C:\mecab natto-mecab-service.rb"

```

## License

MIT

## Copyright

Copyright &copy; 2019 Yukihiro ITO.
