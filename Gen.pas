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
  NumStr: array of char;
  Key: string;
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

  SetLength(NumStr, Slen);

  for I := 1 to Limit do
  begin
    Duplicate := 1;
    while Duplicate = 1 do
    begin
      for J := 1 to Slen do
      begin
        K := Random(9) + 1;
        NumStr[J - 1] := Chr(Ord('0') + K);
      end;

      SetString(Key, PChar(@NumStr[0]), Slen);

      if HashTable.Find(Key) = nil then
      begin
        WriteLn(Key);
        HashTable[Key] := '1';
        Duplicate := 0;
      end
      else
      begin
        WriteLn(StdErr, 'Duplicate = ', Key);
      end;
    end;
  end;

  NumStr := nil;
  HashTable.Free;
end.
