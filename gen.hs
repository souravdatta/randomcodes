module Main
  where

import System.Random
import System.Environment
import System.IO
import Control.Monad (replicateM, replicateM_)
import qualified Data.HashTable.IO as H

type HashTable k v = H.BasicHashTable k v

genRandom :: Int -> IO String
genRandom n = fmap concat (replicateM n ((\x -> show ((abs (rem x 9)) + 1)) <$> (randomIO :: IO Int)))

printRandom :: (HashTable String Bool) -> Int -> IO ()
printRandom htable ns = do
  x <- genRandom ns
  dup <- H.lookup htable x
  case dup of
    Nothing -> do
      H.insert htable x True
      putStrLn x
    (Just _) -> do
      hPutStrLn stderr ("DUP ~ " ++ x)
      printRandom htable ns

printAllRandoms :: Int -> Int -> IO ()
printAllRandoms nl ns = do
  htable <- H.newSized nl 
  replicateM_ nl (printRandom htable ns)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [numLines, lenStr] -> printAllRandoms (read numLines :: Int) (read lenStr :: Int)
    otherwise -> printAllRandoms 10 5
    
