# Record-Memo-App
テキストメモ機能がついた録音アプリです。

## 作成した経緯
録音して再生できるアプリは既に数多く存在しているのですが、どんな内容だったかを記録して後で見返すことのできるテキストのメモ機能がついたシンプルなアプリが欲しかったのでSwiftの学習がてら作りました。

## シミュレータ画面

| 初期画面                                                         | 録音画面                                                                                               | 再生画面                                                                                               |
| :-------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| <img width="276" alt="スクリーンショット 2022-06-26 21 52 56" src="https://user-images.githubusercontent.com/93736475/175815165-ec6066c1-969a-4156-93a9-593a02cfa20c.png"> | <img width="276" alt="スクリーンショット 2022-06-26 21 55 53" src="https://user-images.githubusercontent.com/93736475/175815278-411fcb58-738b-4470-9540-0435bc13c333.png">|<img width="276" alt="スクリーンショット 2022-06-26 21 56 59" src="https://user-images.githubusercontent.com/93736475/175815253-aa83f49b-0edb-4644-9296-198bd058ebea.png">|
|  Record or セルタップで画面遷移          |          Stopで録音データを追加 　　　　| 再生・タイトル and メモ保存 |  

<br><br>
## 機能一覧
- 音声録音
- 録音したデータをリストに追加
- 再生・停止
  - 再生速度変更(0.5〜2.0倍)
  - 再生位置変更
  - 10秒スキップ・バック
- タイトル変更
- テキストメモ表示・変更
- リストからデータを削除

## 工夫した点
- 使い方に困ることのないようにシンプルな設計を心がけた。
- 再生位置・速度を簡単に変えられるようにスライダーを用いた。
- 音が二重に鳴らないようにした。

## 苦労した点
- tableviewメソッド  numberOfRowsInSection,cellForRowAtがいつ呼ばれるのか。(reloadData()された後にセルの個数分描画される。)
- UITableViewDelegateの意味と使い方。(didSelectRowAtを使うのに必要だった。)
- 想定した通りに音を鳴らすにはAVAudioPlayerをどの時点でセットして止めれば良いか。(再生画面へ遷移時にセット)

## 改善点
- 新しく録音したデータの初期タイトルを録音した時点での時刻に変更する。
- 録音画面でBackを押すとデータが記録されないために消去する。
- 録音データを追加する際にリストの下に追加されていくために最新のデータが上に追加されるように順序を入れ替える。
- AutoLayout設定を行う。

## 開発環境
- OS：macOS Monterey version 12.4
- 言語：Swift version 5.6.1
- IDE：Xcode Version 13.3.1
- Simulater：iPhone 11

## 使用技術
- DB：RealmSwift
- 録音再生関係：AVFoundation
