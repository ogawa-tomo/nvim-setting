# 💤 LazyVimによるNeovim環境構築

LazyVimによるNeovim環境構築設定ファイルです。

## 手順
LazyVimをインストール
https://www.lazyvim.org/installation

Neovim設定をバックアップ
```
mv ~/.config/nvim ~/.config/nvim.bak
```

適当な場所にリポジトリをクローン
```
cd ~/dotfiles
git clone git@github.com:ogawa-tomo/nvim-setting.git
```
シンボリックリンクを貼る
```
 ln -s ~/dotfiles/nvim-setting ~/.config/nvim
```

## 操作

設定ファイルがある場所
~/.config/nvim

### ウィンドウ操作
ウィンドウを2つに割る
```
:vs
```

カーソルを隣のウィンドウに移動
```
ctrl + h/j/k/l
```


いまいるウィンドウでバッファを開く
`:b` でバッファを選択
または、`space + ,`でバッファを選択

ウィンドウを閉じる
```
:q
```

開いているバッファを閉じる
```
space + bd
```

ファイルツリーの開閉
```
space + e
```

ウィンドウサイズの変更
```
ctrl + e
```
のあと、hjkl

すべてを終了してneovimを閉じる
```
:qa
```

### ターミナル操作
ターミナルを開いたり閉じたりする（ターミナルが存在しなければ1つ目を開く）
```
space + t
```

2つ目のターミナルを開いたり閉じたりする
```
2 + space + t
```
（3つ目以降も同様）
（閉じても終了したわけでなく、もう1度開けば復活する）

いまいるターミナルを閉じる
```
:q
```
（閉じるだけで、もう一度開けばまた復活する）

