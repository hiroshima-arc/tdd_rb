これはとあるプログラマがどのような思考を経てテスト駆動開発でアプリケーションを構築していったかを解説した内容である。隣りに座って話を聞きながらコードを追いかけているイメージで読み進めてみてださい。

# エピソード1

## 初めに

この記事は一応、Ruby入門者向けの記事ですが同時にテスト駆動開発入門者向けともなっています。

対象レベルによって以下のように読み進められれば効率が良いかと思います。

- Ruby入門者でプログラミング初心者・・・とりあえずコードの部分だけを写経しましょう。解説文は最初のうちは何言ってるかわからないと思うので5回ぐらい写経してRubyを書く感覚がつかめてきてから読み直すといいでしょう。もっと知りたくなったら参考図書にあたってください。と言っても結構お高いので「リーダブルコード」と「かんたんRuby（プログラミングの教科書）」といった初心者向け言語入門書から買い揃えるのがおすすめです。

- Ruby経験者でテスト駆動開発初心者・・・コード部分を写経しながら解説文を読み進めていきましょう。短いステップでテスト駆動のリズムが感覚がイメージしていただければ幸いです。もっと知りたくなったら原著の「テスト駆動開発」にあたってくださいオリジナルはJavaですがRubyで実装してみると多くの学びがあると思います。あと、「プロを目指す人のためのRuby入門」が対象読者に当たると思います。

- 他の言語経験者でテスト駆動開発初心者・・・コード部分を自分が使っている言語に置き換えながら解説文を読み進めていきましょう。もっと知りたくなったら原著の「テスト駆動開発」にあたってくださいオリジナルはJavaとPythonが使われています。あと、「リファクタリング」は初版がJavaで第２版がJavaScriptで解説されています。

- 言語もテスト駆動開発もつよつよな人・・・レビューお待ちしております（笑）。オブジェクト指向に関する言及が無いというツッコミですが追加仕様編でそのあたりの解説をする予定です。あと、「リファクタリング」にはRubyエディションもあるのですが日本語訳が絶版となっているので参考からは外しています。

