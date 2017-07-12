
module Command.FromFormat.ToFormatInfo (
    module Command.FromFormat.ToFormatInfo
  ) where

import Model.Format

toFormatInfo :: Format -> FormatInfo
toFormatInfo fmt = case fmt of
  SelectS ->
    ToFormatInfo Select [S]
  SelectKS ->
    ToFormatInfo Select [K,S]
  SelectKSS ->
    ToFormatInfo Select [K,S,S]
  SelectWS ->
    ToFormatInfo Select [W,S]
  SelectWSS ->
    ToFormatInfo Select [W,S,S]
  SelectWWS ->
    ToFormatInfo Select [W,W,S]
  SelectWWSS ->
    ToFormatInfo Select [W,W,S,S]

  SelectKWS ->
    ToFormatInfo Select [K,W,S]
  SelectKWSS ->
    ToFormatInfo Select [K,W,S,S]
  SelectKRS ->
    ToFormatInfo Select [K,R,S]
  SelectKRSS ->
    ToFormatInfo Select [K,R,S,S]
  SelectKRWS ->
    ToFormatInfo Select [K,R,W,S]
  SelectKRWSS ->
    ToFormatInfo Select [K,R,W,S,S]

  UpdateKU ->
    ToFormatInfo Update [K,U]
  UpdateKUU ->
    ToFormatInfo Update [K,U,U]
  SelectForKU ->
    ToFormatInfo SelectForUpdate [K,U]
  SelectForKUU ->
    ToFormatInfo SelectForUpdate [K,U,U]


