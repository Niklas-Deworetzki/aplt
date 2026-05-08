{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
{-# LANGUAGE PatternSynonyms #-}

module Lang.Par
  ( happyError
  , myLexer
  , pGen
  ) where

import Prelude

import qualified Lang.Abs
import Lang.Lex
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

newtype HappyAbsSyn  = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
newtype HappyWrap4 = HappyWrap4 (Lang.Abs.Ident)
happyIn4 :: (Lang.Abs.Ident) -> (HappyAbsSyn )
happyIn4 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap4 x)
{-# INLINE happyIn4 #-}
happyOut4 :: (HappyAbsSyn ) -> HappyWrap4
happyOut4 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut4 #-}
newtype HappyWrap5 = HappyWrap5 (Lang.Abs.Gen)
happyIn5 :: (Lang.Abs.Gen) -> (HappyAbsSyn )
happyIn5 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap5 x)
{-# INLINE happyIn5 #-}
happyOut5 :: (HappyAbsSyn ) -> HappyWrap5
happyOut5 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut5 #-}
newtype HappyWrap6 = HappyWrap6 ([Lang.Abs.PExp])
happyIn6 :: ([Lang.Abs.PExp]) -> (HappyAbsSyn )
happyIn6 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap6 x)
{-# INLINE happyIn6 #-}
happyOut6 :: (HappyAbsSyn ) -> HappyWrap6
happyOut6 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut6 #-}
newtype HappyWrap7 = HappyWrap7 (Lang.Abs.PExp)
happyIn7 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn7 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap7 x)
{-# INLINE happyIn7 #-}
happyOut7 :: (HappyAbsSyn ) -> HappyWrap7
happyOut7 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut7 #-}
newtype HappyWrap8 = HappyWrap8 (Lang.Abs.PExp)
happyIn8 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn8 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap8 x)
{-# INLINE happyIn8 #-}
happyOut8 :: (HappyAbsSyn ) -> HappyWrap8
happyOut8 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut8 #-}
newtype HappyWrap9 = HappyWrap9 (Lang.Abs.PExp)
happyIn9 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn9 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap9 x)
{-# INLINE happyIn9 #-}
happyOut9 :: (HappyAbsSyn ) -> HappyWrap9
happyOut9 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut9 #-}
newtype HappyWrap10 = HappyWrap10 (Lang.Abs.PExp)
happyIn10 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn10 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap10 x)
{-# INLINE happyIn10 #-}
happyOut10 :: (HappyAbsSyn ) -> HappyWrap10
happyOut10 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut10 #-}
newtype HappyWrap11 = HappyWrap11 (Lang.Abs.PExp)
happyIn11 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn11 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap11 x)
{-# INLINE happyIn11 #-}
happyOut11 :: (HappyAbsSyn ) -> HappyWrap11
happyOut11 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut11 #-}
newtype HappyWrap12 = HappyWrap12 (Lang.Abs.PExp)
happyIn12 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn12 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap12 x)
{-# INLINE happyIn12 #-}
happyOut12 :: (HappyAbsSyn ) -> HappyWrap12
happyOut12 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut12 #-}
newtype HappyWrap13 = HappyWrap13 (Lang.Abs.PExp)
happyIn13 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn13 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap13 x)
{-# INLINE happyIn13 #-}
happyOut13 :: (HappyAbsSyn ) -> HappyWrap13
happyOut13 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut13 #-}
newtype HappyWrap14 = HappyWrap14 (Lang.Abs.PExp)
happyIn14 :: (Lang.Abs.PExp) -> (HappyAbsSyn )
happyIn14 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap14 x)
{-# INLINE happyIn14 #-}
happyOut14 :: (HappyAbsSyn ) -> HappyWrap14
happyOut14 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut14 #-}
newtype HappyWrap15 = HappyWrap15 (Lang.Abs.PLabExp)
happyIn15 :: (Lang.Abs.PLabExp) -> (HappyAbsSyn )
happyIn15 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap15 x)
{-# INLINE happyIn15 #-}
happyOut15 :: (HappyAbsSyn ) -> HappyWrap15
happyOut15 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut15 #-}
newtype HappyWrap16 = HappyWrap16 ([Lang.Abs.PLabExp])
happyIn16 :: ([Lang.Abs.PLabExp]) -> (HappyAbsSyn )
happyIn16 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap16 x)
{-# INLINE happyIn16 #-}
happyOut16 :: (HappyAbsSyn ) -> HappyWrap16
happyOut16 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut16 #-}
newtype HappyWrap17 = HappyWrap17 (Lang.Abs.PCaseExp)
happyIn17 :: (Lang.Abs.PCaseExp) -> (HappyAbsSyn )
happyIn17 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap17 x)
{-# INLINE happyIn17 #-}
happyOut17 :: (HappyAbsSyn ) -> HappyWrap17
happyOut17 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut17 #-}
newtype HappyWrap18 = HappyWrap18 ([Lang.Abs.PCaseExp])
happyIn18 :: ([Lang.Abs.PCaseExp]) -> (HappyAbsSyn )
happyIn18 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap18 x)
{-# INLINE happyIn18 #-}
happyOut18 :: (HappyAbsSyn ) -> HappyWrap18
happyOut18 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut18 #-}
newtype HappyWrap19 = HappyWrap19 (Lang.Abs.PTyp)
happyIn19 :: (Lang.Abs.PTyp) -> (HappyAbsSyn )
happyIn19 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap19 x)
{-# INLINE happyIn19 #-}
happyOut19 :: (HappyAbsSyn ) -> HappyWrap19
happyOut19 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut19 #-}
newtype HappyWrap20 = HappyWrap20 (Lang.Abs.TMember)
happyIn20 :: (Lang.Abs.TMember) -> (HappyAbsSyn )
happyIn20 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap20 x)
{-# INLINE happyIn20 #-}
happyOut20 :: (HappyAbsSyn ) -> HappyWrap20
happyOut20 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut20 #-}
newtype HappyWrap21 = HappyWrap21 ([Lang.Abs.TMember])
happyIn21 :: ([Lang.Abs.TMember]) -> (HappyAbsSyn )
happyIn21 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap21 x)
{-# INLINE happyIn21 #-}
happyOut21 :: (HappyAbsSyn ) -> HappyWrap21
happyOut21 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut21 #-}
newtype HappyWrap22 = HappyWrap22 (Lang.Abs.TMember)
happyIn22 :: (Lang.Abs.TMember) -> (HappyAbsSyn )
happyIn22 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap22 x)
{-# INLINE happyIn22 #-}
happyOut22 :: (HappyAbsSyn ) -> HappyWrap22
happyOut22 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut22 #-}
newtype HappyWrap23 = HappyWrap23 ([Lang.Abs.TMember])
happyIn23 :: ([Lang.Abs.TMember]) -> (HappyAbsSyn )
happyIn23 x = Happy_GHC_Exts.unsafeCoerce# (HappyWrap23 x)
{-# INLINE happyIn23 #-}
happyOut23 :: (HappyAbsSyn ) -> HappyWrap23
happyOut23 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut23 #-}
happyInTok :: (Token) -> (HappyAbsSyn )
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn ) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Happy_GHC_Exts.Int# 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120 :: () => Happy_GHC_Exts.Int# -> ({-HappyReduction (Err) = -}
	   Happy_GHC_Exts.Int# 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53 :: () => ({-HappyReduction (Err) = -}
	   Happy_GHC_Exts.Int# 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x80\x20\x81\xb5\x4a\x10\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x02\x00\x0e\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x12\x58\xab\x04\x01\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x80\x20\x81\xb5\x4a\x10\x00\x00\x00\x40\x1c\x40\x44\x04\x00\x00\x08\x10\x18\x81\x00\x01\x00\x00\x82\x04\xd6\x2a\x41\x00\x00\x00\x00\x71\x00\x11\x11\x00\x00\x20\x40\x60\x04\x02\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\xc4\x01\x44\x44\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x1c\x40\x44\x04\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x08\x00\x18\x40\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x71\x00\x11\x11\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x08\x10\x18\x83\x04\x01\x00\x00\x82\x04\xd6\x2a\x41\x00\x00\x80\x20\x81\x35\x48\x10\x00\x00\x20\x48\x60\x0d\x12\x04\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x48\x60\x0d\x12\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x80\x20\x81\xb5\x4a\x10\x00\x00\x20\x48\x60\x0d\x12\x04\x00\x00\x00\x10\x07\x10\x11\x01\x00\x00\x82\x04\xd6\x2a\x41\x00\x00\x80\x20\x81\xb5\x4a\x10\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc4\x01\x44\x44\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\xc4\x01\x44\x44\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x1c\x40\x44\x04\x00\x00\x00\x10\x07\x10\x11\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x40\x1c\x40\x44\x04\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x12\x58\xab\x04\x01\x00\x00\x82\x04\xd6\x2a\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x82\x04\xd6\x2a\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x08\x12\x58\xab\x04\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pGen","Ident","Gen","ListPExp","PExp","PExp1","PExp2","PExp3","PExp5","PExp6","PExp7","PExp4","PLabExp","ListPLabExp","PCaseExp","ListPCaseExp","PTyp","TMember","ListTMember","TMember1","ListTMember1","'('","')'","'+'","','","'->'","'.'","'/\\\\'","':'","';'","'<'","'='","'=>'","'>'","'Arr'","'Bool'","'Dist'","'False'","'True'","'['","'\\\\'","']'","'case'","'distr'","'else'","'filter'","'forall'","'if'","'in'","'inj'","'my'","'of'","'return'","'then'","'{'","'|'","'}'","'~'","L_Ident","%eof"]
        bit_start = st Prelude.* 62
        bit_end = (st Prelude.+ 1) Prelude.* 62
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..61]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (24#) = happyShift action_14
action_0 (30#) = happyShift action_15
action_0 (33#) = happyShift action_16
action_0 (40#) = happyShift action_17
action_0 (41#) = happyShift action_18
action_0 (43#) = happyShift action_19
action_0 (45#) = happyShift action_20
action_0 (46#) = happyShift action_21
action_0 (48#) = happyShift action_22
action_0 (50#) = happyShift action_23
action_0 (52#) = happyShift action_24
action_0 (55#) = happyShift action_25
action_0 (61#) = happyShift action_2
action_0 (4#) = happyGoto action_3
action_0 (5#) = happyGoto action_4
action_0 (6#) = happyGoto action_5
action_0 (7#) = happyGoto action_6
action_0 (8#) = happyGoto action_7
action_0 (9#) = happyGoto action_8
action_0 (10#) = happyGoto action_9
action_0 (11#) = happyGoto action_10
action_0 (12#) = happyGoto action_11
action_0 (13#) = happyGoto action_12
action_0 (14#) = happyGoto action_13
action_0 x = happyTcHack x happyFail (happyExpListPerState 0)

action_1 (61#) = happyShift action_2
action_1 x = happyTcHack x happyFail (happyExpListPerState 1)

action_2 x = happyTcHack x happyReduce_1

action_3 (34#) = happyShift action_52
action_3 (60#) = happyShift action_53
action_3 x = happyTcHack x happyReduce_28

action_4 (62#) = happyAccept
action_4 x = happyTcHack x happyFail (happyExpListPerState 4)

action_5 x = happyTcHack x happyReduce_2

action_6 (32#) = happyShift action_51
action_6 x = happyTcHack x happyReduce_3

action_7 x = happyTcHack x happyReduce_9

action_8 (26#) = happyShift action_50
action_8 x = happyTcHack x happyReduce_12

action_9 x = happyTcHack x happyReduce_14

action_10 (29#) = happyShift action_49
action_10 x = happyTcHack x happyReduce_30

action_11 (24#) = happyShift action_14
action_11 (40#) = happyShift action_17
action_11 (41#) = happyShift action_18
action_11 (42#) = happyShift action_48
action_11 (61#) = happyShift action_2
action_11 (4#) = happyGoto action_26
action_11 (13#) = happyGoto action_47
action_11 x = happyTcHack x happyReduce_20

action_12 x = happyTcHack x happyReduce_25

action_13 x = happyTcHack x happyReduce_17

action_14 (24#) = happyShift action_14
action_14 (30#) = happyShift action_15
action_14 (33#) = happyShift action_16
action_14 (40#) = happyShift action_17
action_14 (41#) = happyShift action_18
action_14 (43#) = happyShift action_19
action_14 (45#) = happyShift action_20
action_14 (46#) = happyShift action_21
action_14 (48#) = happyShift action_22
action_14 (50#) = happyShift action_23
action_14 (52#) = happyShift action_24
action_14 (55#) = happyShift action_25
action_14 (61#) = happyShift action_2
action_14 (4#) = happyGoto action_3
action_14 (7#) = happyGoto action_46
action_14 (8#) = happyGoto action_7
action_14 (9#) = happyGoto action_8
action_14 (10#) = happyGoto action_9
action_14 (11#) = happyGoto action_10
action_14 (12#) = happyGoto action_11
action_14 (13#) = happyGoto action_12
action_14 (14#) = happyGoto action_13
action_14 x = happyTcHack x happyFail (happyExpListPerState 14)

action_15 (61#) = happyShift action_2
action_15 (4#) = happyGoto action_45
action_15 x = happyTcHack x happyFail (happyExpListPerState 15)

action_16 (61#) = happyShift action_2
action_16 (4#) = happyGoto action_42
action_16 (15#) = happyGoto action_43
action_16 (16#) = happyGoto action_44
action_16 x = happyTcHack x happyReduce_32

action_17 x = happyTcHack x happyReduce_27

action_18 x = happyTcHack x happyReduce_26

action_19 (61#) = happyShift action_2
action_19 (4#) = happyGoto action_41
action_19 x = happyTcHack x happyFail (happyExpListPerState 19)

action_20 (24#) = happyShift action_14
action_20 (30#) = happyShift action_15
action_20 (33#) = happyShift action_16
action_20 (40#) = happyShift action_17
action_20 (41#) = happyShift action_18
action_20 (43#) = happyShift action_19
action_20 (45#) = happyShift action_20
action_20 (46#) = happyShift action_21
action_20 (48#) = happyShift action_22
action_20 (50#) = happyShift action_23
action_20 (52#) = happyShift action_24
action_20 (55#) = happyShift action_25
action_20 (61#) = happyShift action_2
action_20 (4#) = happyGoto action_3
action_20 (7#) = happyGoto action_40
action_20 (8#) = happyGoto action_7
action_20 (9#) = happyGoto action_8
action_20 (10#) = happyGoto action_9
action_20 (11#) = happyGoto action_10
action_20 (12#) = happyGoto action_11
action_20 (13#) = happyGoto action_12
action_20 (14#) = happyGoto action_13
action_20 x = happyTcHack x happyFail (happyExpListPerState 20)

action_21 (33#) = happyShift action_30
action_21 (37#) = happyShift action_31
action_21 (38#) = happyShift action_32
action_21 (39#) = happyShift action_33
action_21 (49#) = happyShift action_34
action_21 (53#) = happyShift action_35
action_21 (57#) = happyShift action_36
action_21 (61#) = happyShift action_2
action_21 (4#) = happyGoto action_28
action_21 (19#) = happyGoto action_39
action_21 x = happyTcHack x happyFail (happyExpListPerState 21)

action_22 (24#) = happyShift action_14
action_22 (33#) = happyShift action_16
action_22 (40#) = happyShift action_17
action_22 (41#) = happyShift action_18
action_22 (45#) = happyShift action_20
action_22 (52#) = happyShift action_24
action_22 (61#) = happyShift action_2
action_22 (4#) = happyGoto action_26
action_22 (12#) = happyGoto action_38
action_22 (13#) = happyGoto action_12
action_22 x = happyTcHack x happyFail (happyExpListPerState 22)

action_23 (24#) = happyShift action_14
action_23 (30#) = happyShift action_15
action_23 (33#) = happyShift action_16
action_23 (40#) = happyShift action_17
action_23 (41#) = happyShift action_18
action_23 (43#) = happyShift action_19
action_23 (45#) = happyShift action_20
action_23 (46#) = happyShift action_21
action_23 (48#) = happyShift action_22
action_23 (50#) = happyShift action_23
action_23 (52#) = happyShift action_24
action_23 (55#) = happyShift action_25
action_23 (61#) = happyShift action_2
action_23 (4#) = happyGoto action_3
action_23 (7#) = happyGoto action_37
action_23 (8#) = happyGoto action_7
action_23 (9#) = happyGoto action_8
action_23 (10#) = happyGoto action_9
action_23 (11#) = happyGoto action_10
action_23 (12#) = happyGoto action_11
action_23 (13#) = happyGoto action_12
action_23 (14#) = happyGoto action_13
action_23 x = happyTcHack x happyFail (happyExpListPerState 23)

action_24 (33#) = happyShift action_30
action_24 (37#) = happyShift action_31
action_24 (38#) = happyShift action_32
action_24 (39#) = happyShift action_33
action_24 (49#) = happyShift action_34
action_24 (53#) = happyShift action_35
action_24 (57#) = happyShift action_36
action_24 (61#) = happyShift action_2
action_24 (4#) = happyGoto action_28
action_24 (19#) = happyGoto action_29
action_24 x = happyTcHack x happyFail (happyExpListPerState 24)

action_25 (24#) = happyShift action_14
action_25 (33#) = happyShift action_16
action_25 (40#) = happyShift action_17
action_25 (41#) = happyShift action_18
action_25 (45#) = happyShift action_20
action_25 (52#) = happyShift action_24
action_25 (61#) = happyShift action_2
action_25 (4#) = happyGoto action_26
action_25 (11#) = happyGoto action_10
action_25 (12#) = happyGoto action_11
action_25 (13#) = happyGoto action_12
action_25 (14#) = happyGoto action_27
action_25 x = happyTcHack x happyFail (happyExpListPerState 25)

action_26 x = happyTcHack x happyReduce_28

action_27 x = happyTcHack x happyReduce_15

action_28 x = happyTcHack x happyReduce_40

action_29 (57#) = happyShift action_79
action_29 x = happyTcHack x happyFail (happyExpListPerState 29)

action_30 (61#) = happyShift action_2
action_30 (4#) = happyGoto action_76
action_30 (20#) = happyGoto action_77
action_30 (21#) = happyGoto action_78
action_30 x = happyTcHack x happyReduce_48

action_31 (33#) = happyShift action_30
action_31 (37#) = happyShift action_31
action_31 (38#) = happyShift action_32
action_31 (39#) = happyShift action_33
action_31 (49#) = happyShift action_34
action_31 (53#) = happyShift action_35
action_31 (57#) = happyShift action_36
action_31 (61#) = happyShift action_2
action_31 (4#) = happyGoto action_28
action_31 (19#) = happyGoto action_75
action_31 x = happyTcHack x happyFail (happyExpListPerState 31)

action_32 x = happyTcHack x happyReduce_39

action_33 (33#) = happyShift action_30
action_33 (37#) = happyShift action_31
action_33 (38#) = happyShift action_32
action_33 (39#) = happyShift action_33
action_33 (49#) = happyShift action_34
action_33 (53#) = happyShift action_35
action_33 (57#) = happyShift action_36
action_33 (61#) = happyShift action_2
action_33 (4#) = happyGoto action_28
action_33 (19#) = happyGoto action_74
action_33 x = happyTcHack x happyFail (happyExpListPerState 33)

action_34 (61#) = happyShift action_2
action_34 (4#) = happyGoto action_73
action_34 x = happyTcHack x happyFail (happyExpListPerState 34)

action_35 (61#) = happyShift action_2
action_35 (4#) = happyGoto action_72
action_35 x = happyTcHack x happyFail (happyExpListPerState 35)

action_36 (61#) = happyShift action_2
action_36 (4#) = happyGoto action_69
action_36 (22#) = happyGoto action_70
action_36 (23#) = happyGoto action_71
action_36 x = happyTcHack x happyFail (happyExpListPerState 36)

action_37 (56#) = happyShift action_68
action_37 x = happyTcHack x happyFail (happyExpListPerState 37)

action_38 (24#) = happyShift action_14
action_38 (40#) = happyShift action_17
action_38 (41#) = happyShift action_18
action_38 (51#) = happyShift action_67
action_38 (61#) = happyShift action_2
action_38 (4#) = happyGoto action_26
action_38 (13#) = happyGoto action_47
action_38 x = happyTcHack x happyFail (happyExpListPerState 38)

action_39 x = happyTcHack x happyReduce_16

action_40 (54#) = happyShift action_66
action_40 x = happyTcHack x happyFail (happyExpListPerState 40)

action_41 (28#) = happyShift action_65
action_41 x = happyTcHack x happyFail (happyExpListPerState 41)

action_42 (31#) = happyShift action_64
action_42 x = happyTcHack x happyFail (happyExpListPerState 42)

action_43 (27#) = happyShift action_63
action_43 x = happyTcHack x happyReduce_33

action_44 (36#) = happyShift action_62
action_44 x = happyTcHack x happyFail (happyExpListPerState 44)

action_45 (35#) = happyShift action_61
action_45 x = happyTcHack x happyFail (happyExpListPerState 45)

action_46 (25#) = happyShift action_60
action_46 x = happyTcHack x happyFail (happyExpListPerState 46)

action_47 x = happyTcHack x happyReduce_24

action_48 (33#) = happyShift action_30
action_48 (37#) = happyShift action_31
action_48 (38#) = happyShift action_32
action_48 (39#) = happyShift action_33
action_48 (49#) = happyShift action_34
action_48 (53#) = happyShift action_35
action_48 (57#) = happyShift action_36
action_48 (61#) = happyShift action_2
action_48 (4#) = happyGoto action_28
action_48 (19#) = happyGoto action_59
action_48 x = happyTcHack x happyFail (happyExpListPerState 48)

action_49 (61#) = happyShift action_2
action_49 (4#) = happyGoto action_58
action_49 x = happyTcHack x happyFail (happyExpListPerState 49)

action_50 (24#) = happyShift action_14
action_50 (33#) = happyShift action_16
action_50 (40#) = happyShift action_17
action_50 (41#) = happyShift action_18
action_50 (45#) = happyShift action_20
action_50 (46#) = happyShift action_21
action_50 (52#) = happyShift action_24
action_50 (55#) = happyShift action_25
action_50 (61#) = happyShift action_2
action_50 (4#) = happyGoto action_26
action_50 (10#) = happyGoto action_57
action_50 (11#) = happyGoto action_10
action_50 (12#) = happyGoto action_11
action_50 (13#) = happyGoto action_12
action_50 (14#) = happyGoto action_13
action_50 x = happyTcHack x happyFail (happyExpListPerState 50)

action_51 (24#) = happyShift action_14
action_51 (30#) = happyShift action_15
action_51 (33#) = happyShift action_16
action_51 (40#) = happyShift action_17
action_51 (41#) = happyShift action_18
action_51 (43#) = happyShift action_19
action_51 (45#) = happyShift action_20
action_51 (46#) = happyShift action_21
action_51 (48#) = happyShift action_22
action_51 (50#) = happyShift action_23
action_51 (52#) = happyShift action_24
action_51 (55#) = happyShift action_25
action_51 (61#) = happyShift action_2
action_51 (4#) = happyGoto action_3
action_51 (6#) = happyGoto action_56
action_51 (7#) = happyGoto action_6
action_51 (8#) = happyGoto action_7
action_51 (9#) = happyGoto action_8
action_51 (10#) = happyGoto action_9
action_51 (11#) = happyGoto action_10
action_51 (12#) = happyGoto action_11
action_51 (13#) = happyGoto action_12
action_51 (14#) = happyGoto action_13
action_51 x = happyTcHack x happyFail (happyExpListPerState 51)

action_52 (24#) = happyShift action_14
action_52 (30#) = happyShift action_15
action_52 (33#) = happyShift action_16
action_52 (40#) = happyShift action_17
action_52 (41#) = happyShift action_18
action_52 (43#) = happyShift action_19
action_52 (45#) = happyShift action_20
action_52 (46#) = happyShift action_21
action_52 (52#) = happyShift action_24
action_52 (55#) = happyShift action_25
action_52 (61#) = happyShift action_2
action_52 (4#) = happyGoto action_26
action_52 (8#) = happyGoto action_55
action_52 (9#) = happyGoto action_8
action_52 (10#) = happyGoto action_9
action_52 (11#) = happyGoto action_10
action_52 (12#) = happyGoto action_11
action_52 (13#) = happyGoto action_12
action_52 (14#) = happyGoto action_13
action_52 x = happyTcHack x happyFail (happyExpListPerState 52)

action_53 (24#) = happyShift action_14
action_53 (30#) = happyShift action_15
action_53 (33#) = happyShift action_16
action_53 (40#) = happyShift action_17
action_53 (41#) = happyShift action_18
action_53 (43#) = happyShift action_19
action_53 (45#) = happyShift action_20
action_53 (46#) = happyShift action_21
action_53 (52#) = happyShift action_24
action_53 (55#) = happyShift action_25
action_53 (61#) = happyShift action_2
action_53 (4#) = happyGoto action_26
action_53 (8#) = happyGoto action_54
action_53 (9#) = happyGoto action_8
action_53 (10#) = happyGoto action_9
action_53 (11#) = happyGoto action_10
action_53 (12#) = happyGoto action_11
action_53 (13#) = happyGoto action_12
action_53 (14#) = happyGoto action_13
action_53 x = happyTcHack x happyFail (happyExpListPerState 53)

action_54 (51#) = happyShift action_99
action_54 x = happyTcHack x happyFail (happyExpListPerState 54)

action_55 (51#) = happyShift action_98
action_55 x = happyTcHack x happyFail (happyExpListPerState 55)

action_56 x = happyTcHack x happyReduce_4

action_57 x = happyTcHack x happyReduce_13

action_58 x = happyTcHack x happyReduce_18

action_59 (44#) = happyShift action_97
action_59 x = happyTcHack x happyFail (happyExpListPerState 59)

action_60 x = happyTcHack x happyReduce_29

action_61 (24#) = happyShift action_14
action_61 (30#) = happyShift action_15
action_61 (33#) = happyShift action_16
action_61 (40#) = happyShift action_17
action_61 (41#) = happyShift action_18
action_61 (43#) = happyShift action_19
action_61 (45#) = happyShift action_20
action_61 (46#) = happyShift action_21
action_61 (52#) = happyShift action_24
action_61 (55#) = happyShift action_25
action_61 (61#) = happyShift action_2
action_61 (4#) = happyGoto action_26
action_61 (8#) = happyGoto action_96
action_61 (9#) = happyGoto action_8
action_61 (10#) = happyGoto action_9
action_61 (11#) = happyGoto action_10
action_61 (12#) = happyGoto action_11
action_61 (13#) = happyGoto action_12
action_61 (14#) = happyGoto action_13
action_61 x = happyTcHack x happyFail (happyExpListPerState 61)

action_62 x = happyTcHack x happyReduce_21

action_63 (61#) = happyShift action_2
action_63 (4#) = happyGoto action_42
action_63 (15#) = happyGoto action_43
action_63 (16#) = happyGoto action_95
action_63 x = happyTcHack x happyReduce_32

action_64 (24#) = happyShift action_14
action_64 (30#) = happyShift action_15
action_64 (33#) = happyShift action_16
action_64 (40#) = happyShift action_17
action_64 (41#) = happyShift action_18
action_64 (43#) = happyShift action_19
action_64 (45#) = happyShift action_20
action_64 (46#) = happyShift action_21
action_64 (48#) = happyShift action_22
action_64 (50#) = happyShift action_23
action_64 (52#) = happyShift action_24
action_64 (55#) = happyShift action_25
action_64 (61#) = happyShift action_2
action_64 (4#) = happyGoto action_3
action_64 (7#) = happyGoto action_94
action_64 (8#) = happyGoto action_7
action_64 (9#) = happyGoto action_8
action_64 (10#) = happyGoto action_9
action_64 (11#) = happyGoto action_10
action_64 (12#) = happyGoto action_11
action_64 (13#) = happyGoto action_12
action_64 (14#) = happyGoto action_13
action_64 x = happyTcHack x happyFail (happyExpListPerState 64)

action_65 (24#) = happyShift action_14
action_65 (30#) = happyShift action_15
action_65 (33#) = happyShift action_16
action_65 (40#) = happyShift action_17
action_65 (41#) = happyShift action_18
action_65 (43#) = happyShift action_19
action_65 (45#) = happyShift action_20
action_65 (46#) = happyShift action_21
action_65 (52#) = happyShift action_24
action_65 (55#) = happyShift action_25
action_65 (61#) = happyShift action_2
action_65 (4#) = happyGoto action_26
action_65 (8#) = happyGoto action_93
action_65 (9#) = happyGoto action_8
action_65 (10#) = happyGoto action_9
action_65 (11#) = happyGoto action_10
action_65 (12#) = happyGoto action_11
action_65 (13#) = happyGoto action_12
action_65 (14#) = happyGoto action_13
action_65 x = happyTcHack x happyFail (happyExpListPerState 65)

action_66 (33#) = happyShift action_30
action_66 (37#) = happyShift action_31
action_66 (38#) = happyShift action_32
action_66 (39#) = happyShift action_33
action_66 (49#) = happyShift action_34
action_66 (53#) = happyShift action_35
action_66 (57#) = happyShift action_36
action_66 (61#) = happyShift action_2
action_66 (4#) = happyGoto action_28
action_66 (19#) = happyGoto action_92
action_66 x = happyTcHack x happyFail (happyExpListPerState 66)

action_67 (24#) = happyShift action_14
action_67 (30#) = happyShift action_15
action_67 (33#) = happyShift action_16
action_67 (40#) = happyShift action_17
action_67 (41#) = happyShift action_18
action_67 (43#) = happyShift action_19
action_67 (45#) = happyShift action_20
action_67 (46#) = happyShift action_21
action_67 (48#) = happyShift action_22
action_67 (50#) = happyShift action_23
action_67 (52#) = happyShift action_24
action_67 (55#) = happyShift action_25
action_67 (61#) = happyShift action_2
action_67 (4#) = happyGoto action_3
action_67 (7#) = happyGoto action_91
action_67 (8#) = happyGoto action_7
action_67 (9#) = happyGoto action_8
action_67 (10#) = happyGoto action_9
action_67 (11#) = happyGoto action_10
action_67 (12#) = happyGoto action_11
action_67 (13#) = happyGoto action_12
action_67 (14#) = happyGoto action_13
action_67 x = happyTcHack x happyFail (happyExpListPerState 67)

action_68 (24#) = happyShift action_14
action_68 (30#) = happyShift action_15
action_68 (33#) = happyShift action_16
action_68 (40#) = happyShift action_17
action_68 (41#) = happyShift action_18
action_68 (43#) = happyShift action_19
action_68 (45#) = happyShift action_20
action_68 (46#) = happyShift action_21
action_68 (48#) = happyShift action_22
action_68 (50#) = happyShift action_23
action_68 (52#) = happyShift action_24
action_68 (55#) = happyShift action_25
action_68 (61#) = happyShift action_2
action_68 (4#) = happyGoto action_3
action_68 (7#) = happyGoto action_90
action_68 (8#) = happyGoto action_7
action_68 (9#) = happyGoto action_8
action_68 (10#) = happyGoto action_9
action_68 (11#) = happyGoto action_10
action_68 (12#) = happyGoto action_11
action_68 (13#) = happyGoto action_12
action_68 (14#) = happyGoto action_13
action_68 x = happyTcHack x happyFail (happyExpListPerState 68)

action_69 (31#) = happyShift action_89
action_69 x = happyTcHack x happyFail (happyExpListPerState 69)

action_70 (58#) = happyShift action_88
action_70 x = happyTcHack x happyReduce_52

action_71 (59#) = happyShift action_87
action_71 x = happyTcHack x happyFail (happyExpListPerState 71)

action_72 (29#) = happyShift action_86
action_72 x = happyTcHack x happyFail (happyExpListPerState 72)

action_73 (29#) = happyShift action_85
action_73 x = happyTcHack x happyFail (happyExpListPerState 73)

action_74 x = happyTcHack x happyReduce_42

action_75 (33#) = happyShift action_30
action_75 (37#) = happyShift action_31
action_75 (38#) = happyShift action_32
action_75 (39#) = happyShift action_33
action_75 (49#) = happyShift action_34
action_75 (53#) = happyShift action_35
action_75 (57#) = happyShift action_36
action_75 (61#) = happyShift action_2
action_75 (4#) = happyGoto action_28
action_75 (19#) = happyGoto action_84
action_75 x = happyTcHack x happyFail (happyExpListPerState 75)

action_76 (31#) = happyShift action_83
action_76 x = happyTcHack x happyFail (happyExpListPerState 76)

action_77 (27#) = happyShift action_82
action_77 x = happyTcHack x happyReduce_49

action_78 (36#) = happyShift action_81
action_78 x = happyTcHack x happyFail (happyExpListPerState 78)

action_79 (61#) = happyShift action_2
action_79 (4#) = happyGoto action_42
action_79 (15#) = happyGoto action_80
action_79 x = happyTcHack x happyFail (happyExpListPerState 79)

action_80 (59#) = happyShift action_110
action_80 x = happyTcHack x happyFail (happyExpListPerState 80)

action_81 x = happyTcHack x happyReduce_43

action_82 (61#) = happyShift action_2
action_82 (4#) = happyGoto action_76
action_82 (20#) = happyGoto action_77
action_82 (21#) = happyGoto action_109
action_82 x = happyTcHack x happyReduce_48

action_83 (33#) = happyShift action_30
action_83 (37#) = happyShift action_31
action_83 (38#) = happyShift action_32
action_83 (39#) = happyShift action_33
action_83 (49#) = happyShift action_34
action_83 (53#) = happyShift action_35
action_83 (57#) = happyShift action_36
action_83 (61#) = happyShift action_2
action_83 (4#) = happyGoto action_28
action_83 (19#) = happyGoto action_108
action_83 x = happyTcHack x happyFail (happyExpListPerState 83)

action_84 x = happyTcHack x happyReduce_41

action_85 (33#) = happyShift action_30
action_85 (37#) = happyShift action_31
action_85 (38#) = happyShift action_32
action_85 (39#) = happyShift action_33
action_85 (49#) = happyShift action_34
action_85 (53#) = happyShift action_35
action_85 (57#) = happyShift action_36
action_85 (61#) = happyShift action_2
action_85 (4#) = happyGoto action_28
action_85 (19#) = happyGoto action_107
action_85 x = happyTcHack x happyFail (happyExpListPerState 85)

action_86 (33#) = happyShift action_30
action_86 (37#) = happyShift action_31
action_86 (38#) = happyShift action_32
action_86 (39#) = happyShift action_33
action_86 (49#) = happyShift action_34
action_86 (53#) = happyShift action_35
action_86 (57#) = happyShift action_36
action_86 (61#) = happyShift action_2
action_86 (4#) = happyGoto action_28
action_86 (19#) = happyGoto action_106
action_86 x = happyTcHack x happyFail (happyExpListPerState 86)

action_87 x = happyTcHack x happyReduce_44

action_88 (61#) = happyShift action_2
action_88 (4#) = happyGoto action_69
action_88 (22#) = happyGoto action_70
action_88 (23#) = happyGoto action_105
action_88 x = happyTcHack x happyFail (happyExpListPerState 88)

action_89 (33#) = happyShift action_30
action_89 (37#) = happyShift action_31
action_89 (38#) = happyShift action_32
action_89 (39#) = happyShift action_33
action_89 (49#) = happyShift action_34
action_89 (53#) = happyShift action_35
action_89 (57#) = happyShift action_36
action_89 (61#) = happyShift action_2
action_89 (4#) = happyGoto action_28
action_89 (19#) = happyGoto action_104
action_89 x = happyTcHack x happyFail (happyExpListPerState 89)

action_90 (47#) = happyShift action_103
action_90 x = happyTcHack x happyFail (happyExpListPerState 90)

action_91 x = happyTcHack x happyReduce_8

action_92 (57#) = happyShift action_102
action_92 x = happyTcHack x happyFail (happyExpListPerState 92)

action_93 x = happyTcHack x happyReduce_10

action_94 x = happyTcHack x happyReduce_31

action_95 x = happyTcHack x happyReduce_34

action_96 x = happyTcHack x happyReduce_11

action_97 x = happyTcHack x happyReduce_19

action_98 (24#) = happyShift action_14
action_98 (30#) = happyShift action_15
action_98 (33#) = happyShift action_16
action_98 (40#) = happyShift action_17
action_98 (41#) = happyShift action_18
action_98 (43#) = happyShift action_19
action_98 (45#) = happyShift action_20
action_98 (46#) = happyShift action_21
action_98 (48#) = happyShift action_22
action_98 (50#) = happyShift action_23
action_98 (52#) = happyShift action_24
action_98 (55#) = happyShift action_25
action_98 (61#) = happyShift action_2
action_98 (4#) = happyGoto action_3
action_98 (7#) = happyGoto action_101
action_98 (8#) = happyGoto action_7
action_98 (9#) = happyGoto action_8
action_98 (10#) = happyGoto action_9
action_98 (11#) = happyGoto action_10
action_98 (12#) = happyGoto action_11
action_98 (13#) = happyGoto action_12
action_98 (14#) = happyGoto action_13
action_98 x = happyTcHack x happyFail (happyExpListPerState 98)

action_99 (24#) = happyShift action_14
action_99 (30#) = happyShift action_15
action_99 (33#) = happyShift action_16
action_99 (40#) = happyShift action_17
action_99 (41#) = happyShift action_18
action_99 (43#) = happyShift action_19
action_99 (45#) = happyShift action_20
action_99 (46#) = happyShift action_21
action_99 (48#) = happyShift action_22
action_99 (50#) = happyShift action_23
action_99 (52#) = happyShift action_24
action_99 (55#) = happyShift action_25
action_99 (61#) = happyShift action_2
action_99 (4#) = happyGoto action_3
action_99 (7#) = happyGoto action_100
action_99 (8#) = happyGoto action_7
action_99 (9#) = happyGoto action_8
action_99 (10#) = happyGoto action_9
action_99 (11#) = happyGoto action_10
action_99 (12#) = happyGoto action_11
action_99 (13#) = happyGoto action_12
action_99 (14#) = happyGoto action_13
action_99 x = happyTcHack x happyFail (happyExpListPerState 99)

action_100 x = happyTcHack x happyReduce_6

action_101 x = happyTcHack x happyReduce_5

action_102 (61#) = happyShift action_2
action_102 (4#) = happyGoto action_112
action_102 (17#) = happyGoto action_113
action_102 (18#) = happyGoto action_114
action_102 x = happyTcHack x happyReduce_36

action_103 (24#) = happyShift action_14
action_103 (30#) = happyShift action_15
action_103 (33#) = happyShift action_16
action_103 (40#) = happyShift action_17
action_103 (41#) = happyShift action_18
action_103 (43#) = happyShift action_19
action_103 (45#) = happyShift action_20
action_103 (46#) = happyShift action_21
action_103 (48#) = happyShift action_22
action_103 (50#) = happyShift action_23
action_103 (52#) = happyShift action_24
action_103 (55#) = happyShift action_25
action_103 (61#) = happyShift action_2
action_103 (4#) = happyGoto action_3
action_103 (7#) = happyGoto action_111
action_103 (8#) = happyGoto action_7
action_103 (9#) = happyGoto action_8
action_103 (10#) = happyGoto action_9
action_103 (11#) = happyGoto action_10
action_103 (12#) = happyGoto action_11
action_103 (13#) = happyGoto action_12
action_103 (14#) = happyGoto action_13
action_103 x = happyTcHack x happyFail (happyExpListPerState 103)

action_104 x = happyTcHack x happyReduce_51

action_105 x = happyTcHack x happyReduce_53

action_106 x = happyTcHack x happyReduce_46

action_107 x = happyTcHack x happyReduce_45

action_108 x = happyTcHack x happyReduce_47

action_109 x = happyTcHack x happyReduce_50

action_110 x = happyTcHack x happyReduce_22

action_111 x = happyTcHack x happyReduce_7

action_112 (61#) = happyShift action_2
action_112 (4#) = happyGoto action_117
action_112 x = happyTcHack x happyFail (happyExpListPerState 112)

action_113 (27#) = happyShift action_116
action_113 x = happyTcHack x happyReduce_37

action_114 (59#) = happyShift action_115
action_114 x = happyTcHack x happyFail (happyExpListPerState 114)

action_115 x = happyTcHack x happyReduce_23

action_116 (61#) = happyShift action_2
action_116 (4#) = happyGoto action_112
action_116 (17#) = happyGoto action_113
action_116 (18#) = happyGoto action_119
action_116 x = happyTcHack x happyReduce_36

action_117 (28#) = happyShift action_118
action_117 x = happyTcHack x happyFail (happyExpListPerState 117)

action_118 (24#) = happyShift action_14
action_118 (30#) = happyShift action_15
action_118 (33#) = happyShift action_16
action_118 (40#) = happyShift action_17
action_118 (41#) = happyShift action_18
action_118 (43#) = happyShift action_19
action_118 (45#) = happyShift action_20
action_118 (46#) = happyShift action_21
action_118 (48#) = happyShift action_22
action_118 (50#) = happyShift action_23
action_118 (52#) = happyShift action_24
action_118 (55#) = happyShift action_25
action_118 (61#) = happyShift action_2
action_118 (4#) = happyGoto action_3
action_118 (7#) = happyGoto action_120
action_118 (8#) = happyGoto action_7
action_118 (9#) = happyGoto action_8
action_118 (10#) = happyGoto action_9
action_118 (11#) = happyGoto action_10
action_118 (12#) = happyGoto action_11
action_118 (13#) = happyGoto action_12
action_118 (14#) = happyGoto action_13
action_118 x = happyTcHack x happyFail (happyExpListPerState 118)

action_119 x = happyTcHack x happyReduce_38

action_120 x = happyTcHack x happyReduce_35

happyReduce_1 = happySpecReduce_1  4# happyReduction_1
happyReduction_1 happy_x_1
	 =  case happyOutTok happy_x_1 of { (PT _ (TV happy_var_1)) -> 
	happyIn4
		 (Lang.Abs.Ident happy_var_1
	)}

happyReduce_2 = happySpecReduce_1  5# happyReduction_2
happyReduction_2 happy_x_1
	 =  case happyOut6 happy_x_1 of { (HappyWrap6 happy_var_1) -> 
	happyIn5
		 (Lang.Abs.Gen happy_var_1
	)}

happyReduce_3 = happySpecReduce_1  6# happyReduction_3
happyReduction_3 happy_x_1
	 =  case happyOut7 happy_x_1 of { (HappyWrap7 happy_var_1) -> 
	happyIn6
		 ((:[]) happy_var_1
	)}

happyReduce_4 = happySpecReduce_3  6# happyReduction_4
happyReduction_4 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut7 happy_x_1 of { (HappyWrap7 happy_var_1) -> 
	case happyOut6 happy_x_3 of { (HappyWrap6 happy_var_3) -> 
	happyIn6
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_5 = happyReduce 5# 7# happyReduction_5
happyReduction_5 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut8 happy_x_3 of { (HappyWrap8 happy_var_3) -> 
	case happyOut7 happy_x_5 of { (HappyWrap7 happy_var_5) -> 
	happyIn7
		 (Lang.Abs.PLet happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_6 = happyReduce 5# 7# happyReduction_6
happyReduction_6 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut8 happy_x_3 of { (HappyWrap8 happy_var_3) -> 
	case happyOut7 happy_x_5 of { (HappyWrap7 happy_var_5) -> 
	happyIn7
		 (Lang.Abs.PBind happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_7 = happyReduce 6# 7# happyReduction_7
happyReduction_7 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut7 happy_x_2 of { (HappyWrap7 happy_var_2) -> 
	case happyOut7 happy_x_4 of { (HappyWrap7 happy_var_4) -> 
	case happyOut7 happy_x_6 of { (HappyWrap7 happy_var_6) -> 
	happyIn7
		 (Lang.Abs.PIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_8 = happyReduce 4# 7# happyReduction_8
happyReduction_8 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut12 happy_x_2 of { (HappyWrap12 happy_var_2) -> 
	case happyOut7 happy_x_4 of { (HappyWrap7 happy_var_4) -> 
	happyIn7
		 (Lang.Abs.PGuard happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_9 = happySpecReduce_1  7# happyReduction_9
happyReduction_9 happy_x_1
	 =  case happyOut8 happy_x_1 of { (HappyWrap8 happy_var_1) -> 
	happyIn7
		 (happy_var_1
	)}

happyReduce_10 = happyReduce 4# 8# happyReduction_10
happyReduction_10 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_2 of { (HappyWrap4 happy_var_2) -> 
	case happyOut8 happy_x_4 of { (HappyWrap8 happy_var_4) -> 
	happyIn8
		 (Lang.Abs.PLambda happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_11 = happyReduce 4# 8# happyReduction_11
happyReduction_11 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_2 of { (HappyWrap4 happy_var_2) -> 
	case happyOut8 happy_x_4 of { (HappyWrap8 happy_var_4) -> 
	happyIn8
		 (Lang.Abs.PLambdaT happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_12 = happySpecReduce_1  8# happyReduction_12
happyReduction_12 happy_x_1
	 =  case happyOut9 happy_x_1 of { (HappyWrap9 happy_var_1) -> 
	happyIn8
		 (happy_var_1
	)}

happyReduce_13 = happySpecReduce_3  9# happyReduction_13
happyReduction_13 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut9 happy_x_1 of { (HappyWrap9 happy_var_1) -> 
	case happyOut10 happy_x_3 of { (HappyWrap10 happy_var_3) -> 
	happyIn9
		 (Lang.Abs.PPlus happy_var_1 happy_var_3
	)}}

happyReduce_14 = happySpecReduce_1  9# happyReduction_14
happyReduction_14 happy_x_1
	 =  case happyOut10 happy_x_1 of { (HappyWrap10 happy_var_1) -> 
	happyIn9
		 (happy_var_1
	)}

happyReduce_15 = happySpecReduce_2  10# happyReduction_15
happyReduction_15 happy_x_2
	happy_x_1
	 =  case happyOut14 happy_x_2 of { (HappyWrap14 happy_var_2) -> 
	happyIn10
		 (Lang.Abs.PReturn happy_var_2
	)}

happyReduce_16 = happySpecReduce_2  10# happyReduction_16
happyReduction_16 happy_x_2
	happy_x_1
	 =  case happyOut19 happy_x_2 of { (HappyWrap19 happy_var_2) -> 
	happyIn10
		 (Lang.Abs.PDistr happy_var_2
	)}

happyReduce_17 = happySpecReduce_1  10# happyReduction_17
happyReduction_17 happy_x_1
	 =  case happyOut14 happy_x_1 of { (HappyWrap14 happy_var_1) -> 
	happyIn10
		 (happy_var_1
	)}

happyReduce_18 = happySpecReduce_3  11# happyReduction_18
happyReduction_18 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut11 happy_x_1 of { (HappyWrap11 happy_var_1) -> 
	case happyOut4 happy_x_3 of { (HappyWrap4 happy_var_3) -> 
	happyIn11
		 (Lang.Abs.PProj happy_var_1 happy_var_3
	)}}

happyReduce_19 = happyReduce 4# 11# happyReduction_19
happyReduction_19 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut12 happy_x_1 of { (HappyWrap12 happy_var_1) -> 
	case happyOut19 happy_x_3 of { (HappyWrap19 happy_var_3) -> 
	happyIn11
		 (Lang.Abs.PAppT happy_var_1 happy_var_3
	) `HappyStk` happyRest}}

happyReduce_20 = happySpecReduce_1  11# happyReduction_20
happyReduction_20 happy_x_1
	 =  case happyOut12 happy_x_1 of { (HappyWrap12 happy_var_1) -> 
	happyIn11
		 (happy_var_1
	)}

happyReduce_21 = happySpecReduce_3  12# happyReduction_21
happyReduction_21 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut16 happy_x_2 of { (HappyWrap16 happy_var_2) -> 
	happyIn12
		 (Lang.Abs.PProd happy_var_2
	)}

happyReduce_22 = happyReduce 5# 12# happyReduction_22
happyReduction_22 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut19 happy_x_2 of { (HappyWrap19 happy_var_2) -> 
	case happyOut15 happy_x_4 of { (HappyWrap15 happy_var_4) -> 
	happyIn12
		 (Lang.Abs.PSum happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_23 = happyReduce 7# 12# happyReduction_23
happyReduction_23 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut7 happy_x_2 of { (HappyWrap7 happy_var_2) -> 
	case happyOut19 happy_x_4 of { (HappyWrap19 happy_var_4) -> 
	case happyOut18 happy_x_6 of { (HappyWrap18 happy_var_6) -> 
	happyIn12
		 (Lang.Abs.PCase happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest}}}

happyReduce_24 = happySpecReduce_2  12# happyReduction_24
happyReduction_24 happy_x_2
	happy_x_1
	 =  case happyOut12 happy_x_1 of { (HappyWrap12 happy_var_1) -> 
	case happyOut13 happy_x_2 of { (HappyWrap13 happy_var_2) -> 
	happyIn12
		 (Lang.Abs.PApp happy_var_1 happy_var_2
	)}}

happyReduce_25 = happySpecReduce_1  12# happyReduction_25
happyReduction_25 happy_x_1
	 =  case happyOut13 happy_x_1 of { (HappyWrap13 happy_var_1) -> 
	happyIn12
		 (happy_var_1
	)}

happyReduce_26 = happySpecReduce_1  13# happyReduction_26
happyReduction_26 happy_x_1
	 =  happyIn13
		 (Lang.Abs.PBoolT
	)

happyReduce_27 = happySpecReduce_1  13# happyReduction_27
happyReduction_27 happy_x_1
	 =  happyIn13
		 (Lang.Abs.PBoolF
	)

happyReduce_28 = happySpecReduce_1  13# happyReduction_28
happyReduction_28 happy_x_1
	 =  case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	happyIn13
		 (Lang.Abs.PVar happy_var_1
	)}

happyReduce_29 = happySpecReduce_3  13# happyReduction_29
happyReduction_29 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut7 happy_x_2 of { (HappyWrap7 happy_var_2) -> 
	happyIn13
		 (happy_var_2
	)}

happyReduce_30 = happySpecReduce_1  14# happyReduction_30
happyReduction_30 happy_x_1
	 =  case happyOut11 happy_x_1 of { (HappyWrap11 happy_var_1) -> 
	happyIn14
		 (happy_var_1
	)}

happyReduce_31 = happySpecReduce_3  15# happyReduction_31
happyReduction_31 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut7 happy_x_3 of { (HappyWrap7 happy_var_3) -> 
	happyIn15
		 (Lang.Abs.PLabExp happy_var_1 happy_var_3
	)}}

happyReduce_32 = happySpecReduce_0  16# happyReduction_32
happyReduction_32  =  happyIn16
		 ([]
	)

happyReduce_33 = happySpecReduce_1  16# happyReduction_33
happyReduction_33 happy_x_1
	 =  case happyOut15 happy_x_1 of { (HappyWrap15 happy_var_1) -> 
	happyIn16
		 ((:[]) happy_var_1
	)}

happyReduce_34 = happySpecReduce_3  16# happyReduction_34
happyReduction_34 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut15 happy_x_1 of { (HappyWrap15 happy_var_1) -> 
	case happyOut16 happy_x_3 of { (HappyWrap16 happy_var_3) -> 
	happyIn16
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_35 = happyReduce 4# 17# happyReduction_35
happyReduction_35 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut4 happy_x_2 of { (HappyWrap4 happy_var_2) -> 
	case happyOut7 happy_x_4 of { (HappyWrap7 happy_var_4) -> 
	happyIn17
		 (Lang.Abs.PCaseExp happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_36 = happySpecReduce_0  18# happyReduction_36
happyReduction_36  =  happyIn18
		 ([]
	)

happyReduce_37 = happySpecReduce_1  18# happyReduction_37
happyReduction_37 happy_x_1
	 =  case happyOut17 happy_x_1 of { (HappyWrap17 happy_var_1) -> 
	happyIn18
		 ((:[]) happy_var_1
	)}

happyReduce_38 = happySpecReduce_3  18# happyReduction_38
happyReduction_38 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut17 happy_x_1 of { (HappyWrap17 happy_var_1) -> 
	case happyOut18 happy_x_3 of { (HappyWrap18 happy_var_3) -> 
	happyIn18
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_39 = happySpecReduce_1  19# happyReduction_39
happyReduction_39 happy_x_1
	 =  happyIn19
		 (Lang.Abs.PTBool
	)

happyReduce_40 = happySpecReduce_1  19# happyReduction_40
happyReduction_40 happy_x_1
	 =  case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	happyIn19
		 (Lang.Abs.PTVar happy_var_1
	)}

happyReduce_41 = happySpecReduce_3  19# happyReduction_41
happyReduction_41 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut19 happy_x_2 of { (HappyWrap19 happy_var_2) -> 
	case happyOut19 happy_x_3 of { (HappyWrap19 happy_var_3) -> 
	happyIn19
		 (Lang.Abs.PTArr happy_var_2 happy_var_3
	)}}

happyReduce_42 = happySpecReduce_2  19# happyReduction_42
happyReduction_42 happy_x_2
	happy_x_1
	 =  case happyOut19 happy_x_2 of { (HappyWrap19 happy_var_2) -> 
	happyIn19
		 (Lang.Abs.PTDist happy_var_2
	)}

happyReduce_43 = happySpecReduce_3  19# happyReduction_43
happyReduction_43 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut21 happy_x_2 of { (HappyWrap21 happy_var_2) -> 
	happyIn19
		 (Lang.Abs.PTProd happy_var_2
	)}

happyReduce_44 = happySpecReduce_3  19# happyReduction_44
happyReduction_44 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut23 happy_x_2 of { (HappyWrap23 happy_var_2) -> 
	happyIn19
		 (Lang.Abs.PTSum happy_var_2
	)}

happyReduce_45 = happyReduce 4# 19# happyReduction_45
happyReduction_45 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_2 of { (HappyWrap4 happy_var_2) -> 
	case happyOut19 happy_x_4 of { (HappyWrap19 happy_var_4) -> 
	happyIn19
		 (Lang.Abs.PTAll happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_46 = happyReduce 4# 19# happyReduction_46
happyReduction_46 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut4 happy_x_2 of { (HappyWrap4 happy_var_2) -> 
	case happyOut19 happy_x_4 of { (HappyWrap19 happy_var_4) -> 
	happyIn19
		 (Lang.Abs.PTInd happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

happyReduce_47 = happySpecReduce_3  20# happyReduction_47
happyReduction_47 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut19 happy_x_3 of { (HappyWrap19 happy_var_3) -> 
	happyIn20
		 (Lang.Abs.TMember happy_var_1 happy_var_3
	)}}

happyReduce_48 = happySpecReduce_0  21# happyReduction_48
happyReduction_48  =  happyIn21
		 ([]
	)

happyReduce_49 = happySpecReduce_1  21# happyReduction_49
happyReduction_49 happy_x_1
	 =  case happyOut20 happy_x_1 of { (HappyWrap20 happy_var_1) -> 
	happyIn21
		 ((:[]) happy_var_1
	)}

happyReduce_50 = happySpecReduce_3  21# happyReduction_50
happyReduction_50 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut20 happy_x_1 of { (HappyWrap20 happy_var_1) -> 
	case happyOut21 happy_x_3 of { (HappyWrap21 happy_var_3) -> 
	happyIn21
		 ((:) happy_var_1 happy_var_3
	)}}

happyReduce_51 = happySpecReduce_3  22# happyReduction_51
happyReduction_51 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut4 happy_x_1 of { (HappyWrap4 happy_var_1) -> 
	case happyOut19 happy_x_3 of { (HappyWrap19 happy_var_3) -> 
	happyIn22
		 (Lang.Abs.TMember1 happy_var_1 happy_var_3
	)}}

happyReduce_52 = happySpecReduce_1  23# happyReduction_52
happyReduction_52 happy_x_1
	 =  case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	happyIn23
		 ((:[]) happy_var_1
	)}

happyReduce_53 = happySpecReduce_3  23# happyReduction_53
happyReduction_53 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut22 happy_x_1 of { (HappyWrap22 happy_var_1) -> 
	case happyOut23 happy_x_3 of { (HappyWrap23 happy_var_3) -> 
	happyIn23
		 ((:) happy_var_1 happy_var_3
	)}}

happyNewToken action sts stk [] =
	action 62# 62# notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 24#;
	PT _ (TS _ 2) -> cont 25#;
	PT _ (TS _ 3) -> cont 26#;
	PT _ (TS _ 4) -> cont 27#;
	PT _ (TS _ 5) -> cont 28#;
	PT _ (TS _ 6) -> cont 29#;
	PT _ (TS _ 7) -> cont 30#;
	PT _ (TS _ 8) -> cont 31#;
	PT _ (TS _ 9) -> cont 32#;
	PT _ (TS _ 10) -> cont 33#;
	PT _ (TS _ 11) -> cont 34#;
	PT _ (TS _ 12) -> cont 35#;
	PT _ (TS _ 13) -> cont 36#;
	PT _ (TS _ 14) -> cont 37#;
	PT _ (TS _ 15) -> cont 38#;
	PT _ (TS _ 16) -> cont 39#;
	PT _ (TS _ 17) -> cont 40#;
	PT _ (TS _ 18) -> cont 41#;
	PT _ (TS _ 19) -> cont 42#;
	PT _ (TS _ 20) -> cont 43#;
	PT _ (TS _ 21) -> cont 44#;
	PT _ (TS _ 22) -> cont 45#;
	PT _ (TS _ 23) -> cont 46#;
	PT _ (TS _ 24) -> cont 47#;
	PT _ (TS _ 25) -> cont 48#;
	PT _ (TS _ 26) -> cont 49#;
	PT _ (TS _ 27) -> cont 50#;
	PT _ (TS _ 28) -> cont 51#;
	PT _ (TS _ 29) -> cont 52#;
	PT _ (TS _ 30) -> cont 53#;
	PT _ (TS _ 31) -> cont 54#;
	PT _ (TS _ 32) -> cont 55#;
	PT _ (TS _ 33) -> cont 56#;
	PT _ (TS _ 34) -> cont 57#;
	PT _ (TS _ 35) -> cont 58#;
	PT _ (TS _ 36) -> cont 59#;
	PT _ (TS _ 37) -> cont 60#;
	PT _ (TV happy_dollar_dollar) -> cont 61#;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 62# tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = ((>>=))
happyReturn :: () => a -> Err a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pGen tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> happyReturn (let {(HappyWrap5 x') = happyOut5 x} in x'))

happySeq = happyDontSeq


type Err = Either String

happyError :: [Token] -> Err a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer :: String -> [Token]
myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $













-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Prelude.Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Prelude.Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Prelude.Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif



















data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 1# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j ) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

































indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `Prelude.mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Happy_GHC_Exts.Int# ->                    -- token number
         Happy_GHC_Exts.Int# ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 1# tk st sts stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((happyInTok (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 1# tk st sts stk
     = happyFail [] 1# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Happy_GHC_Exts.Int#
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n ((_):(t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 1# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action 1# 1# tk (HappyState (action)) sts ((Happy_GHC_Exts.unsafeCoerce# (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
