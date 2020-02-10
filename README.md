# テスト駆動開発から始めるRuby入門

## 概要

## 前提

| ソフトウェア   | バージョン | 備考 |
| :------------- | :--------- | :--- |
| ruby         | 2.5.5     |      |

### Quick Start

#### クラウドIDE使用の場合

##### 以下のリンクからクラウドIDEを起動する

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/hiroshima-arc/tdd_rb/tree/episode-3)


##### IDEが起動したら コマンドラインで以下のコマンドを入力します。

```bash
$ bundle install
```

#### 仮想マシン使用の場合

```bash
$ vagrant up
$ vagrant ssh
$ cd /vagrant
```

シンボルリンクを作成してデバッガを使えるようにする

```bash
gem install ruby-debug-ide
gem install debase
gem install rubocop
gem install rcodetools
sudo ln -s ~/.rbenv/shims/rdebug-ide /usr/local/bin/
sudo ln -s ~/.rbenv/shims/rubocop /usr/local/bin/
sudo ln -s ~/.rbenv/shims/rct-complete /usr/local/bin/
```

Node.jsをインストールする

```bash
nvm install --lts
node -v
```

開発の進め方は [テスト駆動開発から始めるRuby入門 Qiita](https://qiita.com/k2works/items/928d519a7afe99361ff2) に沿って進めてください。
