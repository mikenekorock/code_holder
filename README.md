# CodeHolder

RAILS_ROOT/config/code_holder 配下にcsvを配置することでEnumを管理することができる。

## Installation

Add this line to your application's Gemfile:

    gem 'code_holder', github: rawhide/code_holder

And then execute:

    $ bundle

Or install it yourself as: （未対応）

    $ gem install code_holder

## 基本的な使い方

### 例）RAILS_ROOT/config/code_holder/gender.csv

    title,性別
    #DATA
    key,value,position,name,short_name
    MALE,m,1,男性,男
    FEMALE,f,2,女性,女

key,value,position,name 必須
この後に任意の項目を付け足すことが可能（上記例ではshort_name）

    > C.gender.MALE => "m"
    > C.gender.MALE.name => "男性"
    > C.gender["m"] => "m"
    > C.gender["m"].name => "男性"

### このセレクトボックスを作りたければ

    <%= f.select :gender, C.genders.to_opt, :include_blank => "選択してください"  %>

CSVのpositionカラムの数字を入れ替えることで、セレクトボックスの順番を変えることも可能

### データを表示するには

    <%= C.gender[user.gender].name %>

## Customizing

###  定義ファイルのディレクトリは、initializerに以下のように書くことで、変更可能

    ENUMS = Railstar::CodeHolder.new("resources/code")

### 型はintegerのみ指定可能

    title,性別テストデータ
    type,int_val,integer
    #DATA
    key,value,position,name,short_name,int_val
    FEMALE,f,2,女性,女,2
    MALE,m,1,男性,男,1

    > C.gender.MALE.int_val => 1

### 任意の項目のセレクトボックスを作成することも可能

    <%= f.select :gender, C.genders.to_opt(:short_name), :include_blank => "選択してください"  %>
    <%= f.select :gender, C.genders.to_opt(:short_name, :int_val), :include_blank => "選択してください"  %>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