写経するのに環境構築ができない・面倒なひとは[こちら](https://github.com/hiroshima-arc/tdd_rb)でお手軽に始めることができます。

あと、初心者の方で黒い画面でちまちまやっててナウいアプリケーションなんて作れるの？と思う人もいると思いますが最終的には[こんなアプリケーション](https://tddrb.k2works.now.sh/)になります。流石にフロントエンドはRubyではありませんがバックエンドはRubyのサーバレスアプリケーションで構成されているので少しはナウいやつだと思います。


## TODOリストから始めるテスト駆動開発

### TODOリスト

プログラムを作成するにあたってまず何をすればよいだろうか？私は、まず仕様の確認をして **TODOリスト** を作るところから始めます。

> TODOリスト
> 
> 何をテストすべきだろうか----着手する前に、必要になりそうなテストをリストに書き出しておこう。
> 
> —  テスト駆動開発 

仕様

    1 から 100 までの数をプリントするプログラムを書け。
    ただし 3 の倍数のときは数の代わりに｢Fizz｣と、5 の倍数のときは｢Buzz｣とプリントし、
    3 と 5 両方の倍数の場合には｢FizzBuzz｣とプリントすること。

仕様の内容をそのままプログラムに落とし込むには少しサイズが大きいようですね。なので最初の作業は仕様を **TODOリスト** に分解する作業から着手することにしましょう。仕様をどのようにTODOに分解していくかは [50分でわかるテスト駆動開発](https://channel9.msdn.com/Events/de-code/2017/DO03?ocid=player)の26分あたりを参考にしてください。

TODOリスト

  - 数を文字列にして返す

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

まず `数を文字列にして返す`作業に取り掛かりたいのですがまだプログラミング対象としてはサイズが大きいようですね。もう少し具体的に分割しましょう。

  - 数を文字列にして返す
    
      - 1を渡したら文字列"1"を返す

これならプログラムの対象として実装できそうですね。

## テストファーストから始めるテスト駆動開発

### テストファースト

最初にプログラムする対象を決めたので早速プロダクトコードを実装・・・ではなく **テストファースト** で作業を進めていきましょう。まずはプログラムを実行するための準備作業を進める必要がありますね。

> テストファースト
> 
> いつテストを書くべきだろうか----それはテスト対象のコードを書く前だ。
> 
> —  テスト駆動開発 

では、どうやってテストすればいいでしょうか？テスティングフレームワークを使って自動テストを書きましょう。

> テスト（名詞） どうやってソフトウェアをテストすればよいだろか----自動テストを書こう。
> 
> —  テスト駆動開発 

今回Rubyのテスティングフレームワークには [Minitest](http://docs.seattlerb.org/minitest/)を利用します。Minitestの詳しい使い方に関しては *Minitestの基本* [6](#pruby)を参照してください。では、まず以下の内容のテキストファイルを作成して `main.rb` で保存します。

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world', greeting
  end
end

def greeting
  'hello world'
end
```

テストを実行します。

```bash
$ ruby main.rb
Traceback (most recent call last):
        2: from main.rb:2:in `<main>'
        1: from /home/gitpod/.rvm/rubies/ruby-2.5.5/lib/ruby/site_ruby/2.5.0/rubygems/core_ext/kernel_require.rb:54:in `require'
/home/gitpod/.rvm/rubies/ruby-2.5.5/lib/ruby/site_ruby/2.5.0/rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- minitest/reporters (LoadError)
```

おおっと！いきなりエラーが出てきましたね。でも落ち着いてください。まず最初にやることはエラーメッセージの内容を読むことです。ここでは `require': cannot load such file — minitest/reporters (LoadError)` と表示されています。取っ掛かりとしては [エラーメッセージをキーワードに検索をする](https://www.google.com/search?sxsrf=ACYBGNTd6_rVoXXOBo2CHgs5vysIRIJaCQ%3A1579765868950&source=hp&ei=bFApXrCCN4Pg-Aa8v6vABw&q=%60require%27%3A+cannot+load+such+file&oq=%60require%27%3A+cannot+load+such+file&gs_l=psy-ab.3..0l2j0i30l6.1644.1644..2069…​2.0..0.116.116.0j1…​…​0…​.2j1..gws-wiz…​..10..35i362i39.-RXoHriCPZQ&ved=0ahUKEwiw6Ma7npnnAhUDMN4KHbzfCngQ4dUDCAg&uact=5) というのがあります。ちなみにここでは [minitest/reporters](https://github.com/kern/minitest-reporters) というGemがインストールされていなかったため読み込みエラーが発生していたようです。サイトのInstallationを参考にGemをインストールしておきましょう。

``` bash
$ gem install minitest-reporters
Fetching minitest-reporters-1.4.2.gem
Fetching ansi-1.5.0.gem
Fetching builder-3.2.4.gem
Successfully installed ansi-1.5.0
Successfully installed builder-3.2.4
Successfully installed minitest-reporters-1.4.2
Parsing documentation for ansi-1.5.0
Installing ri documentation for ansi-1.5.0
Parsing documentation for builder-3.2.4
Installing ri documentation for builder-3.2.4
Parsing documentation for minitest-reporters-1.4.2
Installing ri documentation for minitest-reporters-1.4.2
Done installing documentation for ansi, builder, minitest-reporters after 3 seconds
3 gems installed
```

Gemのインストールが完了したので再度実行してみましょう。今度はうまくいったようですね。Gemって何？と思ったかもしれませんがここではRubyの外部プログラム部品のようなものだと思っておいてください。`minitest-reporters` というのはテスト結果の見栄えを良くするための追加外部プログラムです。先程の作業ではそれを `gem install` コマンドでインストールしたのです。


``` bash
$ ruby main.rb
Started with run options --seed 9701

  1/1: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00090s
1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

テストは成功しましたね。では続いてテストを失敗させてみましょう。`hello world` を `hello world!!!` に書き換えてテストを実行してみるとどうなるでしょうか。

``` ruby
...
class HelloTest < Minitest::Test
  def test_greeting
    assert_equal 'hello world!!!', greeting
  end
end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 18217

 FAIL["test_greeting", #<Minitest::Reporters::Suite:0x00007f98a59194f8 @name="HelloTest">, 0.0007280000027094502]
 test_greeting#HelloTest (0.00s)
        Expected: "hello world!!!"
          Actual: "hello world"
        main.rb:11:in `test_greeting'

  1/1: [======================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00101s
1 tests, 1 assertions, 1 failures, 0 errors, 0 skips
```

オッケー、テスティングフレームワークが正常に読み込まれて動作することが確認できました。続いてバージョン管理システムのセットアップをしておきましょう。バージョン管理システム何それ？だって！？君はセーブしないでロールプレイングゲームをクリアできるのか？できないならまず[ここ](https://backlog.com/ja/git-tutorial/intro/01/)でGitを使ったバージョン管理の基本を学んでおきましょう。

``` bash
$ git init
$ git add .
$ git commit -m 'セットアップ'
```

これで[ソフトウェア開発の三種の神器](https://t-wada.hatenablog.jp/entry/clean-code-that-works)のうち **バージョン管理** と **テスティング** の準備が整いましたので **TODOリスト** の最初の作業に取り掛かかるとしましょう。

### 仮実装

TODOリスト

  - 数を文字列にして返す
    
      - **1を渡したら文字列"1"を返す**

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

**1を渡したら文字列"1"を返す** プログラムを `main.rb` に書きましょう。最初に何を書くのかって？
アサーションを最初に書きましょう。

> アサートファースト
> 
> いつアサーションを書くべきだろうか----最初に書こう
> 
>   - システム構築はどこから始めるべきだろうか。システム構築が終わったらこうなる、というストーリーを語るところからだ。
> 
>   - 機能はどこから書き始めるべきだろうか。コードが書き終わったらこのように動く、というテストを書くところからだ。
> 
>   - ではテストはどこから書き始めるべきだろうか。それはテストの終わりにパスすべきアサーションを書くところからだ。
> 
> —  テスト駆動開発 

まず、セットアッププログラムは不要なので削除しておきましょう。

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
```

テストコードを書きます。え？日本語でテストケースを書くの？ですかって。開発体制にもよりますが日本人が開発するのであれば無理に英語で書くよりドキュメントとしての可読性が上がるのでテストコードであれば問題は無いと思います。

> テストコードを読みやすくするのは、テスト以外のコードを読みやすくするのと同じくらい大切なことだ。
> 
> —  リーダブルコード 

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzzTest < Minitest::Test
  def test_1を渡したら文字列1を返す
    assert_equal '1', FizzBuzz.generate(1)
  end
end
```

テストを実行します。

``` bash
$ ruby main.rb
Started with run options --seed 678

ERROR["test_1を渡したら文字列1を返す", #<Minitest::Reporters::Suite:0x00007f956d8b6870 @name="FizzBuzzTest">, 0.0006979999998293351]
 test_1を渡したら文字列1を返す#FizzBuzzTest (0.00s)
NameError:         NameError: uninitialized constant FizzBuzzTest::FizzBuzz
        Did you mean?  FizzBuzzTest
            main.rb:10:in `test_1を渡したら文字列1を返す'

  1/1: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00201s
1 tests, 0 assertions, 0 failures, 1 errors, 0 skips
```

`NameError: NameError: uninitialized constant FizzBuzzTest::FizzBuzz`…​FizzBuzzが定義されていない。そうですねまだ作ってないのだから当然ですよね。では`FizzBuzz::generate` メソッドを作りましょう。どんな振る舞いを書けばいいのでしょうか？とりあえず最初のテストを通すために **仮実装** から始めるとしましょう。

> 仮実装を経て本実装へ
> 
> 失敗するテストを書いてから、最初に行う実装はどのようなものだろうか----ベタ書きの値を返そう。
> 
> —  テスト駆動開発 

`FizzBuzz` **クラス** を定義して **文字列リテラル** を返す `FizzBuzz::generate` **クラスメソッド** を作成しましょう。ちょっと何言ってるかわからないかもしれませんがとりあえずそんなものだと思って書いてみてください。

``` ruby
...
class FizzBuzz
  def self.generate(n)
    '1'
  end
end
```

テストが通ることを確認します。

``` bash
$ ruby main.rb
Started with run options --seed 60122

  1/1: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00094s
1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
```

オッケー、これでTODOリストを片付けることができました。え？こんなベタ書きのプログラムでいいの？他に考えないといけないことたくさんあるんじゃない？ばかじゃないの？と思われるかもしませんが、この細かいステップに今しばらくお付き合いいただきたい。

TODOリスト

  - 数を文字列にして返す
    
      - **1を渡したら文字列"1"を返す**

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

### 三角測量

1を渡したら文字列1を返すようにできました。では、2を渡したらどうなるでしょうか？

TODOリスト

  - 数を文字列にして返す
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - **2を渡したら文字列"2"を返す**

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

<!-- end list -->

``` ruby
...
class FizzBuzzTest < Minitest::Test
  def test_1を渡したら文字列1を返す
    assert_equal '1', FizzBuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', FizzBuzz.generate(2)
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 62350

 FAIL["test_2を渡したら文字列2を返す", #<Minitest::Reporters::Suite:0x00007fa4968938d8 @name="FizzBuzzTest">, 0.0009390000013809185]
 test_2を渡したら文字列2を返す#FizzBuzzTest (0.00s)
        Expected: "2"
          Actual: "1"
        main.rb:17:in `test_2を渡したら文字列2を返す'

  2/2: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00179s
2 tests, 2 assertions, 1 failures, 0 errors, 0 skips
```

テストが失敗しました。それは文字列1しか返さないプログラムなのだから当然ですよね。では1が渡されたら文字列1を返し、2を渡したら文字列2を返すようにプログラムを修正しましょう。**数値リテラル** を **文字列リテラル**　に変換する必要があります。公式リファレンスで調べてみましょう。

Rubyの公式リファレンスは <https://docs.ruby-lang.org/> です。[日本語リファレンス](https://docs.ruby-lang.org/ja/) から[るりまサーチ](https://docs.ruby-lang.org/ja/search/)を選択してキーワード検索してみましょう。[文字列 変換](https://docs.ruby-lang.org/ja/search/query:%E6%96%87%E5%AD%97%E5%88%97%E3%80%80%E5%A4%89%E6%8F%9B/)キーワードで検索すると `to_s` というキーワードが出てきました。今度は[to\_s](https://docs.ruby-lang.org/ja/search/query:to_s/)で検索すると色々出てきました、どうやら `to_s` を使えばいいみたいですね。

ちなみに検索エンジンから [Ruby 文字列 変換](https://www.google.com/search?hl=ja&sxsrf=ACYBGNRISq_mMHcQ1nGzgT3k_igW82f1Sg%3A1579494685196&source=hp&ei=HS0lXqnSCeeumAXN5ZigCg&q=Ruby+%E6%96%87%E5%AD%97%E5%88%97%E3%80%80%E5%A4%89%E6%8F%9B&oq=Ruby+%E6%96%87%E5%AD%97%E5%88%97%E3%80%80%E5%A4%89%E6%8F%9B&gs_l=psy-ab.3..0i4i37l2j0i8i30l6.1386.6456..6820…​2.0..0.139.2322.1j20…​…​0…​.1..gws-wiz…​…​.0i131i4j0i4j0i131j35i39j0j0i8i4i30.FfEPbOjPZcw&ved=0ahUKEwjp1IidrJHnAhVnF6YKHc0yBqQQ4dUDCAg&uact=5)で検索してもいろいろ出てくるのですがすべてのサイトが必ずしも正確な説明をしているまたは最新のバージョンに対応しているとは限らないので始めは公式リファレンスや市販の書籍から調べる癖をつけておきましょう。

``` ruby
...
class FizzBuzz
  def self.generate(n)
    n.to_s
  end
end
```

テストを実行します。

``` bash
$ ruby main.rb
Started with run options --seed 42479

  2/2: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00098s
2 tests, 2 assertions, 0 failures, 0 errors, 0 skips
```

テストが無事通りました。このように２つ目のテストによって `FizzBuzz::generate` メソッドの一般化を実現することができました。このようなアプローチを **三角測量** と言います。

> 三角測量
> 
> テストから最も慎重に一般化を引き出すやり方はどのようなものだろうか----２つ以上の例があるときだけ、一般化を行うようにしよう。
> 
> —  テスト駆動開発 

TODOリスト

  - **数を文字列にして返す**
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

たかが **数を文字列にして返す** プログラムを書くのにこんなに細かいステップを踏んでいくの？と思ったかもしれません。プログラムを書くということは細かいステップを踏んで行くことなのです。そして、細かいステップを踏み続けることが大切なことなのです。

> TDDで大事なのは、細かいステップを踏むことではなく、細かいステップを踏み続けられるようになることだ。
> 
> —  テスト駆動開発


あと、テストケースの内容がアサーション一行ですがもっと検証するべきことがあるんじゃない？と思うでしょう。検証したいことがあれば独立したテストケースを追加しましょう。このような書き方はよろしくありません。

``` ruby
...
  def test_数字を渡したら文字列を返す
    assert_equal '1', FizzBuzz.generate(1)
    assert_equal '2', FizzBuzz.generate(2)
    assert_equal '3', FizzBuzz.generate(3)
    assert_equal '4', FizzBuzz.generate(4)
    assert_equal '5', FizzBuzz.generate(5)
  end
...
```

> テストの本質というのは、「こういう状況と入力から、こういう振る舞いと出力を期待する」のレベルまで要約できる。
> 
> —  リーダブルコード 

ここで一段落ついたので、これまでの作業内容をバージョン管理システムにコミットしておきましょう。

``` bash
git commit -m 'test: 数を文字列にして返す'
```

## リファクタリングから始めるテスト駆動開発

### リファクタリング

ここでテスト駆動開発の流れを確認しておきましょう。

> 1.  レッド：動作しない、おそらく最初のうちはコンパイルも通らないテストを１つ書く。
> 
> 2.  グリーン:そのテストを迅速に動作させる。このステップでは罪を犯してもよい。
> 
> 3.  リファクタリング:テストを通すために発生した重複をすべて除去する。
> 
> レッド・グリーン・リファクタリング。それがTDDのマントラだ。
> 
> —  テスト駆動開発 

コードはグリーンの状態ですが **リファクタリング** を実施していませんね。重複を除去しましょう。

> リファクタリング(名詞) 外部から見たときの振る舞いを保ちつつ、理解や修正が簡単になるように、ソフトウェアの内部構造を変化させること。
> 
> —  リファクタリング(第2版) 

> リファクタリングする(動詞) 一連のリファクタリングを適用して、外部から見た振る舞いの変更なしに、ソフトウェアを再構築すること。
> 
> —  リファクタリング(第2版 

#### メソッドの抽出

テストコードを見てください。テストを実行するにあたって毎回前準備を実行する必要があります。こうした処理は往々にして同じ処理を実行するものなので
**メソッドの抽出** を適用して重複を除去しましょう。

> メソッドの抽出
> 
> ひとまとめにできるコードの断片がある。
> 
> コードの断片をメソッドにして、それを目的を表すような名前をつける。
> 
> —  新装版 リファクタリング 

``` ruby
class FizzBuzzTest < Minitest::Test
  def test_1を渡したら文字列1を返す
    assert_equal '1', FizzBuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', FizzBuzz.generate(2)
  end
end
```

テストフレームワークでは前処理にあたる部分を実行する機能がサポートされています。Minitestでは `setup` メソッドがそれに当たるので `FizzBuzz` オブジェクトを共有して共通利用できるようにしてみましょう。ここでは **インスタンス変数** に `FizzBuzz` **クラス** の参照を **代入** して各テストメソッドで共有できるようにしました。ちょっと何言ってるかわからないかもしれませんがここではそんなことをやってるぐらいのイメージで大丈夫です。

``` ruby
class FizzBuzzTest < Minitest::Test
  def setup
    @fizzbuzz = FizzBuzz
  end

  def test_1を渡したら文字列1を返す
    assert_equal '1', @fizzbuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', @fizzbuzz.generate(2)
  end
end
```

テストプログラムを変更してしまいましたが壊れていないでしょうか？確認するにはどうすればいいでしょう？ テストを実行して確認すればいいですよね。

``` bash
$ ruby main.rb
Started with run options --seed 33356

  2/2: [======================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00083s
2 tests, 2 assertions, 0 failures, 0 errors, 0 skips
```

オッケー、前回コミットした時と同じグリーンの状態のままですよね。区切りが良いのでここでコミットしておきましょう。

``` bash
git commit -m 'refactor: メソッドの抽出'
```

#### 変数名の変更

もう一つ気になるところがあります。

``` ruby
...
class FizzBuzz
  def self.generate(n)
    n.to_s
  end
end
```

引数の名前が `n` ですね。コンピュータにはわかるかもしれませんが人間が読むコードとして少し不親切です。特にRubyのような動的言語では型が明確に定義されないのでなおさらです。ここは **変数名の変更** を適用して人間にとって読みやすいコードにリファクタリングしましょう。

> コンパイラがわかるコードは誰にでも書ける。すぐれたプログラマは人間にとってわかりやすいコードを書く。
> 
> —  リファクタリング(第2版) 

> 名前は短いコメントだと思えばいい。短くてもいい名前をつければ、それだけ多くの情報を伝えることができる。
> 
> —  リーダブルコード 

``` ruby
...
class FizzBuzz
  def self.generate(number)
    number.to_s
  end
end
```

続いて、変更で壊れていないかを確認します。

``` bash
$ ruby main.rb
Started with run options --seed 33356

  2/2: [======================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00083s
2 tests, 2 assertions, 0 failures, 0 errors, 0 skips
```

オッケー、この時点でテストコードとプロダクトコードを変更しましたがその変更はすでに作成した自動テストによって壊れていないことを簡単に確認することができました。え、こんな簡単な変更でプログラムが壊れるわけないじゃん、ドジっ子なの？ですって。残念ながら私は絶対ミスしない完璧な人間ではないし、どちらかといえば注意力の足りないプログラマなのでこんな間違いも普通にやらかします。

``` ruby
...
class FizzBuzz
  def self.generate(number)
    numbr.to_s
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 59453

ERROR["test_1を渡したら文字列1を返す", #<Minitest::Reporters::Suite:0x0000564f6b1dfc70 @name="FizzBuzzTest">, 0.001019135997921694]
 test_1を渡したら文字列1を返す#FizzBuzzTest (0.00s)
NameError:         NameError: undefined local variable or method `numbr' for FizzBuzz:Class
        Did you mean?  number
            main.rb:21:in `generate'
            main.rb:11:in `test_1を渡したら文字列1を返す'

ERROR["test_2を渡したら文字列2を返す", #<Minitest::Reporters::Suite:0x0000564f6b1985f0 @name="FizzBuzzTest">, 0.003952859999117209]
 test_2を渡したら文字列2を返す#FizzBuzzTest (0.00s)
NameError:         NameError: undefined local variable or method `numbr' for FizzBuzz:Class
        Did you mean?  number
            main.rb:21:in `generate'
            main.rb:15:in `test_2を渡したら文字列2を返す'

  2/2: [====================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00746s
2 tests, 0 assertions, 0 failures, 2 errors, 0 skips
```

最初にプロダクトコードを書いて一通りの機能を作ってから動作を確認する進め方だとこの手の間違いはいつどこで作り込んだのかわからなくなるため原因の調査に時間がかかり残念な経験をしたドジっ子プログラマは変更なんてするもんじゃないと思いコードを変更することに不安を持つようになるでしょう。でも、テスト駆動開発ならそんなドジっ子プログラマでも自動テストと小さなステップのおかげで上記のようなしょうもない間違いもすぐに見つけてすぐに対応することができるのでコードを変更する勇気を持つことができるのです。

> テスト駆動開発は、プログラミング中の不安をコントロールする手法だ。
> 
> —  テスト駆動開発 

> リファクタリングでは小さなステップでプログラムを変更していく。そのため間違ってもバグを見つけるのは簡単である。
> 
> —  リファクタリング(第2版) 

このグリーンの状態にいつでも戻れるようにコミットして次の **TODOリスト** の内容に取り掛かるとしましょう。

``` bash
git commit -m 'refactor: 変数名の変更'
```

> リファクタリングが成功するたびにコミットしておけば、たとえ壊してしまったとしても、動いていた状態に戻すことができます。変更をコミットしておき、意味のある単位としてまとまってから、共有のリポジトリに変更をプッシュすればよいのです。
> 
> —  リファクタリング(第2版) 

### 明白な実装

次は **3を渡したら文字列"Fizz"** を返すプログラムに取り組むとしましょう。

TODOリスト

  - *数を文字列にして返す*
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - 3 の倍数のときは数の代わりに｢Fizz｣と返す
    
      - **3を渡したら文字列"Fizz"を返す**

  - 5 の倍数のときは｢Buzz｣と返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

まずは、**テストファースト** **アサートファースト** で小さなステップで進めていくんでしたよね。

``` ruby
...
  def test_3を渡したら文字列Fizzを返す
    assert_equal 'Fizz', @fizzbuzz.generate(3)
  end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 7095

 FAIL["test_3を渡したら文字列Fizzを返す", #<Minitest::Reporters::Suite:0x00007fbadf865f50 @name="FizzBuzzTest">, 0.017029999995429534]
 test_3を渡したら文字列Fizzを返す#FizzBuzzTest (0.02s)
        --- expected
        +++ actual
        @@ -1 +1,3 @@
        -"Fizz"
        +# encoding: US-ASCII
        +#    valid: true
        +"3"
        main.rb:19:in `test_3を渡したら文字列Fizzを返す'

  3/3: [======================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.05129s
3 tests, 3 assertions, 1 failures, 0 errors, 0 skips
```

さて、失敗するテストを書いたので次はテストを通すためのプロダクトコードを書くわけですがどうしましょうか？　**仮実装**　でベタなコードを書きますか？実現したい振る舞いは`もし3を渡したらならば文字列Fizzを返す` です。英語なら `If number is 3, result is Fizz`といったところでしょうか。ここは **明白な実装** で片付けた方が早いでしょう。

> 明白な実装
> 
> シンプルな操作を実現するにはどうすればいいだろうか----そのまま実装しよう。
> 
> 仮実装や三角測量は、細かく細かく刻んだ小さなステップだ。だが、ときには実装をどうすべきか既に見えていることが。
> そのまま進もう。例えば先ほどのplusメソッドくらいシンプルなものを仮実装する必要が本当にあるだろうか。
> 普通は、その必要はない。頭に浮かんだ明白な実装をただ単にコードに落とすだけだ。もしもレッドバーが出て驚いたら、あらためてもう少し歩幅を小さくしよう。
> 
> —  テスト駆動開発 

``` ruby
class FizzBuzz
  def self.generate(number)
    number.to_s
  end
end
```

ここでは **if式** と **演算子** を使ってみましょう。なんかプログラムっぽくなってきましたね。
3で割で割り切れる場合はFizzを返すということは **数値リテラル** 3で割った余りが0の場合は **文字列リテラル** Fizzを返すということなので余りを求める **演算子** を調べる必要がありますね。公式リファレンスで **算術演算子** をキーワードで検索したところ [いろいろ](https://docs.ruby-lang.org/ja/search/query:%E7%AE%97%E8%A1%93%E6%BC%94%E7%AE%97%E5%AD%90/)出てきました。 [%](https://docs.ruby-lang.org/ja/search/query:%E7%AE%97%E8%A1%93%E6%BC%94%E7%AE%97%E5%AD%90/query:%25/)を使えばいいみたいですね。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number % 3 == 0
       result = 'Fizz'
    end
    result
  end
end
```

テストがグリーンになったのでコミットしておきます。

``` bash
$ ruby main.rb
$ git commit -m 'test: 3を渡したら文字列Fizzを返す'
```

#### アルゴリズムの置き換え

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3 の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - 5 の倍数のときは｢Buzz｣と返す
    
      - 5を渡したら文字列"Buzz"を返す

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

<!-- end list -->

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number % 3 == 0
       result = 'Fizz'
    end
    result
  end
end
```

レッド・グリーンときたので次はリファクタリングですね。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
       result = 'Fizz'
    end
    result
  end
end
```

ここでは **アルゴリズムの置き換え** を適用します。 **メソッドチェーンと述語メソッド** を使ってRubyらしい書き方にリファクタリングしてみました。

> アルゴリズムの取り替え
> 
> アルゴリズムをよりわかりやすいものに置き換えたい。
> 
> メソッドの本体を新たなアルゴリズムで置き換える。
> 
> —  新装版 リファクタリング 

> メソッドチェーンは言葉の通り、メソッドを繋げて呼び出す方法です。
> 
> —  かんたんRuby 

> 述語メソッドとはメソッド名の末尾に「？」をつけたメソッドのことを指します。
> 
> —  かんたんRuby 

``` bash
$ ruby main.rb
$ git commit -m 'refactor: アルゴリズムの置き換え'
```

だんだんとリズムに乗ってきました。ここはギアを上げて **明白な実装** で引き続き **TODOリスト** の内容を片付けていきましょう。

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - 5 の倍数のときは｢Buzz｣と返す
    
      - **5を渡したら文字列"Buzz"を返す**

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

<!-- end list -->

``` ruby
...
  def test_5を渡したら文字列Buzzを返す
    assert_equal 'Buzz', @fizzbuzz.generate(5)
  end
end
```

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
       result = 'Fizz'
    end
    result
  end
end
```

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end
end
```

``` bash
$ ruby main.rb
$ git commit -m 'test: 5を渡したら文字列Buzzを返す'
```

#### メソッドのインライン化

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - 5 の倍数のときは｢Buzz｣と返す
    
      - ~~5を渡したら文字列"Buzz"を返す~~

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す

  - 1 から 100 までの数

  - プリントする

<!-- end list -->

``` ruby
class FizzBuzzTest < Minitest::Test
  def setup
    @fizzbuzz = FizzBuzz
  end

  def test_1を渡したら文字列1を返す
    assert_equal '1', @fizzbuzz.generate(1)
  end

  def test_2を渡したら文字列2を返す
    assert_equal '2', @fizzbuzz.generate(2)
  end

  def test_3を渡したら文字列Fizzを返す
    assert_equal 'Fizz', @fizzbuzz.generate(3)
  end

  def test_5を渡したら文字列Buzzを返す
    assert_equal 'Buzz', @fizzbuzz.generate(5)
  end
end
```

``` ruby
class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    def setup
      @fizzbuzz = FizzBuzz
    end

    describe '三の倍数の場合' do
      def test_3を渡したら文字列Fizzを返す
        assert_equal 'Fizz', @fizzbuzz.generate(3)
      end
    end

    describe '五の倍数の場合' do
      def test_5を渡したら文字列Buzzを返す
        assert_equal 'Buzz', @fizzbuzz.generate(5)
      end
    end

    describe 'その他の場合' do
      def test_1を渡したら文字列1を返す
        assert_equal '1', @fizzbuzz.generate(1)
      end

      def test_2を渡したら文字列2を返す
        assert_equal '2', @fizzbuzz.generate(2)
      end
    end
  end
end
```

ここでは、**メソッドのインライン化** を適用してしてテストコードを読みやすくすることにしました。テストコードの **自己文書化** により動作する仕様書にすることができました。

> メソッドのインライン化
> 
> メソッドの本体が、名前をつけて呼ぶまでもなく明らかである。
> 
> メソッド本体の呼び出し元にインライン化して、メソッドを除去する
> 
> —  新装版 リファクタリング
> 

> 混乱せずに読めるテストコードを目指すなら（コンピュータではなく人のためにテストを書いていることを忘れてはならない）、テストメソッドの長さは３行を目指そう。
> 
> —  テスト駆動開発 

> この関数名は「自己文書化」されている。関数名はいろんなところで使用されるのだから、優れたコメントよりも名前のほうが大切だ。
> 
> —  リーダブルコード 

``` ruby
$ ruby main.rb
$ git commit -m 'refactor: メソッドのインライン化'
```

さあ、**TODOリスト** もだいぶ消化されてきましたね。もうひと踏ん張りです。

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - ~~5 の倍数のときは｢Buzz｣と返す~~
    
      - ~~5を渡したら文字列"Buzz"を返す~~

  - 3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す
    
      - **15を渡したら文字列FizzBuzzを返す**

  - 1 から 100 までの数

  - プリントする

<!-- end list -->

``` ruby
...
    describe '三と五の倍数の場合' do
      def test_15を渡したら文字列FizzBuzzを返す
        assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
      end
    end
...
```

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    elsif number.modulo(15).zero?
      result = 'FizzBuzz'
    end
    result
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 45982

 FAIL["test_15を渡したら文字列FizzBuzzを返す", #<Minitest::Reporters::Suite:0x00007f822c00b2b0 @name="FizzBuzz::三と五の倍数の場合">, 0.00231200000
0529224]
 test_15を渡したら文字列FizzBuzzを返す#FizzBuzz::三と五の倍数の場合 (0.00s)
        Expected: "FizzBuzz"
          Actual: "Fizz"
        main.rb:25:in `test_15を渡したら文字列FizzBuzzを返す'

  4/4: [======================================================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00964s
4 tests, 4 assertions, 1 failures, 0 errors, 0 skips
```

おっと、調子に乗って **明白な実装** をしていたら怒られてしまいました。ここは一旦ギアを下げて小さなステップで何が問題かを調べることにしましょう。

> 明白な実装はセカンドギアだ。頭で考えていることがうまくコードに落とせないときは、ギアを下げる用意をしよう。
> 
> —  テスト駆動開発 

調べるにあたってコードを頭から読んでもいいのですが、問題が発生したのは `15を渡したら文字列FizzBuzzを返す` テストを追加したあとですよね？ということは原因は追加したコードにあるはずですよね？よって、追加部分をデバッグすれば原因をすぐ発見できると思いませんか？

今回はRubyのデバッガとしてByebugをインストールして使うことにしましょう。

``` bash
$ gem install byebug
```

インストールが完了したら早速Byebugからプログラムを起動して動作を確認してみましょう。

``` bash
$ byebug main.rb

[1, 10] in /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/main.rb
=>  1: require 'minitest/reporters'
    2: Minitest::Reporters.use!
    3: require 'minitest/autorun'
    4:
    5: class FizzBuzzTest < Minitest::Test
    6:   describe 'FizzBuzz' do
    7:     def setup
    8:       @fizzbuzz = FizzBuzz
    9:     end
   10:
(byebug)
```

詳しい操作に関しては [printデバッグにさようなら！Ruby初心者のためのByebugチュートリアル](https://qiita.com/jnchito/items/5aaf323ab4f24b526a61)を参照してください。

では、問題の原因を調査するためbyebugメソッドでコード内にブレークポイントを埋め込んでデバッガを実行してみましょう。

``` ruby
...
    describe '三と五の倍数の場合' do
      def test_15を渡したら文字列FizzBuzzを返す
        require 'byebug'
        byebug
        assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
      end
    end
...
```

``` bash
$ byebug main.rb

[1, 10] in /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/main.rb
=>  1: require 'minitest/reporters'
    2: Minitest::Reporters.use!
    3: require 'minitest/autorun'
    4:
    5: class FizzBuzzTest < Minitest::Test
    6:   describe 'FizzBuzz' do
    7:     def setup
    8:       @fizzbuzz = FizzBuzz
    9:     end
   10:
```

ブレークポイントまで `continue` コマンドで処理を進めます。`continue` コマンドは `c` でもいけます。

``` bash
(byebug) c
   22:
   23:     describe '三と五の倍数の場合' do
   24:       def test_15を渡したら文字列FizzBuzzを返す
   25:         require 'byebug'
   26:         byebug
=> 27:         assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
   28:       end
   29:     end
   30:
   31:     describe 'その他の場合' do
```

続いて問題が発生した `@fizzbuzz.generate(15)` メソッド内にステップインします。

``` bash
(byebug) s
   36:   end
   37: end
   38:
   39: class FizzBuzz
   40:   def self.generate(number)
=> 41:     result = number.to_s
   42:     if number.modulo(3).zero?
   43:       result = 'Fizz'
   44:     elsif number.modulo(5).zero?
   45:       result = 'Buzz'
```

引数の `number` は `15` だから `elsif number.modulo(15).zero?` の行で判定されるはず・・・

``` bash
(byebug) s
   37: end
   38:
   39: class FizzBuzz
   40:   def self.generate(number)
   41:     result = number.to_s
=> 42:     if number.modulo(3).zero?
   43:       result = 'Fizz'
   44:     elsif number.modulo(5).zero?
   45:       result = 'Buzz'
   46:     elsif number.modulo(15).zero?
(byebug)
   38:
   39: class FizzBuzz
   40:   def self.generate(number)
   41:     result = number.to_s
   42:     if number.modulo(3).zero?
=> 43:       result = 'Fizz'
```

ファッ！？

``` bash
   44:     elsif number.modulo(5).zero?
   45:       result = 'Buzz'
   46:     elsif number.modulo(15).zero?
   47:       result = 'FizzBuzz'
(byebug) result
"15"
(byebug) q!
```

15は3で割り切れるから最初の判定で処理されますよね。まあ、常にコードに注意を払って頭の中で処理しながらコードを書いていればこんなミスすることは無いのでしょうが私はドジっ子プログラマなので計算機ができることは計算機にやらせて間違いがあれば原因を調べて解決するようにしています。とりあえず、テストを通るようにしておきましょう。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
      result = 'Fizz'
      if number.modulo(15).zero?
        result = 'FizzBuzz'
      end
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end
end
```

テストが通ったのでコミットしておきます。コミットログにバグは残らないのですが作業の合間ではバグを作り込んでいましたよね。でも、テストがすぐに教えてくれるのですぐに修正することができました。結果として私のようなドジっ子プログラマでもバグの無いコードを書いているかのように見えるんですよ。

``` bash
$ ruby main.rb
$ git commit -m 'test: 15を渡したら文字列FizzBuzzを返す'
```

> 私はテスト駆動開発を長年行っているので、他人にミスを気づかれる前に、自分の誤りを修正できるだけなのだ。
> 
> —  テスト駆動開発 

先程のコードですが・・・

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero?
      result = 'Fizz'
      if number.modulo(15).zero?
        result = 'FizzBuzz'
      end
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end
end
```

**if式** の中でさらに **if式** をネストしています。いわゆる **コードの不吉な臭い** がしますね。ここは仕様の文言にある `3と 5 両方の倍数の場合には｢FizzBuzz｣とプリントすること。` に沿った記述にするとともにネストした部分をわかりやすくするために **アルゴリズムの置き換え** を適用してリファクタリングをしましょう。

> ネストの深いコードは理解しにくい。
> 
> —  リーダブルコード 

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end
end
```

テストして、コミットです。

``` bash
$ ruby main.rb
$ git commit -m 'refactor: アルゴリズムの置き換え'
```

### 休憩

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - ~~5 の倍数のときは｢Buzz｣と返す~~
    
      - ~~5を渡したら文字列"Buzz"を返す~~

  - ~~3 と 5 両方の倍数の場合には｢FizzBuzz｣と返す~~
    
      - ~~15を渡したら文字列FizzBuzzを返す~~

  - **1 から 100 までの数**

  - プリントする

数を引数にして文字列を返す `FizzBuzz::generate` メソッドはできたみたいですね。次のやることは・・・新しいメソッドを追加する必要がありそうです。気分を切り替えるため少し休憩を取りましょう。

> 疲れたり手詰まりになったりしたときはどうすればいいだろうか----休憩を取ろう。
> 
> —  テスト駆動開発 

引き続き **TODOリスト** を片付けたいのですが `1から100までの数` を返すプログラムを書かないといけません。3を渡したらFizzのような **リテラル** を返すプログラムではなく 1から100までの **配列オブジェクト** を返すようなプログラムにする必要がありそうです。**TODOリスト** にするとこんな感じでしょうか。

TODOリスト

  - 1 から 100 までの数の配列を返す
    
      - 配列の初めは文字列の1を返す
    
      - 配列の最後は文字列の100を返す

  - プリントする

どうやら **配列オブジェクト** を返すプログラムを書かないといけないようですね。え？ **明白な実装** の実装イメージがわかない。そんな時はステップを小さくして **仮実装** から始めるとしましょう。

> 何を書くべきかわかっているときは、明白な実装を行う。わからないときには仮実装を行う。まだ正しい実装が見えてこないなら、三角測量を行う。それでもまだわからないなら、シャワーを浴びに行こう。
> 
> —  テスト駆動開発 

### 学習用テスト

#### 配列

**テストファースト** でまずRubyの **配列** の振る舞いを確認していきましょう。公式リファレンスによるとRubyでは[Arrayクラスとして定義されている](https://docs.ruby-lang.org/ja/latest/class/Array.html)ようですね。空の配列を作るには `[]` (配列リテラル)を使えばいいみたいですね。こんな感じかな？

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = []
        assert_equal '1', result
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 54004

 FAIL["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007fd0fb93d540 @name="FizzBuzz::1から
100までの数の配列を返す">, 0.0016740000028221402]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "1"
          Actual: []
        main.rb:37:in `test_配列の初めは文字列の1を返す'

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00602s
5 tests, 5 assertions, 1 failures, 0 errors, 0 skips
```

これは同値ではないのはわかりますね。ではこうしたらどうなるでしょうか？

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = ['1']
        assert_equal '1', result
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 32701

 FAIL["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007fb36f096030 @name="FizzBuzz::1から100までの数の配列を返す">, 0.0018850000014936086]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "1"
          Actual: ["1"]
        main.rb:38:in `test_配列の初めは文字列の1を返す'

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.04383s
5 tests, 5 assertions, 1 failures, 0 errors, 0 skips
```

**配列** には[要素を操作するメソッドが用意されており](https://docs.ruby-lang.org/ja/latest/class/Array.html)内容を色々操作できそうですね。でも、いちいちテストコードを編集してテストを実行させるのも面倒なのでここはデバッガを使ってみましょう。まずブレークポイントを設定して・・・

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        require 'byebug'
        byebug
        result = ['1']
        assert_equal '1', result
      end
    end
  end
end
```

デバッガを起動します。

``` bash
$ byebug main.rb

[1, 10] in /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/main.rb
=>  1: require 'minitest/reporters'
    2: Minitest::Reporters.use!
    3: require 'minitest/autorun'
    4:
    5: class FizzBuzzTest < Minitest::Test
    6:   describe 'FizzBuzz' do
    7:     def setup
    8:       @fizzbuzz = FizzBuzz
    9:     end
   10:
(byebug)
```

continueでブレークポイントまで進めます。

``` bash
(byebug) c
Started with run options --seed 15764

  /0: [=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=-] 0% Time: 00:00:00,  ETA: ??:??:??
[34, 43] in /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/main.rb
   34:
   35:     describe '1から100までの数の配列を返す' do
   36:       def test_配列の初めは文字列の1を返す
   37:         require 'byebug'
   38:         byebug
=> 39:         result = ['1']
   40:         assert_equal '1', result
   41:       end
   42:     end
   43:   end
```

ステップインして `result` の中身を確認してみましょう。

``` bash
(byebug) s

[35, 44] in /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/main.rb
   35:     describe '1から100までの数の配列を返す' do
   36:       def test_配列の初めは文字列の1を返す
   37:         require 'byebug'
   38:         byebug
   39:         result = ['1']
=> 40:         assert_equal '1', result
   41:       end
   42:     end
   43:   end
   44: end
(byebug) result
["1"]
```

添字を指定して **配列** の最初の文字列を確認してみましょう。

``` bash
(byebug) result
["1"]
(byebug) result[1]
nil
```

おや？１番目は"1"では無いようですね。**配列** は0から始まるので1番目を指定するにはこうします。

``` bash
(byebug) result
["1"]
(byebug) result[1]
nil
(byebug) result[0]
"1"
```

続いて、複数の文字列から構成される **配列** を作ってみましょう。

``` bash
(byebug) result = ['1','2','3']
["1", "2", "3"]
(byebug) result[0]
"1"
(byebug) result[2]
"3"
```

ちなみにRubyだとこのように表記することができます。直感的でわかりやすくないですか？

``` bash
(byebug) result
["1", "2", "3"]
(byebug) result.first
"1"
(byebug) result.last
"3"
```

最後に追加、削除、変更をやってみましょう。

``` bash
(byebug) result = ['1','2','3']
["1", "2", "3"]
(byebug) result << '4'
["1", "2", "3", "4"]
(byebug) result.push('4')
["1", "2", "3", "4", "4"]
(byebug) result.delete_at(3)
"4"
(byebug) result
["1", "2", "3", "4"]
(byebug) result[2] = '30'
"30"
(byebug) result
["1", "2", "30", "4"]
```

**配列** の振る舞いもだいぶイメージできたのでデバッガを終了させてテストコードを少し変えてみましょう。

``` bash
(byebug) q
Really quit? (y/n) y
```

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = ['1', '2', '3']
        assert_equal '1', result.first
        assert_equal '2', result[1]
        assert_equal '3', result.last
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 39118

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00186s
5 tests, 7 assertions, 0 failures, 0 errors, 0 skips
```

**変数** `result` に配列を返すメソッドを作れば良さそうですね。とりあえずメソッド名は今の時点ではあまり考えずに・・・

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = FizzBuzz.print_1_to_100
        assert_equal '1', result.first
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 19247

ERROR["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007faaea925058 @name="FizzBuzz::1から
100までの数の配列を返す">, 0.0017889999980980065]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
NoMethodError:         NoMethodError: undefined method `print_1_to_100' for FizzBuzz:Class
            main.rb:37:in `test_配列の初めは文字列の1を返す'

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00454s
5 tests, 4 assertions, 0 failures, 1 errors, 0 skips
```

ここまでくれば **仮実装** はできますね。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end

  def self.print_1_to_100
    [1, 2, 3]
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 24564

 FAIL["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007fefd8917060 @name="FizzBuzz::1から
100までの数の配列を返す">, 0.0011969999977736734]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "1"
          Actual: 1
        main.rb:38:in `test_配列の初めは文字列の1を返す'

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00209s
5 tests, 5 assertions, 1 failures, 0 errors, 0 skips
```

ファッ！？、ああ、数字ではなく文字列で返すのだからこうですね。

``` ruby
...
  def self.print_1_to_100
    ['1', '2', '3']
  end
end
```

**%記法** を使うとよりRubyらしく書けます。

``` ruby
...
  def self.print_1_to_100
    %w[1 2 3]
  end
end
```

> %記法とは、文字列や正規表現などを定義する際に、%を使った特別な書き方をすることでエスケープ文字を省略するなど、可読性を高めることができる記法です。
> 
> —  かんたんRuby 

``` bash
$ ruby main.rb
Started with run options --seed 42995

  5/5: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00195s
5 tests, 5 assertions, 0 failures, 0 errors, 0 skips
```

**TODOリスト** の１つ目を **仮実装** で片づけことができました。ちなみにテストコードを使ってソフトウェアの振る舞いを検証するテクニックを **学習用テスト** と言います。

> 学習用テスト
> 
> チーム外の誰かが書いたソフトウェアのテストを書くのはどのようなときか----そのソフトウェアの新機能を初めて使う際に書いてみよう。
> 
> —  テスト駆動開発 

TODOリスト

  - 1 から 100 までの数の配列を返す
    
      - ~~配列の初めは文字列の1を返す~~
    
      - 配列の最後は文字列の100を返す

  - プリントする

#### 繰り返し処理

`FizzBuzz::print_1_to_100` メソッドはまだ最後の要素が検証されていませんね。**三角測量** を使って小さなステップで進めていくことにしましょう。

``` ruby
...
    describe '1から100までの数の配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = FizzBuzz.print_1_to_100
        assert_equal '1', result.first
      end

      def test_配列の最後は文字列の100を返す
        result = FizzBuzz.print_1_to_100
        assert_equal '100', result.last
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 12031

 FAIL["test_配列の最後は文字列の100を返す", #<Minitest::Reporters::Suite:0x00007fccc9828500 @name="FizzBuzz::1から100までの数の配列を返す">, 0.0018540000019129366]
 test_配列の最後は文字列の100を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "100"
          Actual: "3"
        main.rb:43:in `test_配列の最後は文字列の100を返す'

  6/6: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.02936s
```

配列は3までなので想定通りテストは失敗します。さて、1から100までの文字列で構成される配列をどうやって作りましょうか？ 先程は **if式** を使って **条件分岐** をプログラムで実行しました。今回は **繰り返し処理** をプログラムで実行する必要がありそうですね。Rubyの繰り返し処理には **for式** **while/until/loop** などがありますが実際のところ **eachメソッド** を使った繰り返し処理が主流です。とはいえ、実際に動かして振る舞いを確認しないとイメージは難しいですよね。 **学習用テスト** を書いてもいいのですが今回は *irb上で簡単なコードを動かしてみる*[6](#pruby)ことで振る舞いを検証してみましょう。まずコマンドラインで`irb`を起動します。

> Rubyにはfor文はあります。ですが、ほとんどのRubyプログラマはfor文を使いません。筆者も5〜6年Rubyを使っていますが、for文を書いたことは一度もありません。Rubyの場合はforのような構文で繰り返し処理をさせるのではなく、配列自身に対して「繰り返せ」という命令を送ります。ここで登場するのがeachメソッドです。
> 
> —  プロを目指す人のためのRuby入門 

``` bash
$ irb
irb(main):001:0>
```

まず先程デバッガで検証した配列の作成をやってみましょう。

``` bash
irb(main):001:0> result = %w[1 2 3]
=> ["1", "2", "3"]
```

配列のeachメソッドをつかって配列の中身を繰り返し処理で表示させてみましょう。`p` はプリントメソッドです。

``` bash
irb(main):003:0> result.each do |n| p n end
"1"
"2"
"3"
=> ["1", "2", "3"]
```

配列の中身を繰り返し処理で取り出す方法はわかりました。あとは100までの配列をどうやって作ればよいのでしょうか？`['1','2','3'…​'100']`と手書きで作りますか？100件ぐらいならまあできなくもないでしょうが1000件,10000件ならどうでしょうか？無理ですね。計算機にやってもらいましょう、調べてみるとRubyには **レンジオブジェクト(Range)** というもの用意されいるそうです。説明を読んでもピンと来ないので実際に動作を確認してみましょう。

> レンジオブジェクト（範囲オブジェクトとも呼ばれます）はRangeクラスのオブジェクトのことで、「..」や「…​」演算子を使って定義します。「1..3」のように定義し、主に整数値や文字列を使って範囲を表現します。
> 
> —  かんたんRuby 

``` bash
irb(main):008:0> (1..5).each do |n| p n end
1
2
3
4
5
=> 1..5
irb(main):009:0> (1...5).each do |n| p n end
1
2
3
4
```

100まで表示したいのでこうですね。

``` bash
irb(main):010:0> (1..100).each do |n| p n end
1
2
3
..
99
100
=> 1..100
```

`FizzBuzz::print_1_to_100` **メソッド** の **明白な実装** イメージができましたか？ `irb` を終了させてプロダクトコードを変更しましょう。

``` bash
irb(main):011:0> exit
```

``` ruby
...
  def self.print_1_to_100
    result = []
    (1..100).each do |n|
      result << n
    end
    result
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 38412

 FAIL["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007f858480edf8 @name="FizzBuzz::1から
100までの数の配列を返す">, 0.0012219999989611097]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "1"
          Actual: 1
        main.rb:38:in `test_配列の初めは文字列の1を返す'

 FAIL["test_配列の最後は文字列の100を返す", #<Minitest::Reporters::Suite:0x00007f858480c8f0 @name="FizzBuzz::1から100までの数の配列を返す">, 0.0014040000023669563]
 test_配列の最後は文字列の100を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "100"
          Actual: 100
        main.rb:43:in `test_配列の最後は文字列の100を返す'

  6/6: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00218s
6 tests, 6 assertions, 2 failures, 0 errors, 0 skips
```

ファッ！？また、やらかしました。文字列に変換しなといけませんね。

``` ruby
...
  def self.print_1_to_100
    result = []
    (1..100).each do |n|
      result << n.to_s
    end
    result
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 40179

  6/6: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00196s
6 tests, 6 assertions, 0 failures, 0 errors, 0 skips
```

ちなみに、*do …​ endを使う代わりに、{}で囲んでもブロックを作れる*[6](#pruby)のでこのように書き換えることができます。

``` ruby
...
  def self.print_1_to_100
    result = []
    (1..100).each { |n| result << n.to_s }
    result
  end
end
```

ここで、一旦コミットしておきましょう。

``` bash
$ git commit -m 'test: 1から100までの数を返す'
```

TODOリスト

  - 1 から 100 までの数の配列を返す
    
      - ~~配列の初めは文字列の1を返す~~
    
      - ~~配列の最後は文字列の100を返す~~

  - プリントする

#### メソッド呼び出し

1から100までの数の配列を返すメソッドはできました。しかし、このプログラムは1から100までの数を `FizzBuzz::generate` した結果を返すのが正しい振る舞いですよね。 **TODOリスト** を追加してテストも追加します。

TODOリスト

  - 1 から 100 までの数の配列を返す
    
      - ~~配列の初めは文字列の1を返す~~
    
      - ~~配列の最後は文字列の100を返す~~
    
      - **配列の2番めは文字列のFizzを返す**

  - プリントする

<!-- end list -->

``` ruby
...
      def test_配列の2番目は文字列のFizzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Fizz', result[2]
      end
    end
  end
end
```

``` ruby
$ ruby main.rb
Started with run options --seed 50411

 FAIL["test_配列の2番目は文字列のをFizz返す", #<Minitest::Reporters::Suite:0x00007fe8a1917dc8 @name="FizzBuzz::1から100までの数の配列を返す">, 0.01608900000428548]
 test_配列の2番目は文字列のFizzを返す#FizzBuzz::1から100までの数の配列を返す (0.02s)
        --- expected
        +++ actual
        @@ -1 +1,3 @@
        -"Fizz"
        +# encoding: US-ASCII
        +#    valid: true
        +"3"
        main.rb:48:in `test_配列の2番目は文字列のFizzを返す'

  7/7: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.03112s
7 tests, 7 assertions, 1 failures, 0 errors, 0 skips
```

ですよね、ここは **繰り返し処理** の中で `FizzBuzz::generate` を呼び出すように変更しましょう。

``` ruby
...
  def self.print_1_to_100
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end
```

``` ruby
$ ruby main.rb
Started with run options --seed 15549

 FAIL["test_配列の最後は文字列の100を返す", #<Minitest::Reporters::Suite:0x00007ff80a907e28 @name="FizzBuzz::1から100までの数の配列を返す">, 0.001347000004898291]
 test_配列の最後は文字列の100を返す#FizzBuzz::1から100までの数の配列を返す (0.00s)
        Expected: "100"
          Actual: "Buzz"
        main.rb:43:in `test_配列の最後は文字列の100を返す'

  7/7: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00218s
7 tests, 7 assertions, 1 failures, 0 errors, 0 skips
```

新規に追加したテストはパスしたのですが２つ目のテストが失敗しています。これはテストケースが間違っていますね。

``` ruby
...
      def test_配列の最後は文字列のBuzzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Buzz', result.last
      end

      def test_配列の2番目は文字列のFizzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Fizz', result[2]
      end
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 21247

  7/7: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00217s
7 tests, 7 assertions, 0 failures, 0 errors, 0 skips
```

他のパターンも明記しておきましょう。

``` ruby
...
    describe '1から100までのFizzBuzzの配列を返す' do
      def test_配列の初めは文字列の1を返す
        result = FizzBuzz.print_1_to_100
        assert_equal '1', result.first
      end

      def test_配列の最後は文字列のBuzzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Buzz', result.last
      end

      def test_配列の2番目は文字列のFizzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Fizz', result[2]
      end

      def test_配列の4番目は文字列のBuzzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'Buzz', result[4]
      end

      def test_配列の14番目は文字列のFizzBuzzを返す
        result = FizzBuzz.print_1_to_100
        assert_equal 'FizzBuzz', result[14]
      end
    end
  end
end
```

**説明変数** への代入が重複しています。ついでに **メソッドの抽出** をして重複をなくしておきましょう。

> 最初のステップ「準備(Arrange)」は、テスト間で重複しがちだ。それとは対象的に「実行(Act)」「アサート(Assert)」は重複しないことが多い。
> 
> —  テスト駆動開発 

``` ruby
...
    describe '1から100までのFizzBuzzの配列を返す' do
      def setup
        @result = FizzBuzz.print_1_to_100
      end

      def test_配列の初めは文字列の1を返す
        assert_equal '1', @result.first
      end

      def test_配列の最後は文字列のBuzzを返す
        assert_equal 'Buzz', @result.last
      end

      def test_配列の2番目は文字列のFizzを返す
        assert_equal 'Fizz', @result[2]
      end

      def test_配列の4番目は文字列のBuzzを返す
        assert_equal 'Buzz', @result[4]
      end

      def test_配列の14番目は文字列のFizzBuzzを返す
        assert_equal 'FizzBuzz', @result[14]
      end
    end
  end
```

``` bash
$ ruby main.rb
Started with run options --seed 17460

  9/9: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00207s
9 tests, 9 assertions, 0 failures, 0 errors, 0 skips
```

とりあえず、現時点で仕様を満たすプログラムにはなったみたいですね。

``` bash
$ git commit -m 'test: 1から100までのFizzBuzzの配列を返す'
```

TODOリスト

  - ~~1 から 100 までのFizzBuzzの配列を返す~~
    
      - ~~配列の初めは文字列の1を返す~~
    
      - ~~配列の最後は文字列の100を返す~~
    
      - ~~配列の2番めは文字列のFizzを返す~~
    
      - ~~配列の4番目は文字列のBuzzを返す~~
    
      - ~~配列の14番目は文字列のFizzBuzzを返す~~

  - プリントする

#### 配列や繰り返し処理の理解

まだリファクタリングが残っているのですがその前にRubyの配列メソッドの理解をもう少し深めたいので **学習用テスト** を追加しましょう。

``` ruby
...
  describe '配列や繰り返し処理を理解する' do
    def test_繰り返し処理
      $stdout = StringIO.new
      [1, 2, 3].each { |i| p i * i }
      output = $stdout.string

      assert_equal "1\n" + "4\n" + "9\n", output
    end

    def test_特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].select(&:integer?)
      assert_equal [2, 4], result
    end

    def test_特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].find_all(&:integer?)
      assert_equal [2, 4], result
    end

    def test_特定の条件を満たさない要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].reject(&:integer?)
      assert_equal [1.1, 3.3], result
    end

    def test_新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].map(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].collect(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].find(&:size)
      assert_equal 'apple', result
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].detect(&:size)
      assert_equal 'apple', result
    end

    def test_指定した評価式で並び変えた配列を返す
      assert_equal %w[1 10 13 2 3 4], %w[2 4 13 3 1 10].sort
      assert_equal %w[1 2 3 4 10 13],
                   %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i }
      assert_equal %w[13 10 4 3 2 1],
                   %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i }
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry apricot].grep(/^a/)
      assert_equal %w[apple apricot], result
    end

    def test_ブロック内の条件式が真である間までの要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9].take_while { |item| item < 6 }
      assert_equal [1, 2, 3, 4, 5], result
    end

    def test_ブロック内の条件式が真である以降の要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].drop_while { |item| item < 6 }
      assert_equal [6, 7, 8, 9, 10], result
    end

    def test_畳み込み演算を行う
      result = [1, 2, 3, 4, 5].inject(0) { |total, n| total + n }
      assert_equal 15, result
    end

    def test_畳み込み演算を行う
      result = [1, 2, 3, 4, 5].reduce { |total, n| total + n }
      assert_equal 15, result
    end
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 18136

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00307s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

``` bash
$ git commit -m 'test: 学習用テスト'
```

### コードの不吉な臭い

終わりが見えてきましたがまだリファクタリングの必要がありそうです。

> 開発を終えるまでに考えつくまでに考えつく限りのテストを書き、テストに支えられたリファクタリングが、網羅性のあるテストに支えられてたリファクタリングになるようにしなければならない。
> 
> —  テスト駆動開発 

ここでプロダクトコードを眺めてみましょう。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end

  def self.print_1_to_100
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end
```

**コードの不吉な臭い** が漂ってきませんか？私が感じた部分を解説していきますね。

#### 不思議な名前

> 不思議な名前
> 
> 明快なコードにするために最も重要なのは、適切な名前付けです。
> 
> —  リファクタリング(第2版) 

> 変数や関数などの構成要素の名前は、抽象的ではなく具体的なものにしよう。
> 
> —  リーダブルコード 

まず、気になったのが `print_1_to_100` メソッドです。このメソッドはFizzBuzzの配列を返すメソッドであって1から100までを表示するメソッドではありませんよね。ここは **メソッド名の変更** を適用して処理の内容に沿った名前に変更しましょう。え？動いている処理をわざわざ変更してプログラムを壊す危険を犯す必要があるのかですって。確かに自動テストのない状況でドジっ子プログラマがそんなことをすればいずれ残念なことになるでしょうね。でも、すでに自動テストが用意されている今なら自信をもって動いている処理でも変更できますよね。

> リファクタリングに入る前に、しっかりとした一連のテスト群を用意しておくこと。これらのテストには自己診断機能が不可欠である。
> 
> —  リファクタリング(第2版) 

> テストは不安を退屈に変える賢者の石だ。
> 
> —  テスト駆動開発 

``` ruby
...
  def self.print_1_to_100
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end
```

``` ruby
...
  def self.generate_list
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end
```

変更で壊れていないか確認します。

``` bash
$ ruby main.rb
Started with run options --seed 47414

ERROR["test_配列の初めは文字列の1を返す", #<Minitest::Reporters::Suite:0x00007fe9e6858108 @name="FizzBuzz::1から
100までのFizzBuzzの配列を返す">, 0.0023099999998521525]
 test_配列の初めは文字列の1を返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.00s)
NoMethodError:         NoMethodError: undefined method `print_1_to_100' for FizzBuzz:Class
            main.rb:37:in `setup'
...

ERROR["test_配列の最後は文字列のBuzzを返す", #<Minitest::Reporters::Suite:0x00007fe9f7097160 @name="FizzBuzz::1から100までのFizzBuzzの配列を返す">, 0.011574000000109663]
 test_配列の最後は文字列のBuzzを返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.01s)
NoMethodError:         NoMethodError: undefined method `print_1_to_100' for FizzBuzz:Class
            main.rb:37:in `setup'

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.01479s
19 tests, 16 assertions, 0 failures, 5 errors, 0 skips
```

いきなり失敗しちゃいました。でも、焦らずエラーメッセージを読みましょう。 ``NoMethodError: NoMethodError:undefined method `print_1_to_100' for FizzBuzz:Class`` メソッド名の変更したけどテストは以前のままでしたね。

``` ruby
...
    describe '1から100までのFizzBuzzの配列を返す' do
      def setup
        @result = FizzBuzz.print_1_to_100
      end
...
```

``` ruby
...
    describe '1から100までのFizzBuzzの配列を返す' do
      def setup
        @result = FizzBuzz.generate_list
      end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 54699

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00351s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

プロダクトコードは壊れていなことが確認できたので自信を持ってコミットしておきましょう。

``` bash
$ git commit -m 'refactor:　メソッド名の変更'
```

> TDDにおけるテストの考え方は実用主義に貫かれている。TDDにおいてテストは目的を達成するための手段であり、その目的は、大きなる自信を伴うコードだ。
> 
> —  テスト駆動開発 

#### 長い関数

> 長い関数
> 
> 経験上、長く充実した人生を送るのは、短い関数を持ったプログラムです。
> 
> —  リファクタリング(第2版) 

次に気になったのが `FizzBuzz::generate` メソッド内のif分岐処理ですね。こうした条件分岐には仕様変更の際に追加ロジックが新たなif分岐として追加されてどんどん長くなって読みづらいコードに成長する危険性があります。そういうコードは早めに対策を打っておくのが賢明です。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s
    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end
    result
  end

  def self.generate_list
    result = []
    (1..100).each { |n| result << generate(n) }
    result
  end
end
```

まずコードをもう少し読みやすくしましょう。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s

    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end

    result
  end

  def self.generate_list
    result = []

    (1..100).each { |n| result << generate(n) }

    result
  end
end
```

`FizzBuzz` の **メソッド** は大きく分けて **変数** の初期化 **条件分岐** **繰り返し処理** による判断、計算そして結果の **代入** を行い最後に **代入** された **変数** を返す流れになっています。 そこで各単位ごとにスペースを挿入してコードの可読性を上げておきましょう。

> 人間の脳はグループや階層を１つの単位として考える。コードの概要をすばやく把握してもらうには、このような「単位」を作ればいい。
> 
> —  リーダブルコード 

処理の単位ごとに区切りをつけました。次はif分岐ですがこうします。

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s

    if number.modulo(3).zero? && number.modulo(5).zero?
      result = 'FizzBuzz'
    elsif number.modulo(3).zero?
      result = 'Fizz'
    elsif number.modulo(5).zero?
      result = 'Buzz'
    end

    result
  end
...
```

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s

    return 'FizzBuzz' if number.modulo(3).zero? && number.modulo(5).zero?
    return 'Fizz' if number.modulo(3).zero?
    return 'Buzz' if number.modulo(5).zero?

    result
  end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 62095

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00296s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

条件に該当した場合は処理を最後まで進めずその場で終了させる書き方を **ガード節** と言います。このように書くことで追加ロジックが発生しても既存のコードを編集することなく追加することができるので安全に簡単に変更できるコードにすることができます。

> ガード節による入れ子条件記述の置き換え
> 
> メソッド内に正常ルートが不明確な条件つき振る舞いがある。
> 
> 特殊ケースすべてに対してガード節を使う。
> 
> —  新装版 リファクタリング 

> 関数で複数のreturn文を使ってはいけないと思っている人がいる。アホくさ。関数から早く返すのはいいことだ。むしろ望ましいときもある。
> 
> —  リーダブルコード 

``` bash
$ git commit -m 'refactor: ガード節による入れ子条件の置き換え'
```

どの条件にも該当しない場合は数字を文字列してかえすのですが **一時変数** の `result` は最後でしか使われていませんね。このような場合は **変数のインライン化** を適用しましょう。

> 一時変数のインライン化
> 
> 簡単な式によって一度だけ代入される一時変数があり、それが他のリファクタリングの障害となっている。
> 
> その一時変数への参照をすべて式で置き換える。
> 
> —  新装版 リファクタリング 

``` ruby
class FizzBuzz
  def self.generate(number)
    result = number.to_s

    return 'FizzBuzz' if number.modulo(3).zero? && number.modulo(5).zero?
    return 'Fizz' if number.modulo(3).zero?
    return 'Buzz' if number.modulo(5).zero?

    result
  end
...
```

``` ruby
class FizzBuzz
  def self.generate(number)
    return 'FizzBuzz' if number.modulo(3).zero? && number.modulo(5).zero?
    return 'Fizz' if number.modulo(3).zero?
    return 'Buzz' if number.modulo(5).zero?
    number.to_s
  end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 2528

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00255s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

変更によって壊れていないことが確認できたのでコミットします。

``` bash
$ git commit -m 'refactor:　変数のインライン化'
```

続いて、FizzBuzzを判定する部分ですがもう少しわかりやすくするため **説明用変数の導入** を適用します。

> 説明用変数の導入
> 
> 複雑な式がある。
> 
> その式の結果または部分的な結果を、その目的を説明する名前をつけた一時変数に代入する。
> 
> —  リファクタリング(第2版) 

``` ruby
class FizzBuzz
  def self.generate(number)
    return 'FizzBuzz' if number.modulo(3).zero? && number.modulo(5).zero?
    return 'Fizz' if number.modulo(3).zero?
    return 'Buzz' if number.modulo(5).zero?
    number.to_s
  end
...
```

``` ruby
class FizzBuzz
  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if number.modulo(3).zero? && number.modulo(5).zero?
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz
    number.to_s
  end
...
```

３で割り切れる場合の結果を `isFizz` 変数に 5で割り切れる場合の結果 `isBuzz` 変数に代入して使えるようにしました。このような変数を **説明変数** と呼びます。また似たようなパターンに **要約変数** というものがあります。FizzBuzzを返す判定部分にこの **説明変数** を適用しました。壊れていないか確認しておきましょう。

> 説明変数
> 
> 式を簡単に分割するには、式を表す変数を使えばいい。この変数を「説明変数」と呼ぶこともある。
> 
> —  リーダブルコード 

> 要約変数
> 
> 大きなコードをの塊を小さな名前に置き換えて、管理や把握を簡単にする変数のことを要約変数と呼ぶ。
> 
> —  リーダブルコード 

``` ruby
class FizzBuzz
  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz
    number.to_s
  end
...
```

``` bash
$ ruby main.rb
Started with run options --seed 4314

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00262s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

壊れていませんね。ではコミットしておきましょう。

``` bash
$ ruby main.rb
$ git commit -m 'refactor:　変数の抽出'
```

#### ループと変更可能なデータ

> ループ
> 
> プログラミング言語の黎明期から、ループは中心的な存在でした。しかし今ではベルボトムのジーンズやペナントのお土産のように、あまり重要でなくなりつつあります。
> 
> —  リファクタリング(第2版) 

`FizzBuzz::generate` メソッドのリファクタリングはできたので続いて `FizzBuzz::generate_list` メソッドを見ていきましょう。

``` ruby
...
  def self.generate_list
    result = []

    (1..100).each { |n| result << generate(n) }

    result
  end
end
```

空の **配列** を変数に代入してその変数に `FizzBuzz::generate` メソッドの結果を追加して返す処理ですがもしこのような変更をしてしまったらどうなるでしょうか？

``` ruby
...
  def self.generate_list
    result = []

    (1..100).each { |n| result << generate(n) }

    result = []
    result
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 19180

 FAIL["test_配列の14番目は文字列のをFizzBuzz返す", #<Minitest::Reporters::Suite:0x00007fa72805c018 @name="FizzBuzz::1から100までのFizzBuzzの配列を返す">, 0.0021289999967848416]
 test_配列の14番目は文字列のをFizzBuzz返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.00s)
        Expected: "FizzBuzz"
          Actual: nil
        main.rb:57:in `test_配列の14番目は文字列のをFizzBuzz返す'
...

Finished in 0.03063s
19 tests, 21 assertions, 5 failures, 0 errors, 0 sk
```

せっかく作った配列を初期化して返してしまいましたね。このようにミュータブルな変数はバグを作り込む原因となる傾向があります。まず一時変数を使わないように変更しましょう。

> 変更可能なデータ
> 
> データの変更はしばしば予期せぬ結果や、厄介なバグを引き起こします。
> 
> —  リファクタリング(第2版) 

> 「永続的に変更されない」変数は扱いやすい。
> 
> —  リーダブルコード 

``` ruby
...
  def self.generate_list
    return (1..100).each { |n| result << generate(n) }
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 56578

ERROR["test_配列の4番目は文字列のをBuzz返す", #<Minitest::Reporters::Suite:0x00007fe705854af0 @name="FizzBuzz::1から100までのFizzBuzzの配列を返す">, 0.001975000002857996]
 test_配列の4番目は文字列のをBuzz返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.00s)
NameError:         NameError: undefined local variable or method `result' for FizzBuzz:Class
            main.rb:153:in `block in generate_list'
            main.rb:153:in `each'
            main.rb:153:in `generate_list'
            main.rb:37:in `setup'
...
  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.01032s
19 tests, 16 assertions, 0 failures, 5 errors, 0 skips
```

一時変数 `result` は使わないので

``` ruby
...
  def self.generate_list
    return (1..100).each { |n| generate(n) }
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 35137

ERROR["test_配列の4番目は文字列のをBuzz返す", #<Minitest::Reporters::Suite:0x00007f7f1384ff78 @name="FizzBuzz::1から100までのFizzBuzzの配列を返す">, 0.0014560000017809216]
 test_配列の4番目は文字列のをBuzz返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.00s)
NoMethodError:         NoMethodError: undefined method `[]' for 1..100:Range
            main.rb:53:in `test_配列の4番目は文字列のをBuzz返す'
...
  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.03285s
19 tests, 18 assertions, 2 failures, 3 errors, 0 skips
```

結果を配列にして返したいのですが **eachメソッド** ではうまくできませんね。Rubyには新しい配列を作成する **mapメソッド** が用意されいるのでそちらを使いましょう。

> mapは配列の要素を画する際によく利用されるメソッドで、ブロックの最後の要素（メモ）で新しい配列を作ります。
> 
> —  かんたんRuby 

``` ruby
...
  def self.generate_list
    return (1..100).map { |n| generate(n) }
  end
end
```

``` bash
 $ ruby main.rb
Started with run options --seed 44043

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00261s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

うまくいきましたね。あと、Rubyではreturnを省略できるので

``` ruby
...
  def self.generate_list
    (1..100).map { |n| generate(n) }
  end
end
```

``` bash
$ ruby main.rb
Started with run options --seed 7994

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00238s
```

**パイプラインによるループの置き換え** の適用により **eachメソッド** による繰り返し処理を **mapメソッド** を使ったイミュータブルなコレクションパイプライン処理に変えることができました。

> パイプラインによるループの置き換え
> 
> 多くのプログラマと同様に、私もオブジェクトの集合の反復処理にはループを使うように教えられました。しかし言語環境は、よりすぐれた仕組みとしてコレクションのパイプラインを提供するようになりました。
> 
> —  リファクタリング(第2版)
> 

> Rubyに限らず、プログラミングの世界ではしばしばミュータブル（mutable)とイミュータブル（imutable）と言う言葉が登場します。ミュータブルは「変更可能な」という意味で、反対にイミュータブルは「変更できない、不変の」という意味です。
> 
> —  プロを目指す人のためのRuby入門 

``` bash
$ git commit -m 'refactor: パイプラインによるループの置き換え'
```

#### マジックナンバー

最大値は100にしていますが変更することもあるので **マジックナンバーの置き換え** を適用してわかりやすくしておきましょう。

> シンボル定数によるマジックナンバーの置き換え
> 
> 特別な意味を持った数字のリテラルがある。
> 
> 定数を作り、それにふさわしい名前をつけて、そのリテラルを置き換える。
> 
> —  新装版 リファクタリング 

Rubyでは定数は英字の大文字で始まる名前をつけると自動的に定数として扱われます。

``` ruby
class FizzBuzz
  MAX_NUMBER = 100

...

  def self.generate_list
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

意味のわかる定数として宣言しました。コードに直接記述された `100` をといった **数値リテラル** はマジックナンバーと呼ばれ往々にして後で何を意味するものかわからなくなり変更を難しくする原因となります。早めに意味を表す定数にしておきましょう。

> 名前付けされずにプログラム内に直接記述されている数値をマジックナンバーと呼び、一般的には極力避けるようにします。
> 
> —  かんたんRuby 

> いい名前というのは、変数の目的や値を表すものだ。
> 
> —  リーダブルコード 

``` bash
$ ruby main.rb
Started with run options --seed 32408

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00241s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

テストは通りました。でもこのコードは初見の人には分かりづらいのでコメントを入れておきましょう。Rubyの **単一行コメントアウト** のやり方は行頭に `#` を使います。

``` ruby
...
  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

ここではなぜこのような処理を選択したかをコメントしましたが何でもコメントすればよいというわけではありません。

> コメント
> 
> ここでコメントについて言及しているのは、コメントが消臭剤として使われることがあるからです。コメントが非常に丁寧に書かれているのは、実はわかりにくいコードを補うためだったとうことがよくあるのです。
> 
> —  リファクタリング(第2版)
> 

> コメントを書くのであれば、正確に書くべきだ（できるだけ明確で詳細に）。また、コメントには画面の領域を取られるし、読むのにも時間がかかるので、簡潔なものでなければいけない。
> 
> —  リーダブルコード 

``` bash
$ git commit -m 'refactor: マジックナンバーの置き換え'
```

### 動作するきれいなコード

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - ~~5 の倍数のときは｢Buzz｣と返す~~
    
      - ~~5を渡したら文字列"Buzz"を返す~~

  - ~~13 と 5 両方の倍数の場合には｢FizzBuzz｣と返す~~
    
      - ~~15を渡したら文字列FizzBuzzを返す~~

  - ~~1 から 100 までのFizzBuzzの配列を返す~~
    
      - ~~配列の初めは文字列の1を返す~~
    
      - ~~配列の最後は文字列の100を返す~~
    
      - ~~配列の2番めは文字列のFizzを返す~~
    
      - ~~配列の4番目は文字列のBuzzを返す~~
    
      - ~~配列の14番目は文字列のFizzBuzzを返す~~

  - プリントする

**TODOリスト** も残すところあと１つとなりました。これまで `main.rb` ファイル１つだけで開発を行ってきましたがリリースするにはもうひと手間かけたほうがいいでしょうね。libディレクトリを作成したあと `main.rb` ファイルを `fizz_buzz.rb` ファイルに名前を変更してlibディレクトリに移動します。

    /
    |--lib/
        |
         -- fizz_buzz.rb

続いてテストコードをテストディレクトリに保存してプログラム本体とテストコードを分離します

    /
    |--lib/
        |
         -- fizz_buzz.rb
    |--test/
        |
         -- fizz_buzz_test.rb

分離したテストが動くか確認しておきましょう。

``` bash
$ ruby test/fizz_buzz_test.rb
Started with run options --seed 17134

ERROR["test_1を渡したら文字列1を返す", #<Minitest::Reporters::Suite:0x00007fc07a085060 @name="FizzBuzz::その他の場合">, 0.001282999997783918]
 test_1を渡したら文字列1を返す#FizzBuzz::その他の場合 (0.00s)
NameError:         NameError: uninitialized constant FizzBuzzTest::FizzBuzz
        Did you mean?  FizzBuzzTest
            test/fizz_buzz_test.rb:8:in `setup'
...
  19/19: [===============================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.03717s
19 tests, 12 assertions, 0 failures, 9 errors, 0 skips
```

テストファイルからFizzBuzzクラスを読み込めるようにする必要があります。

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fizz_buzz'

class FizzBuzzTest < Minitest::Test
...
```

Rubyで別のファイルを読み込むには **require** を使います。

> requireを使う用途は主に三つあります。
> 
>   - 標準添付ライブラリを読み込む
> 
>   - 第三者が作成しているライブラリを読み込む
> 
>   - 別ファイルに定義した自分のファイルを読み込む
> 
> —  かんたんRuby 

また、**require\_relative**
> という方法も用意されています。どう違うのでしょうか？

> require\_relativeは$LOAD\_PATHの参照は行わず「relative」という名称の通り相対的なパスでファイルの読み込みを行います。
> 
> —  かんたんRuby 

ちょっと何言ってるかわからないうちは **require** を上記のフォルダ構成で使っていてください。一応以下の使い分けがありますが今は頭の隅に留めるだけでいいと思います。

> requireは標準添付ライブラリなどの自分が書いていないコードを読み込む時に使い、こちらのrequire\_relativeは自分の書いたコードを読み込む時に使うように使い分けるのが良いでしょう。
> 
> —  かんたんRuby 

``` bash
$ ruby test/fizz_buzz_test.rb
Started with run options --seed 44438

  19/19: [=================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00279s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

では最後に `main.rb` ファイルを追加して `FizzBuzz:generate_list` を呼び出すようにします。

    /main.rb
      |--lib/
          |
           -- fizz_buzz.rb
      |--test/
          |
           -- fizz_buzz_test.rb

``` ruby
require './lib/fizz_buzz.rb'

puts FizzBuzz.generate_list
```

**puts** は結果を画面に出力するメソッドです。 先程は **p** メソッドを使って画面に **配列** の中身を１件ずつ表示していましたが今回は **配列** 自体を改行して画面に出力するため **puts** メソッドを使います。機能的にはほどんど変わらないのですが以下の様に使い分けるそうです。

> まず、用途としてはputsメソッドとprintメソッドは一般ユーザ向け、pメソッドは開発者向け、というふうに別かれます。
> 
> —  プロを目指す人のためのRuby入門 

``` bash
$ ruby main.rb
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
...
Buzz
```

ちなみに **print** メソッドを使った場合はこのように出力されます。

``` bash
$ ruby main.rb
["1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz", "11", "Fizz", "13", "14", "FizzBuzz", "16", "17", "Fizz", "19", "Buzz", "Fizz", "22", "23", "Fizz", "Buzz", "26", "Fizz", "28", "29", "FizzBuzz", "31", "32", "Fizz", "34", "Buzz", "Fizz", "37", "38", "Fizz", "Buzz", "41", "Fizz", "43", "44", "FizzBuzz", "46", "47", "Fizz", "49", "Buzz", "Fizz", "52", "53", "Fizz", "Buzz", "56", "Fizz", "58", "59", "FizzBuzz", "61", "62", "Fizz", "64", "Buzz", "Fizz", "67", "68", "Fizz", "Buzz", "71", "Fizz", "73", "74", "FizzBuzz", "76", "77", "Fizz", "79", "Buzz", "Fizz", "82", "83", "Fizz", "Buzz", "86", "Fizz", "88", "89", "FizzBuzz", "91", "92", "Fizz", "94", "Buzz", "Fizz", "97", "98", "Fizz", "Buzz"] $
```

プログラムの完成です。コミットしておきましょう。

``` bash
$ git commit -m 'feat: FizzBuzz'
```

TODOリスト

  - ~~数を文字列にして返す~~
    
      - ~~1を渡したら文字列"1"を返す~~
    
      - ~~2を渡したら文字列"2"を返す~~

  - ~~3の倍数のときは数の代わりに｢Fizz｣と返す~~
    
      - ~~3を渡したら文字列"Fizz"を返す~~

  - ~~5 の倍数のときは｢Buzz｣と返す~~
    
      - ~~5を渡したら文字列"Buzz"を返す~~

  - ~~13 と 5 両方の倍数の場合には｢FizzBuzz｣と返す~~
    
      - ~~15を渡したら文字列FizzBuzzを返す~~

  - ~~1 から 100 までのFizzBuzzの配列を返す~~
    
      - ~~配列の初めは文字列の1を返す~~
    
      - ~~配列の最後は文字列の100を返す~~
    
      - ~~配列の2番めは文字列のFizzを返す~~
    
      - ~~配列の4番目は文字列のBuzzを返す~~
    
      - ~~配列の14番目は文字列のFizzBuzzを返す~~

  - ~~プリントする~~

#### ふりかえり

`FizzBuzz` プログラムの最初のバージョンをリリースすることができたのでこれまでのふりかえりをしておきましょう。

まず **TODOリスト** を作成して **テストファースト** で１つずつ小さなステップで開発を進めていきました。 **仮実装を経て本実装へ** の過程で Rubyの **クラス** を定義して **文字列リテラル** を返す **メソッド** を作成しました。この時点でRubyの **オブジェクトとメソッド** という概念に触れています。

> Rubyの世界では、ほぼどのような値もオブジェクトという概念で表されます。オブジェクトという表現はかなり範囲の広い表現方法で、クラスやインスタンスを含めてオブジェクトと称します。
> 
> —  かんたんRuby 

> プログラミング言語においてメソッド、あるいは関数と呼ばれるものを簡単に説明すると処理をひとかたまりにまとめたものと言って良いでしょう。
> 
> —  かんたんRuby 

ちょっと何言ってるかわからないかもしれませんが、今はそういう概念があってこうやって書くのねという程度の理解で十分です。

その後 **リファクタリング** を通じて多くの概念に触れることになりました。 まず **変数名の変更** でRubyにおける **変数**の概念と操作を通じて名前付けの重要性を学びました。

> Rubyでは変数を扱うために特別な宣言やキーワードは必要ありません。「=」 の左辺に任意の変数名を記述するだけで変数宣言となります。
> 
> —  かんたんRuby 

続いて **明白な実装** を通して **制御構造** のうち **条件分岐** のための **if式** と **演算子** を使いプログラムを制御し判定・計算をする方法を学びました。また、**アルゴリズムの置き換え** を適用してコードをよりわかりやすくしました。

> Rubyではプログラムを構成する最小の要素を式と呼びます。変数やリテラル、制御構文、演算子などが式として扱われます。
> 
> —  かんたんRuby 

そして、 **学習用テスト** を通して新しい問題を解決するために **配列オブジェクト** **レンジオブジェクト** といった **文字列リテラル** **数値リテラル** 以外の **データ構造** の使い方を学習して、**配列** を操作するための **制御構造** として **繰り返し処理** を **eachメソッド** を使って実現しました。

> これら「100」や「3.14」といった部分を数値リテラルと呼びます。
> 
> —  かんたんRuby 

> このように文字列をシングルクオートやダブルクオートで括っている表記を文字列リテラルと呼びます。
> 
> —  かんたんRuby 

仕上げは、**コードの不吉な臭い** からさらなる改善を実施しました。 **不思議な名前** の **メソッド** を **自動的テスト**を用意することで自信を持って **リファクタリング** を実施し、**長い関数** に対して **ガード節** を導入し **一時変数** **説明変数** など **変数** バリエーションの取り扱いを学びました。そして、**ループ** と **変更可能なデータ** から **コレクションパイプライン** の使い方と **ミュータブル** **イミュータブル** の概念を学び、**コメント** のやり方と **定数** と **マジックナンバー** の問題を学びました。

最後に、**require** の使い方を通してファイルの分割方法を学ぶことができました。

ちょっと何言ってるかわからない単語ばかり出てきたかもしれませんがこれでRubyの基本の半分は抑えています。自分でFizzBuzzコードが書けて用語の意味が説明できるようになれば技能・学科第一段階の半分ぐらいといったところでしょうか。仮免許取得にはまだ習得しなければならない技術と知識がありますので。

#### 良いコード

以下のコードを作成しました。

**/main.rb.**

``` ruby
require './lib/fizz_buzz.rb'

puts FizzBuzz.generate_list
```

**/lib/fizz\_buzz.rb.**

``` ruby
class FizzBuzz
  MAX_NUMBER = 100

  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz
    number.to_s
  end

  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

**/test/fizz\_buzz\_test.rb.**

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fizz_buzz'

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    def setup
      @fizzbuzz = FizzBuzz
    end

    describe '三の倍数の場合' do
      def test_3を渡したら文字列Fizzを返す
        assert_equal 'Fizz', @fizzbuzz.generate(3)
      end
    end

    describe '五の倍数の場合' do
      def test_5を渡したら文字列Buzzを返す
        assert_equal 'Buzz', @fizzbuzz.generate(5)
      end
    end

    describe '三と五の倍数の場合' do
      def test_15を渡したら文字列FizzBuzzを返す
        assert_equal 'FizzBuzz', @fizzbuzz.generate(15)
      end
    end

    describe 'その他の場合' do
      def test_1を渡したら文字列1を返す
        assert_equal '1', @fizzbuzz.generate(1)
      end
    end

    describe '1から100までのFizzBuzzの配列を返す' do
      def setup
        @result = FizzBuzz.generate_list
      end

      def test_配列の初めは文字列の1を返す
        assert_equal '1', @result.first
      end

      def test_配列の最後は文字列のBuzzを返す
        assert_equal 'Buzz', @result.last
      end

      def test_配列の2番目は文字列のFizzを返す
        assert_equal 'Fizz', @result[2]
      end

      def test_配列の4番目は文字列のBuzzを返す
        assert_equal 'Buzz', @result[4]
      end

      def test_配列の14番目は文字列のFizzBuzzを返す
        assert_equal 'FizzBuzz', @result[14]
      end
    end
  end

  describe '配列や繰り返し処理を理解する' do
    def test_繰り返し処理
      $stdout = StringIO.new
      [1, 2, 3].each { |i| p i * i }
      output = $stdout.string

      assert_equal "1\n" + "4\n" + "9\n", output
    end

    def test_特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].select(&:integer?)
      assert_equal [2, 4], result
    end

    def test_特定の条件を満たす要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].find_all(&:integer?)
      assert_equal [2, 4], result
    end

    def test_特定の条件を満たさない要素だけを配列に入れて返す
      result = [1.1, 2, 3.3, 4].reject(&:integer?)
      assert_equal [1.1, 3.3], result
    end

    def test_新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].map(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_新しい要素の配列を返す
      result = %w[apple orange pineapple strawberry].collect(&:size)
      assert_equal [5, 6, 9, 10], result
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].find(&:size)
      assert_equal 'apple', result
    end

    def test_配列の中から条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry].detect(&:size)
      assert_equal 'apple', result
    end

    def test_指定した評価式で並び変えた配列を返す
      assert_equal %w[1 10 13 2 3 4], %w[2 4 13 3 1 10].sort
      assert_equal %w[1 2 3 4 10 13],
                   %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i }
      assert_equal %w[13 10 4 3 2 1],
                   %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i }
    end

    def test_配列の中から、条件に一致する要素を取得する
      result = %w[apple orange pineapple strawberry apricot].grep(/^a/)
      assert_equal %w[apple apricot], result
    end

    def test_ブロック内の条件式が真である間までの要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9].take_while { |item| item < 6 }
      assert_equal [1, 2, 3, 4, 5], result
    end

    def test_ブロック内の条件式が真である以降の要素を返す
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].drop_while { |item| item < 6 }
      assert_equal [6, 7, 8, 9, 10], result
    end

    def test_畳み込み演算を行う
      result = [1, 2, 3, 4, 5].inject(0) { |total, n| total + n }
      assert_equal 15, result
    end

    def test_畳み込み演算を行う
      result = [1, 2, 3, 4, 5].reduce { |total, n| total + n }
      assert_equal 15, result
    end
  end
end
```

どうでしょう、学習用テストは除くとしてプロダクトコードに対して倍以上のテストコードを作っていますよね。テストコードを作らず一発で `fizz_buzz.rb` のようなコードを書くことはできますか？ たしかに [fizz buzz ruby](https://www.google.com/search?hl=ja&sxsrf=ACYBGNTdUEAzXtUgi9nlBCK6fnpac2rtIg%3A1579588091710&source=hp&ei=-5kmXs7SKIPnwQO9rYbgBA&q=fizz+buzz+ruby&oq=fizz&gs_l=psy-ab.3.0.35i39l3j0l3j0i131j0.636.1384..2671...1.0..0.205.540.1j2j1......0....1..gws-wiz.......0i4j0i131i4.du79cnj-Ge4) といったキーワードで検索すればサンプルコードは見つかるのでコピーして同じ振る舞いをするコードをすぐに書くことはできるでしょう。でも仕様が追加された場合はどうしましょう。

仕様

    1 から 100 までの数をプリントするプログラムを書け。
    ただし 3 の倍数のときは数の代わりに｢Fizz｣と、5 の倍数のときは｢Buzz｣とプリントし、
    3 と 5 両方の倍数の場合には｢FizzBuzz｣とプリントすること。
    タイプごとに出力を切り替えることができる。
    タイプ１は通常、タイプ２は数字のみ、タイプ３は FizzBuzz の場合のみをプリントする。

また同じようなコードサンプルを探しますか？私ならば **TODOリスト** に以下の項目を追加することから始めます。

TODOリスト

  - タイプ1の場合
    
      - 数を文字列にして返す
        
          - 1を渡したら文字列"1"を返す

次に何をやるかはもうわかりますよね。テスト駆動開発とはただ失敗するテストを１つずつ書いて通していくことではありません。

> TDDは分析技法であり、設計技法であり、実際には開発のすべてのアクティビティを構造化する技法なのだ。
> 
> —  テスト駆動開発 

ではテストファーストで書けば質の高い良いコードがかけるようになるのでしょうか？以下のコードを見てください。

``` ruby
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'

class FizzBuzz
  # fizz_buzzメソッドを実行する
  def self.fizz_buzz(n)
  a = n.to_s
    if n % 3 == 0
      a = 'Fizz'
    if n % 15 == 0
      a = 'FizzBuzz'
    end
        elsif n % 5 == 0
          a = 'Buzz'
        end
           a
  end

# 1から100までをプリントする
  def self.print_1_to_100
              n = []
    (1..100).each do |i|
  n << fizz_buzz(i)
                        end
  n
  end
end

class FizzBuzzTest < Minitest::Test
  describe 'FizzBuzz' do
    def setup
      @p = FizzBuzz
    end

      def test_15を渡したら文字列pを返す
        assert_equal 'FizzBuzz', FizzBuzz.fizz_buzz(15)
      end
      def test_3を渡したら文字列3を返す
        assert_equal 'Fizz', FizzBuzz.fizz_buzz(3)
      end
      def test_1を渡したら文字列1を返す
        assert_equal '1', @p.fizz_buzz(1)
      end
      def test_5を渡したら文字列Buzzを返す
        assert_equal 'Buzz', FizzBuzz.fizz_buzz(5)
      end

    describe '1から100までプリントする' do
  def setup
    @x = FizzBuzz.print_1_to_100
  end

  def test_配列の4番目は文字列のをBuzz返す
    assert_equal 'Buzz', @x[4]
  end

      def test_配列の初めは文字列の1を返す
        assert_equal '1', @x.first
      end

      def test_配列の最後は文字列のBuzzを返す
        assert_equal 'Buzz', FizzBuzz.print_1_to_100.last
      end

def test_配列の14番目は文字列のFizzBuzz返す
  assert_equal 'FizzBuzz', @x[14]
end
  def test_配列の2番目は文字列の2を返す
    assert_equal 'Fizz', @x[2]
  end

    end
  end
end
```

``` bash
$ ruby test/fizz_buzz_tfd_test.rb
Started with run options --seed 43131

  9/9: [===================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00135s
9 tests, 9 assertions, 0 failures, 0 errors, 0 skips
```

プログラムは動くしテストも通ります。でもこれはテスト駆動開発で作られたと言えるでしょうか？質の高い良いコードでしょうか？何が足りないかはわかりますよね。

> テスト駆動開発における質の向上の手段は、リファクタリングによる継続的でインクリメンタルな設計であり、「単なるテストファースト」と「テスト駆動開発」の違いはそこにあります。
> 
> —  テスト駆動開発 付録C 訳者解説 

そもそも良いコードは何なのでしょうか？いくつかの見解があるようです。

> TDDは「より良いコードを書けば、よりうまくいく」という素朴で奇妙な仮設によって成り立っている
> 
> —  テスト駆動開発
> 

> 「動作するきれいなコード」。RonJeffriesのこの簡潔な言葉が、テスト駆動開発(TDD)のゴールだ。動作するきれいなコードはあらゆる意味で価値がある。
> 
> —  テスト駆動開発 

> 良いコードかどうかは、変更がどれだけ容易なのかで決まる。
> 
> —  リファクタリング(第2版) 

> コードは理解しやすくなければいけない。
> 
> —  リーダブルコード 

> コードは他の人が最短時間で理解できるように書かなければいけない。
> 
> —  リーダブルコード 

> 優れたソースコードは「目に優しい」ものでなければいけない。
> 
> —  リーダブルコード


少なくともテスト駆動開発のゴールに良いコードがあるということはいえるでしょう。え？どうやったら良いコードを書けるようになるかって？私が教えてほしいのですがただ言えることは他の分野と同様に規律の習得と絶え間ない練習と実践の積み重ねのむこうにあるのだろうということだけです。

> 私がかつて発見した、そして多くの人に気づいてもらいたい効果とは、反復可能な振る舞いを規則にまで還元することで、規則の適用は機会的に反復可能になるということだ。
> 
> —  テスト駆動開発 

>ここで、Kent Beckが自ら語ったセリフを思い出しました。「僕は、偉大なプログラマなんかじゃない。偉大な習慣を身につけた少しましなプログラマなんだ」。
> 
> —  リファクタリング(第2版) 

# エピソード2

## 自動化から始めるテスト駆動開発

エピソード1ではテスト駆動開発のゴールが **動作するきれいなコード** であることを学びました。
では、良いコードを書き続けるためには何が必要になるでしょうか？それは
[ソフトウェア開発の三種の神器](https://t-wada.hatenablog.jp/entry/clean-code-that-works)
と呼ばれるものです。

> 今日のソフトウェア開発の世界において絶対になければならない3つの技術的な柱があります。
> 三本柱と言ったり、三種の神器と言ったりしていますが、それらは
> 
>   - バージョン管理
> 
>   - テスティング
> 
>   - 自動化
> 
> の3つです。
> 
> —  https://t-wada.hatenablog.jp/entry/clean-code-that-works 

**バージョン管理** と **テスティング** に関してはエピソード1で触れました。本エピソードでは最後の **自動化**
に関しての解説と次のエピソードに備えたセットアップ作業を実施しておきたいと思います。ですがその前に
**バージョン管理** で1つだけ解説しておきたいことがありますのでそちらから進めて行きたいと思います。

### コミットメッセージ

これまで作業の区切りにごとにレポジトリにコミットしていましたがその際に以下のような書式でメッセージを書いていました。

``` bash
git commit -m 'refactor: メソッドの抽出'
```

この書式は
[Angularルール](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#type)に従っています。具体的には、それぞれのコミットメッセージはヘッダ、ボディ、フッタで構成されています。ヘッダはタイプ、スコープ、タイトルというフォーマットで構成されています。

    <タイプ>(<スコープ>): <タイトル>
    <空行>
    <ボディ>
    <空行>
    <フッタ>

ヘッダは必須です。 ヘッダのスコープは任意です。 コミットメッセージの長さは50文字までにしてください。

(そうすることでその他のGitツールと同様にGitHub上で読みやすくなります。)

コミットのタイプは次を用いて下さい。

  - feat: A new feature (新しい機能)

  - fix: A bug fix (バグ修正)

  - docs: Documentation only changes (ドキュメント変更のみ)

  - style: Changes that do not affect the meaning of the code
    (white-space, formatting, missing semi-colons, etc) (コードに影響を与えない変更)

  - refactor: A code change that neither fixes a bug nor adds a feature
    (機能追加でもバグ修正でもないコード変更)

  - perf: A code change that improves performance (パフォーマンスを改善するコード変更)

  - test: Adding missing or correcting existing tests
    (存在しないテストの追加、または既存のテストの修正)

  - chore: Changes to the build process or auxiliary tools and libraries
    such as documentation generation
    (ドキュメント生成のような、補助ツールやライブラリやビルドプロセスの変更)

コミットメッセージにつけるプリフィックスに関しては [【今日からできる】コミットメッセージに 「プレフィックス」
をつけるだけで、開発効率が上がった話](https://qiita.com/numanomanu/items/45dd285b286a1f7280ed)
を参照ください。

### パッケージマネージャ

では **自動化** の準備に入りたいのですがそのためにはいくつかの外部プログラムを利用する必要があります。そのためのツールが
**RubyGems**
> です。

> RubyGemsとは、Rubyで記述されたサードパーティ製のライブラリを管理するためのツールで、RubyGemsで扱うライブラリをgemパッケージと呼びます。
> 
> —  かんたんRuby 

**RubyGems** はすでに何度か使っています。例えばエピソード1の初めの `minitest-reporters`
のインストールなどです。

``` bash
$ gem install minitest-reporters
```

では、これからもこのようにして必要な外部プログラムを一つ一つインストールしていくのでしょうか？また、開発用マシンを変えた時にも同じことを繰り返さないといけないのでしょうか？面倒ですよね。そのような面倒なことをしないで済む仕組みがRubyには用意されています。それが
**Bundler**
> です。

> Bundlerとは、作成したアプリケーションがどのgemパッケージに依存しているか、そしてインストールしているバージョンはいくつかという情報を管理するためのgemパッケージです。
> 
> —  かんたんRuby 

**Bundler** をインストールしてgemパッケージを束ねましょう。

``` bash
gem install bundler
bundle init
```

`Gemfile` が作成されます。

``` ruby
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"
```

`# gem "rails"` の部分を以下の様に書き換えます。

``` ruby
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rubocop', require: false
```

書き換えたら `bundle install` でgemパッケージをインストールします。

``` bash
$ bundle install
Fetching gem metadata from https://rubygems.org/....................
Resolving dependencies...
Using ast 2.4.0
Using bundler 2.1.4
Using jaro_winkler 1.5.4
Using parallel 1.19.1
Fetching parser 2.7.0.2
Installing parser 2.7.0.2
Using rainbow 3.0.0
Using ruby-progressbar 1.10.1
Fetching unicode-display_width 1.6.1
Installing unicode-display_width 1.6.1
Fetching rubocop 0.79.0
Installing rubocop 0.79.0
Bundle complete! 1 Gemfile dependency, 9 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

これで次の準備ができました。

### 静的コード解析

良いコードを書き続けるためにはコードの品質を維持していく必要があります。エピソード1では **テスト駆動開発**
によりプログラムを動かしながら品質の改善していきました。出来上がったコードに対する品質チェックの方法として
**静的コード解析** があります。Ruby用 **静的コード解析** ツール
[RuboCop](https://github.com/rubocop-hq/rubocop) を使って確認してみましょう。プログラムは先程
**Bundler** を使ってインストールしたので以下のコマンドを実行します。

``` bash
 $ rubocop
Inspecting 5 files
CCCWW

Offenses:

Gemfile:3:8: C: Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
source "https://rubygems.org"
       ^^^^^^^^^^^^^^^^^^^^^^
Gemfile:5:21: C: Layout/SpaceInsideBlockBraces: Space between { and | missing.
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }
                    ^^
...
```

なにかいろいろ出てきましたね。RuboCopの詳細に関しては [RuboCop is
何？](https://qiita.com/tomohiii/items/1a17018b5a48b8284a8b)を参照ください。`--lint`
オプションをつけて実施してみましょう。

``` bash
$ rubocop --lint
Inspecting 5 files
...W.

Offenses:

test/fizz_buzz_test.rb:109:7: : Parenthesize the param %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i } to make sure that the block will be associated with the %w[2 4 13 3 1 10].sort method call.
      assert_equal %w[1 2 3 4 10 13], ...
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
test/fizz_buzz_test.rb:111:7: W: Lint/AmbiguousBlockAssociation: Parenthesize the param %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i } to make sure that the block will be associated with the %w[2 4 13 3 1 10].sort method call.
      assert_equal %w[13 10 4 3 2 1], ...
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

5 files inspected, 2 offenses detected
```

また何やら出てきましたね。 [W:
Lint/AmbiguousBlockAssociation](https://rubocop.readthedocs.io/en/latest/cops_lint/#lintambiguousblockassociation)のメッセージを調べたところ、`fizz_buzz_test.rb`
の以下の学習用テストコードは書き方がよろしくないようですね。

``` ruby
...
      def test_指定した評価式で並び変えた配列を返す
        assert_equal %w[1 10 13 2 3 4], %w[2 4 13 3 1 10].sort
        assert_equal %w[1 2 3 4 10 13],
                     %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i }
        assert_equal %w[13 10 4 3 2 1],
                     %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i }
      end
...
```

**説明用変数の導入** を使ってテストコードをリファクタリングしておきましょう。

``` ruby
...
    def test_指定した評価式で並び変えた配列を返す
      result1 = %w[2 4 13 3 1 10].sort
      result2 = %w[2 4 13 3 1 10].sort { |a, b| a.to_i <=> b.to_i }
      result3 = %w[2 4 13 3 1 10].sort { |b, a| a.to_i <=> b.to_i }

      assert_equal %w[1 10 13 2 3 4], result1
      assert_equal %w[1 2 3 4 10 13], result2
      assert_equal %w[13 10 4 3 2 1], result3
    end
...
```

再度確認します。チェックは通りましたね。

``` bash
$ rubocop --lint
Inspecting 5 files
.....

5 files inspected, no offenses detected
```

テストも実行して壊れていないかも確認しておきます。

``` bash
$ ruby test/fizz_buzz_test.rb
Started with run options --seed 42058

  19/19: [=========================================================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00257s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

いちいち調べるのも手間なので自動で修正できるところは修正してもらいましょう。

``` bash
$ rubocop --auto-correct
```

再度確認します。

``` bash
 $ rubocop
Inspecting 5 files
...CC

Offenses:

test/fizz_buzz_test.rb:15:11: C: Naming/MethodName: Use snake_case for method names.
      def test_3を渡したら文字列Fizzを返す
          ^^^^^^^^^^^^^^^^^^^^^
...
```

まだ、自動修正できなかった部分があるようですね。この部分はチェック対象から外すことにしましょう。

``` bash
$ rubocop --auto-gen-config
Added inheritance from `.rubocop_todo.yml` in `.rubocop.yml`.
Phase 1 of 2: run Layout/LineLength cop
Inspecting 5 files
.....

5 files inspected, no offenses detected
Created .rubocop_todo.yml.
Phase 2 of 2: run all cops
Inspecting 5 files
.C.CW

5 files inspected, 110 offenses detected
Created .rubocop_todo.yml.
```

生成された `.rubocop_todo.yml` の以下の部分を変更します。

``` yml
...
# Offense count: 32
# Configuration parameters: IgnoredPatterns.
# SupportedStyles: snake_case, camelCase
Naming/MethodName:
  EnforcedStyle: snake_case
  Exclude:
    - 'test/fizz_buzz_test.rb'
...
```

再度チェックを実行します。

``` bash
$ rubocop
Inspecting 5 files
.....

5 files inspected, no offenses detected
```

### コードフォーマッタ

良いコードであるためにはフォーマットも大切な要素です。

> 優れたソースコードは「目に優しい」ものでなければいけない。
> 
> —  リーダブルコード 

Rubyにはいくつかフォーマットアプリケーションはあるのですがここは `RuboCop`
の機能を使って実現することにしましょう。以下のコードのフォーマットをわざと崩してみます。

``` ruby
class FizzBuzz
  MAX_NUMBER = 100

  def self.generate(number)
          isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz

    number.to_s
  end

  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

スタイルオプションをつけてチェックしてみます。

``` bash
$ rubocop --only Layout
Inspecting 5 files
.C...

Offenses:

lib/fizz_buzz.rb:7:3: C: Layout/IndentationWidth: Use 2 (not 8) spaces for indentation.
          isFizz = number.modulo(3).zero?
  ^^^^^^^^
lib/fizz_buzz.rb:8:5: C: Layout/IndentationConsistency: Inconsistent indentation detected.
    isBuzz = number.modulo(5).zero?
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:10:5: C: Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'FizzBuzz' if isFizz && isBuzz
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:11:5: C: Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'Fizz' if isFizz
    ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:12:5: C: Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'Buzz' if isBuzz
    ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:14:5: C: Layout/IndentationConsistency: Inconsistent indentation detected.
    number.to_s
    ^^^^^^^^^^^

5 files inspected, 6 offenses detected
```

編集した部分が `Use 2 (not 8) spaces for indentation.` と指摘されています。
`--fix-layout` オプションで自動保存しておきましょう。

``` bash
$ rubocop --fix-layout
Inspecting 5 files
.C...

Offenses:

lib/fizz_buzz.rb:7:3: C: [Corrected] Layout/IndentationWidth: Use 2 (not 8) spaces for indentation.
          isFizz = number.modulo(3).zero?
  ^^^^^^^^
lib/fizz_buzz.rb:8:5: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
    isBuzz = number.modulo(5).zero?
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:8:11: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
          isBuzz = number.modulo(5).zero?
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:10:5: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'FizzBuzz' if isFizz && isBuzz
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:10:11: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
          return 'FizzBuzz' if isFizz && isBuzz
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:11:5: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'Fizz' if isFizz
    ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:11:11: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
          return 'Fizz' if isFizz
          ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:12:5: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
    return 'Buzz' if isBuzz
    ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:12:11: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
          return 'Buzz' if isBuzz
          ^^^^^^^^^^^^^^^^^^^^^^^
lib/fizz_buzz.rb:14:5: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
    number.to_s
    ^^^^^^^^^^^
lib/fizz_buzz.rb:14:11: C: [Corrected] Layout/IndentationConsistency: Inconsistent indentation detected.
          number.to_s
          ^^^^^^^^^^^

5 files inspected, 11 offenses detected, 11 offenses corrected
```

``` ruby
class FizzBuzz
  MAX_NUMBER = 100

  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz

    number.to_s
  end

  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

``` bash
$ rubocop --only Layout
Inspecting 5 files
.....

5 files inspected, no offenses detected
```

フォーマットが修正されたことが確認できましたね。ちなみに `--auto-correct`
オプションでもフォーマットをしてくれるので通常はこちらのオプションで問題ないと思います。ここまでの作業をコミットしておきましょう。

``` bash
$ git add .
$ git commit -m 'chore: 静的コード解析セットアップ'
```

### コードカバレッジ

静的コードコード解析による品質の確認はできました。では動的なテストに関してはどうでしょうか？ **コードカバレッジ** を確認する必要あります。

> コード網羅率（コードもうらりつ、英: Code coverage
> ）コードカバレッジは、ソフトウェアテストで用いられる尺度の1つである。プログラムのソースコードがテストされた割合を意味する。この場合のテストはコードを見ながら行うもので、ホワイトボックステストに分類される。
> 
> —  ウィキペディア 

Ruby用 **コードカバレッジ** 検出プログラムとして
[SimpleCov](https://github.com/colszowka/simplecov)を使います。Gemfileに追加して
**Bundler** でインストールをしましょう。

``` ruby
# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'minitest'
gem 'minitest-reporters'
gem 'rubocop', require: false
gem 'simplecov', require: false, group: :test
```

``` bash
$ bundle install
Fetching gem metadata from https://rubygems.org/..................
Resolving dependencies...
Fetching ansi 1.5.0
Installing ansi 1.5.0
Using ast 2.4.0
Fetching builder 3.2.4
Installing builder 3.2.4
Using bundler 2.1.4
Using docile 1.3.2
Using jaro_winkler 1.5.4
Using json 2.3.0
Fetching minitest 5.14.0
Installing minitest 5.14.0
Using ruby-progressbar 1.10.1
Fetching minitest-reporters 1.4.2
Installing minitest-reporters 1.4.2
Using parallel 1.19.1
Using parser 2.7.0.2
Using rainbow 3.0.0
Using unicode-display_width 1.6.1
Using rubocop 0.79.0
Using simplecov-html 0.10.2
Using simplecov 0.17.1
Bundle complete! 4 Gemfile dependencies, 17 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

サイトの説明に従ってテストコードの先頭に以下のコードを追加します。

``` ruby
# frozen_string_literal: true
require 'simplecov'
SimpleCov.start
require 'minitest/reporters'
Minitest::Reporters.use!
require 'minitest/autorun'
require './lib/fizz_buzz'
...
```

テストを実施します。

``` bash
$ ruby test/fizz_buzz_test.rb
Started with run options --seed 10538

  19/19: [===============================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00297s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

テスト実行後に `coverage` というフォルダが作成されます。その中の `index.html`
を開くとカバレッジ状況を確認できます。セットアップが完了したらコミットしておきましょう。

``` bash
$ git commit -m 'chore: コードカバレッジセットアップ'
```

### タスクランナー

ここまででテストの実行、静的コード解析、コードフォーマット、コードカバレッジを実施することができるようになりました。でもコマンドを実行するのにそれぞれコマンドを覚えておくのは面倒ですよね。例えばテストの実行は

``` bash
$ ruby test/fizz_buzz_test.rb
Started with run options --seed 21943

  19/19: [=======================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00261s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

このようにしていました。では静的コードの解析はどうやりましたか？フォーマットはどうやりましたか？調べるのも面倒ですよね。いちいち調べるのが面倒なことは全部
**タスクランナー** にやらせるようにしましょう。

> タスクランナーとは、アプリケーションのビルドなど、一定の手順で行う作業をコマンド一つで実行できるように予めタスクとして定義したものです。
> 
> —  かんたんRuby 

Rubyの **タスクランナー** は `Rake`
> です。

> RakeはRubyにおけるタスクランナーです。rakeコマンドと起点となるRakefileというタスクを記述するファイルを用意することで、タスクの実行や登録されたタスクの一覧表示を行えます。
> 
> —  かんたんRuby 

早速、テストタスクから作成しましょう。まず `Rakefile` を作ります。

``` bash
$ touch Rakefile
```

``` ruby
require 'rake/testtask'

task default: [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['./test/fizz_buzz_test.rb']
  test.verbose = true
end
```

タスクが登録されたか確認してみましょう。

``` bash
$ rake -T
rake test  # Run tests
```

タスクが登録されたことが確認できたのでタスクを実行します。

``` bash
$ rake test
/Users/k2works/.rbenv/versions/2.5.5/bin/ruby -w -I"lib" -I"/Users/k2works/.rbenv/versions/2.5.5/lib/ruby/gems/2.5.0/gems/rake-13.0.1/lib" "/Users/k2works/.rbenv/versions/2.5.5/lib/ruby/gems/2.5.0/gems/rake-13.0.1/lib/rake/rake_test_loader.rb" "./test/fizz_buzz_test.rb"
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:79: warning: method redefined; discarding old test_特定の条件を満たす要素だけを配列に入れて返す
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:74: warning: previous definition of test_特定の条件を満たす要素だけを配列に入れて返す was here
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:94: warning: method redefined; discarding old test_新しい要素の配列を返す
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:89: warning: previous definition of test_新しい要素の配列を返す was here
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:104: warning: method redefined; discarding old test_配列の中から条件に一致する要素を取得する
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:99: warning: previous definition of test_配列の中から条件に一致する要素を取得する was here
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:138: warning: method redefined; discarding old test_畳み込み演算を行う
/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:133: warning: previous definition of test_畳み込み演算を行う was here
Started with run options --seed 5886

  19/19: [=======================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00271s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips
```

テストタスクが実行されたことが確認できたので引き続き静的コードの解析タスクを追加します。こちらも開発元がタスクを用意しているのでそちらを使うことにします。

``` ruby
require 'rake/testtask'
require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['./test/fizz_buzz_test.rb']
  test.verbose = true
end
```

タスクが登録されたことを確認します。

``` bash
$ rake -T
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake test                  # Run tests
```

続いてタスクを実行してみましょう。

``` bash
$ rake rubocop
Running RuboCop...
Inspecting 5 files
.C...

Offenses:

Rakefile:1:1: C: Style/FrozenStringLiteralComment: Missing magic comment # frozen_string_literal: true.
require 'rake/testtask'
^

5 files inspected, 1 offense detected
RuboCop failed!
```

いろいろ出てきましたので自動修正しましょう。

``` bash
$ rake rubocop:auto_correct
Running RuboCop...
Inspecting 5 files
.C...

Offenses:

Rakefile:1:1: C: [Corrected] Style/FrozenStringLiteralComment: Missing magic comment # frozen_string_literal: true.
require 'rake/testtask'
^
Rakefile:2:1: C: [Corrected] Layout/EmptyLineAfterMagicComment: Add an empty line after magic comments.
require 'rake/testtask'
^

5 files inspected, 2 offenses detected, 2 offenses corrected
```

``` ruby
$ rake rubocop
Running RuboCop...
Inspecting 5 files
.....

5 files inspected, no offenses detected
```

うまく修正されたようですね。後、フォーマットコマンドもタスクとして追加しておきましょう。こちらは開発元が用意していないタスクなので以下のように追加します。

``` ruby
# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir['./test/fizz_buzz_test.rb']
  test.verbose = true
end

desc "Run Format"
task :format do
  sh "rubocop --fix-layout"
end
```

``` bash
$ rake -T
rake format                # Run Format
rake rubocop               # Run RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake test                  # Run tests
```

``` bash
$ rake format
rubocop --fix-layout
Inspecting 5 files
.C...

Offenses:

Rakefile:17:4: C: [Corrected] Layout/TrailingEmptyLines: Final newline missing.
end


5 files inspected, 1 offense detected, 1 offense corrected
```

フォーマットは `rake rubocop:auto_correct`
で一緒にやってくれるので特に必要は無いのですがプログラムの開発元が提供していないタスクを作りたい場合はこのように追加します。セットアップができたのでコミットしておきましょう。

``` bash
$ git commit -m 'chore: タスクランナーセットアップ'
```

### タスクの自動化

良いコードを書くためのタスクをまとめることができました。でも、どうせなら自動で実行できるようにしたいですよね。
タスクを自動実行するためのgemを追加します。
[Guard](https://github.com/guard/guard)とそのプラグインの
[Guard::Shell](https://github.com/guard/guard-shell)
[Guard::Minitest](https://github.com/guard/guard-minitest)をインストールします。それぞれの詳細は以下を参照してください。

  - [Ruby | Guard gem
    を利用してファイルの変更を検出し、任意のタスクを自動実行する](https://qiita.com/tbpgr/items/f5be21d8e19dd852d9b7)

  - [guard-shellでソースコードの変更を監視して自動でmake＆実行させる](https://qiita.com/emergent/items/0a38909206844265e0b5)

  - [Rails -
    Guardを使い、ファイル変更時にMinitestやRspecを自動実行する](https://forest-valley17.hatenablog.com/entry/2018/10/05/183521)

<!-- end list -->

``` ruby
# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'guard'
gem 'guard-minitest'
gem 'guard-shell'
gem 'minitest'
gem 'minitest-reporters'
gem 'rake'
gem 'rubocop', require: false
gem 'simplecov', require: false, group: :test
```

`bundle install` は `bundle` に省略できます。

``` bash
$ bundle
$ guard init
```

`Guardfile` が生成されるので以下の内容に変更します。

``` ruby
# frozen_string_literal: true

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(/(.*).rb/) { |_m| `rake rubocop:auto_correct` }
  watch(%r{lib/(.*).rb}) { |_m| `rake test` }
end

guard :minitest do
  # with Minitest::Unit
  watch(%r{test\/*.rb})
end
```

`guard` が起動するか確認して一旦終了します。

``` bash
$ guard start
Warning: you have a Gemfile, but you're not using bundler or RUBYGEMS_GEMDEPS
20:42:15 - INFO -
> [#] Guard here! It looks like your project has a Gemfile, yet you are running
> [#] `guard` outside of Bundler. If this is your intent, feel free to ignore this
> [#] message. Otherwise, consider using `bundle exec guard` to ensure your
> [#] dependencies are loaded correctly.
> [#] (You can run `guard` with --no-bundler-warning to get rid of this message.)
WARN: Unresolved specs during Gem::Specification.reset:
      rb-inotify (>= 0.9.10, ~> 0.9)
      minitest (>= 3.0)
WARN: Clearing out unresolved specs.
Please report a bug if this causes problems.
20:42:16 - INFO - Guard::Minitest 2.4.6 is running, with Minitest::Unit 5.14.0!
20:42:16 - INFO - Running: all tests
Started with run options --guard --seed 47998

  19/19: [=======================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00262s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips

20:42:16 - INFO - Guard is now watching at '/Users/k2works/Projects/hiroshima-arc/tdd_
rb/docs/src/article/code'
[1] guard(main)> exit

20:42:25 - INFO - Bye bye...
```

続いて `Rakefile` にguardタスクを追加します。あと、guardタスクをデフォルトにして `rake`
を実行すると呼び出されるようにしておきます。

``` ruby
# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:guard]

Rake::TestTask.new do |test|
  test.test_files = Dir['./test/fizz_buzz_test.rb']
  test.verbose = true
end

desc 'Run Format'
task :format do
  sh 'rubocop --fix-layout'
end

desc 'Run Guard'
task :guard do
  sh 'guard start'
end
```

自動実行タスクを起動しましょう。

``` bash
$ rake
guard start
Warning: you have a Gemfile, but you're not using bundler or RUBYGEMS_GEMDEPS
20:43:17 - INFO -
> [#] Guard here! It looks like your project has a Gemfile, yet you are running
> [#] `guard` outside of Bundler. If this is your intent, feel free to ignore this
> [#] message. Otherwise, consider using `bundle exec guard` to ensure your
> [#] dependencies are loaded correctly.
> [#] (You can run `guard` with --no-bundler-warning to get rid of this message.)
WARN: Unresolved specs during Gem::Specification.reset:
      rb-inotify (>= 0.9.10, ~> 0.9)
      minitest (>= 3.0)
WARN: Clearing out unresolved specs.
Please report a bug if this causes problems.
20:43:18 - INFO - Guard::Minitest 2.4.6 is running, with Minitest::Unit 5.14.0!
20:43:18 - INFO - Running: all tests
Started with run options --guard --seed 36344

  19/19: [=======================================] 100% Time: 00:00:00, Time: 00:00:00

Finished in 0.00267s
19 tests, 21 assertions, 0 failures, 0 errors, 0 skips

20:43:18 - INFO - Guard is now watching at '/Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code'
[1] guard(main)>
```

起動したら `fizz_buzz.rb` を編集してテストが自動実行されるか確認しましょう。

``` ruby
class FizzBuzz
  MAX_NUMBER = 100

  def self.generate(number)
    isFizz = number.modulo(3).zero?
    isBuzz = number.modulo(5).zero?

    return 'FizzBuzzBuzz' if isFizz && isBuzz
    return 'Fizz' if isFizz
    return 'Buzz' if isBuzz

    number.to_s
  end

  def self.generate_list
    # 1から最大値までのFizzBuzz配列を1発で作る
    (1..MAX_NUMBER).map { |n| generate(n) }
  end
end
```

``` bash
...
Running RuboCop...
Inspecting 6 files
......

6 files inspected, no offenses detected
Started with run options --seed 48715


 FAIL["test_15を渡したら文字列FizzBuzzを返す", #<Minitest::Reporters::Suite:0x00007f822b9977f8 @name="FizzBuzz::三と五の倍数の場合">, 0.0016849999956320971]
 test_15を渡したら文字列FizzBuzzを返す#FizzBuzz::三と五の倍数の場合 (0.00s)
        Expected: "FizzBuzz"
          Actual: "FizzBuzzBuzz"
        /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:28:in `test_15を渡したら文字列FizzBuzzを返す'

 FAIL["test_配列の14番目は文字列のFizzBuzzを返す", #<Minitest::Reporters::Suite:0x00007f822b984ae0 @name="FizzBuzz::1から100までのFizzBuzzの配列を返す">, 0.0028389999934006482]
 test_配列の14番目は文字列のFizzBuzzを返す#FizzBuzz::1から100までのFizzBuzzの配列を返す (0.00s)
        Expected: "FizzBuzz"
          Actual: "FizzBuzzBuzz"
        /Users/k2works/Projects/hiroshima-arc/tdd_rb/docs/src/article/code/test/fizz_buzz_test.rb:60:in `test_配列の14番目は文字列のFizzBuzzを返す'

==========================================================================|

Finished in 0.00361s
19 tests, 21 assertions, 2 failures, 0 errors, 0 skips
[1] guard(main)>
```

変更を感知してテストが実行されるた結果失敗していましました。コードを元に戻してテストをパスするようにしておきましょう。テストがパスすることが確認できたらコミットしておきます。

``` bash
$ git commit -m 'chore: タスクの自動化'
```

これで
[ソフトウェア開発の三種の神器](https://t-wada.hatenablog.jp/entry/clean-code-that-works)の最後のアイテムの準備ができました。次回の開発からは最初にコマンドラインで
`rake`
を実行すれば良いコードを書くためのタスクを自動でやってくるようになるのでコードを書くことに集中できるようになりました。では、次のエピソードに進むとしましょう。


# 参照

## 参考サイト

  - [50
    分でわかるテスト駆動開発](https://channel9.msdn.com/Events/de-code/2017/DO03?ocid=player)

  - [サルでもわかるGit入門〜バージョン管理を使いこなそう〜](https://backlog.com/ja/git-tutorial/)

  - [プログラミング言語 Ruby リファレンスマニュアル](https://docs.ruby-lang.org/ja/)

  - [検索結果を要チェック！Rubyの公式リファレンスは docs.ruby-lang.org です
    〜公式な情報源を調べるクセを付けよう〜](https://qiita.com/jnchito/items/2dc760ee0716ea12bbf0)

  - [動作するきれいなコード: SeleniumConf Tokyo 2019
    基調講演文字起こし+α](https://t-wada.hatenablog.jp/entry/clean-code-that-works)

  - [RuboCop](https://github.com/rubocop-hq/rubocop)

  - [RuboCop is
    何？](https://qiita.com/tomohiii/items/1a17018b5a48b8284a8b)

  - [ruby rake の使い方](https://qiita.com/abcb2/items/9905449ab3fcf5d27ace)

  - [RuboCopのrake
    taskを使う](https://qiita.com/tbpgr/items/443fe45f0dbe02aa768a)

## 参考図書

# References

  - \[\] テスト駆動開発 Kent Beck (著), 和田 卓人 (翻訳): オーム社; 新訳版 (2017/10/14)

  - \[\] 新装版 リファクタリング―既存のコードを安全に改善する― (OBJECT TECHNOLOGY SERIES) Martin
    Fowler (著), 児玉 公信 (翻訳), 友野 晶夫 (翻訳), 平澤 章 (翻訳), その他: オーム社; 新装版
    (2014/7/26)

  - \[\] リファクタリング(第2版): 既存のコードを安全に改善する (OBJECT TECHNOLOGY SERIES) Martin
    Fowler (著), 児玉 公信 (翻訳), 友野 晶夫 (翻訳), 平澤 章 (翻訳), その他: オーム社; 第2版
    (2019/12/1)

  - \[\] リーダブルコード ―より良いコードを書くためのシンプルで実践的なテクニック (Theory in practice)
    Dustin Boswell (著), Trevor Foucher (著), 須藤 功平 (解説), 角 征典 (翻訳):
    オライリージャパン; 初版八刷版 (2012/6/23)

  - \[\] かんたん Ruby (プログラミングの教科書) すがわらまさのり (著) 技術評論社 (2018/6/21)

  - \[\] プロを目指す人のためのRuby入門 言語仕様からテスト駆動開発・デバッグ技法まで (Software Design
    plusシリーズ) 伊藤 淳一 (著): 技術評論社 (2017/11/25)