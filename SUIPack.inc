{$IFDEF VER130}         // Delphi 5 & BCB 5
  {$DEFINE SUIPACK_D5}
{$ENDIF}

{$IFDEF VER140}         // Delphi 6
  {$DEFINE SUIPACK_D6UP}
{$ENDIF}

{$IFDEF VER150}         // Delphi 7
  {$DEFINE SUIPACK_D6UP}
{$ENDIF}

{$IFDEF VER170}         // Delphi 9
  {$DEFINE SUIPACK_D9}
  {$DEFINE SUIPACK_D9UP}
  {$DEFINE SUIPACK_D6UP}
{$ENDIF}

{$IFDEF VER180}         // Delphi 10
  {$DEFINE SUIPACK_D10}
  {$DEFINE SUIPACK_D9UP}
  {$DEFINE SUIPACK_D6UP}
{$ENDIF}

{$IFDEF VER200}         // Delphi 12
  {$DEFINE SUIPACK_D10}
  {$DEFINE SUIPACK_D9UP}
  {$DEFINE SUIPACK_D6UP}
  {$DEFINE SUIPACK_D12}
  {$DEFINE SUIPACK_D12UP}
{$ENDIF}

{$DEFINE DB}   // for professional or enterprise Delphi

// {$DEFINE LANG_CHS}	// Simplified Chinese support


// Warning: Modifing the code bellow maybe cause problems of SUIPack.
// Don't modify it unless you are sure you can master it by yourself. :)
{$DEFINE RES_MACOS}     // for link MacOS resource
{$DEFINE RES_WINXP}     // for link WinXP resource
{$DEFINE RES_DEEPBLUE}  // for link DeepBlue resource
{$DEFINE RES_BLUEGLASS} // for link BlueGlass resource
{$DEFINE RES_PROTEIN}   // for link Protein resource

{$IFDEF RES_MACOS}
    {$IFDEF RES_WINXP}
        {$IFDEF RES_DEEPBLUE}
            {$IFDEF RES_BLUEGLASS}
                {$IFDEF RES_PROTEIN}
                    {$DEFINE RES_ALL}  //for link all resource
		        {$ENDIF}
	        {$ENDIF}
	    {$ENDIF}
    {$ENDIF}
{$ENDIF}