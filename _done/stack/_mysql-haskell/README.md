# Connect to MySQL (local)

[toc]

## mysql-haskell
[mysql-haskell][wland]
[Qiita][lotz]

  [wland]: https://github.com/winterland1989/mysql-haskell
  [lotz]: http://qiita.com/lotz/items/1d9c7b4333fd4d29a150

( Stack )
```
$ wget -qO- https://get.haskellstack.org/ | sh
$ stack new

stack new my-project
cd my-project
stack setup
stack build
stack exec my-project-exe
```

( MySQL server )
```
$ sudo service mysql start
$ ps aux | grep mysql
mysql    23055  0.0  0.1 1304196 1264 ?        Ssl  21:35   0:06 /usr/sbin/mysqld
```

( on "mysql.cabal" )
```
library
  build-depends:       base >= 4.7 && < 5
                     , mysql-haskell
                     , io-streams
```

???
( on "stack.yaml" )
```
extra-deps:
#- binary-0.8.4.1
#- HsOpenSSL-x509-system-0.1.0.2

#- tcp-streams-0.3.0.0
#- wire-streams-0.0.2.0

#- tcp-streams-0.6.0.0
#- wire-streams-0.1.1.0
```

( on "src/Lib.hs" )
```
someFunc :: IO ()
someFunc = do
  db <- connect defaultConnectInfo {ciDatabase = "test"}
  (dwfs, is) <- query_ db "SELECT * FROM test"
  print =<< Streams.toList is
```

### todo

- build without extra-deps (on "stack.yaml")

