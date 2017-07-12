module Lib
    ( someFunc
    ) where

{-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies, OverloadedStrings, GADTs, FlexibleContexts #-}
import Database.Persist
import Database.Persist.MySQL
import Database.Persist.TH
import Control.Monad.Trans.Resource (runResourceT, ResourceT)


someFunc :: IO ()
someFunc = putStrLn "someFunc"


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistUpperCase|
Person
    name String
    age Int Maybe
BlogPost
    title String
    authorId PersonId
|]

main :: IO ()
main = do
  registerData
  putStrLn "OK Complete!"

registerData :: IO ()
registerData = runResourceT $ getConn $ runSqlConn $ do
       runMigration migrateAll
       takeId <- insert $ Person "Take Ishii" $ Just 40
       asaId <- insert $ Person "Kazu Asaka" $ Just 41
       _ <- insert $ BlogPost "今日も酒を飲みすぎました" takeId
       _ <- insert $ BlogPost "今日は法事が入っています" asaId
       return ()

getConn :: (Connection -> ResourceT IO a) -> ResourceT IO a
getConn = withMySQLConn getConnection

getConnection :: ConnectInfo
getConnection = ConnectInfo {
    connectHost = "localhost",
    connectPort = 3306,
    connectUser = "root",
    connectPassword = "",
    connectDatabase = "SAMPLEDB",
    connectOptions = [],
    connectPath = "",
    connectSSL = Nothing
}


