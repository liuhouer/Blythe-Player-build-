{*****************************************************}
{                                                     }
{     Varian Skin Factory                             }
{                                                     }
{     TMS software 1996-2002                          }
{     All Rights Reserved                             }
{                                                     }
{ ****************************************************}


{.$B-} { Complete Boolean Evaluation }
{.$R-} { Range-Checking }
{.$V-} { Var-String Checking }
{.$I-} { IO Checking }
{.$Q-} { Overflow checking }
{.$D-} { No debug information }
{.$L-} { Local symbols }
{.$Y-} { Assertions }


{$IFDEF VER140}
  {$DEFINE VER130}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE VER130}
  {$DEFINE VER140}
{$ENDIF}

