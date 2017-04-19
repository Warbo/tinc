{-# LANGUAGE ConstrainedClassMethods #-}
{-# LANGUAGE FlexibleContexts #-}
module Tinc.Fail where

import           Data.WithLocation
import           Control.Exception

class (Functor m, Applicative m, Monad m) => Fail m where
  die :: String -> m a

  dieLoc :: WithLocation(Fail m => String -> m a)
  dieLoc message = die (maybe "" ((++ ": ") . locationFile) location ++ message)

  bug :: WithLocation (Fail m => String -> m a)
  bug message = (dieLoc . unlines) [
      message
    , "This is most likely a bug.  Please report an issue at:"
    , ""
    , "  https://github.com/sol/tinc/issues"
    ]

instance Fail IO where
  die = throwIO . ErrorCall
