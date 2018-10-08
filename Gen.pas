program Gen;

{$mode objfpc}{$H+}

uses
  contnrs,
  SysUtils;

var
  HashTable: TFPStringHashTable;
  Limit: integer;
  Slen: integer;
  I, J, K: integer;
  NumStr: string;
  Duplicate: integer;
begin
  Limit := 10;
  Slen := 7;
  HashTable := TFPStringHashTable.Create;

  if ParamCount = 2 then
  begin
    Limit := StrToInt(ParamStr(1));
    Slen := StrToInt(ParamStr(2));
  end;

  for I := 1 to Limit do
  begin
    Duplicate := 1;
    while Duplicate = 1 do
    begin
      NumStr := '';
      for J := 1 to Slen do
      begin
        K := Random(9) + 1;
        NumStr := Concat(NumStr, IntToStr(K));
      end;

      if HashTable.Find(NumStr) = nil then
      begin
        WriteLn(NumStr);
        HashTable[NumStr] := '1';
        Duplicate := 0;
      end
      else
      begin
        WriteLn(StdErr, 'Duplicate = ', NumStr);
      end;
    end;
  end;
  HashTable.Free;
end.
