unit uPublic;

interface

uses SysUtils;

implementation


{==============================================================================}
{=================================函数定义集合=================================}
{================= Copyright(R) 2003 KingLong Software Studio =================}
{==============================================================================}

{从搜索记录中判断是否是子目录}
function IsValidDir(SearchRec: TSearchRec): Boolean;
begin
  if (SearchRec.Attr = 16) and (SearchRec.Name <> '.') and
     (SearchRec.Name <> '..') then
     Result := True
  else
    Result := False;
end;

end.
