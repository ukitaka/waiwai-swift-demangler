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

### Prefix

Swift4.2のみサポートします。

```
mangled-name ::= '$S'
```

### Entity

今回は一部の非ジェネリックな関数のみ扱います。

```
global ::= entity
entity ::= context entity-spec
context ::= module
entity-spec ::= decl-name label-list function-signature  'F'
function-signature ::= params-type params-type throws? // return and params
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
```

