# SwiftDemangler

`swift demangle` のサブセットを作ります。

## 環境

+ Xcode 10.1
+ Swift 4.2.1

```
$ git clone git@github.com:ukitaka/waiwai-swift-demangler.git
$ cd waiwai-swift-demangler
$ swift package generate-xcodeproj
$ open SwiftDemangler.xcodeproj
```

## BNF

今回はもっともシンプルな関数+αのDemangleのみを扱います。
完全なドキュメントはSwiftレポジトリの[docs/ABI/Mangling.rst](https://github.com/apple/swift/blob/master/docs/ABI/Mangling.rst)を参照してください。

### Mangling

Swift4.2のPrefixのみサポートします。
このDemanglerが扱えるすべての名前にはPrefixとして`$S`がつきます。

```
mangled-name ::= '$S'
```

Prefixあとから`global`が始まります。
今回は`$S(モジュール名)(エンティティ)` のもっともシンプルな形のみ扱います。

```
global ::= entity
entity ::= context entity-spec
context ::= module
module ::= identifier
```

### Entity

今回は一部の非ジェネリックな関数のみ扱います。

```
entity-spec ::= decl-name label-list function-signature  'F'
function-signature ::= params-type params-type throws? // return and params
label-list ::= empty-list            // represents complete absence of parameter labels
label-list ::= ('_' | identifier)*
throws ::= 'K' 
params-type ::= type
decl-name ::= identifier
identifier ::= NATURAL IDENTIFIER-STRING
```

### Identifier

```
identifier ::= NATURAL IDENTIFIER-STRING
identifier ::= '0' IDENTIFIER-PART

IDENTIFIER-PART ::= NATURAL IDENTIFIER-STRING
IDENTIFIER-PART ::= [a-z]
IDENTIFIER-PART ::= [A-Z]

IDENTIFIER-STRING ::= IDENTIFIER-START-CHAR IDENTIFIER-CHAR*
IDENTIFIER-START-CHAR ::= [_a-zA-Z]
IDENTIFIER-CHAR ::= [_$a-zA-Z0-9]
```

Substitutionは時間があれば扱います。

```
identifier ::= substitution
```

```
NATURAL ::= [1-9] [0-9]*
NATURAL_ZERO ::= [0-9]+
```

### Type

Void, Int, Bool, String, Tuple + いくつかのユーザ定義型のみ扱います。

```
type ::= any-generic-type
any-generic-type ::= standard-substitutions
standard-substitutions ::= 'S' KNOWN-TYPE-KIND
KNOWN-TYPE-KIND ::= 'i' // Int
KNOWN-TYPE-KIND ::= 'b' // Bool
KNOWN-TYPE-KIND ::= 'S' // String

type ::= type-list 't' 
type-list ::= list-type '_' list-type*
type-list ::= empty-list
empty-list ::= 'y' // Void
list-type ::= type
```

## Example1

まずはもっとも基本的な関数のDemangleに挑戦してみましょう。
この関数のMangleされた名前のDemangleをします。
[Examples/ExampleNumber.swift](Examples/ExampleNumber.swift) にコードがあります。

```swift
func isEven(number: Int) -> Bool {
    return number % 2 == 0
}
```

SILを出力してどのようにManglingされているか確認してみます。

```
$ swiftc -emit-sil Examples/ExampleNumber.swift
```

該当箇所を見つけてDemanglingしてみます。

```
$ swift demangle '$S13ExampleNumber6isEven6numberSbSi_tF'
```

```
$S13ExampleNumber6isEven6numberSbSi_tF ---> ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool
```

`--expand` オプションを使うとどのような構成になっているかわかりやすいです。

```
$ swift demangle --expand '$S13ExampleNumber6isEven6numberSbSi_tF'
```

```
Demangling for $S13ExampleNumber6isEven6numberSbSi_tF
kind=Global
  kind=Function
    kind=Module, text="ExampleNumber"
    kind=Identifier, text="isEven"
    kind=LabelList
      kind=Identifier, text="number"
    kind=Type
      kind=FunctionType
        kind=ArgumentTuple, index=1
          kind=Type
            kind=Tuple
              kind=TupleElement
                kind=Type
                  kind=Structure
                    kind=Module, text="Swift"
                    kind=Identifier, text="Int"
        kind=ReturnType
          kind=Type
            kind=Structure
              kind=Module, text="Swift"
              kind=Identifier, text="Bool"
$S13ExampleNumber6isEven6numberSbSi_tF ---> ExampleNumber.isEven(number: Swift.Int) -> Swift.Bool
```

**上記のBNFをみながらParserがかける人はここから先は自由に進めてもらって大丈夫です。**

もしわからなければ以下の手順でやってみるとよいです。

### Step1 - Prefix / Entityの種類を判別する

まずウォーミングアップとしてPrefixとSuffixを読んでみましょう。

+ 与えられたStringのPrefixが`$S`であることを確認してBoolを返す `isSwiftSymbol` 関数
+ 与えられたStringのSuffixが`F`であることを確認してBoolを返す `isFunctionEntitySpec` 関数

```swift
let name = "$S13ExampleNumber6isEven6numberSbSi_tF"
isSwiftSymbol(name: name) // true
isFunctionEntitySpec(name: name) // true
```

## Step2 - 簡易Parserを作って数字とその文字分の文字列読み取る機能を作る

Mangleされた名前の中には「ここから何文字分がIdentifierか」を表す数字が含まれています。
たとえば`13ExampleNumber` であれば`ExampleNumber` の13文字分が1つのIdentifierであることを表しています。

こんな感じで簡単なParserを作ってみましょう。

```swift
class Parser {
  private let name: String
  private var index: String.Index

  var remains: String { return String(name[index...]) }

  init(name: String) {
    self.name = name
    self.index = name.startIndex
  }
}
```

まずは、先頭から数字を読み取るメソッドを作ってみましょう。
正確には`014`などの0から始まるケースを弾く必要がありますが、今回は特に気にしなくても大丈夫です。
(もちろんやってもOKです)

```swift
extension Parser {
  func parseInt() -> Int? { ... }
}
```

```swift
 var parser = Parser(name: "0")

 // 0
 XCTAssertEqual(parser.parseInt(), 0)
 XCTAssertEqual(parser.remains, "")

 // 1
 parser = Parser(name: "1")
 XCTAssertEqual(parser.parseInt(), 1)
 XCTAssertEqual(parser.remains, "")

 // 12
 parser = Parser(name: "12")
 XCTAssertEqual(parser.parseInt(), 12)
 XCTAssertEqual(parser.remains, "")

 // 12
 parser = Parser(name: "12A")
 XCTAssertEqual(parser.parseInt(), 12)
 XCTAssertEqual(parser.remains, "A")

 // 1
 parser = Parser(name: "1B2A")
 XCTAssertEqual(parser.parseInt(), 1)
 XCTAssertEqual(parser.remains, "B2A")
 XCTAssertEqual(parser.parseInt(), nil)
```

数字が読み取れたら、今度はその文字数分identifierを読み取ってみましょう。

```swift
extension Parser {
  func parseIdentifier(lenght: Int) -> String { ... }
}
```

```swift
let parser = Parser(name: "3ABC4DEFG")

XCTAssertEqual(parser.parseInt(), 3)
XCTAssertEqual(parser.remains, "ABC4DEFG")
XCTAssertEqual(parser.parseIdentifier(length: 3), "ABC")
XCTAssertEqual(parser.remains, "4DEFG")

XCTAssertEqual(parser.parseInt(), 4)
XCTAssertEqual(parser.remains, "DEFG")
XCTAssertEqual(parser.parseIdentifier(length: 4), "DEFG")
```

あとは数字を読んでその文字数分Identifierを読むメソッドがあると便利そうです。


```swift
extension Parser {
  func parseIdentifier() -> String { ... }
}
```

```swift
let parser = Parser(name: "3ABC4DEFG")
XCTAssertEqual(parser.parseIdentifier(), "ABC")
XCTAssertEqual(parser.remains, "4DEFG")
XCTAssertEqual(parser.parseIdentifier(), "DEFG")
```

