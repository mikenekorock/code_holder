# CodeHolder

RAILS_ROOT/config/code_holder 配下にcsvを配置することでEnumを管理することができる。

## Installation

Add this line to your application's Gemfile:

    gem 'code_holder', github: rawhide/code_holder

And then execute:

    $ bundle

Or install it yourself as: （未対応）

    $ gem install code_holder

## 使い方

例）RAILS_ROOT/config/code_holder/blood_type.csv
  title,血液型
  #DATA
  key,value,position,name,hoge
  A,a,1,A型,三角
  B,b,2,B型,台形
  AB,ab,3,AB型,星形
  O,o,4,O型,丸

key,value,position,name 必須
この後に任意の項目を付け足すことが可能（上記例ではhoge）

  > C.blood_type.A => "a"
  > C.blood_type.A.name => "A型"
  > C.blood_type["a"] => "a"
  > C.blood_type["a"].key => "A"
  > C.blood_type["a"].name => "A型"
  > C.blood_type["a"].hoge => "三角"

このセレクトボックスを作りたければ

  <%= f.select :blood_type, C.blood_types.to_opt, :include_blank => "選択してください"  %>

CSVのpositionカラムの数字を入れ替えることで、セレクトボックスの順番を変えることも可能

## Customizing
  定義ファイルのディレクトリは、initializerに以下のように書くことで、変更可能

  ENUMS = Railstar::CodeHolder.new("resources/code")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
