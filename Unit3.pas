{$optimization off}
unit Unit3;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,Dialogs, StdCtrls;

type
TArray = array of integer;
LongArithmetic = class
private i_length: integer;
private a_number: TArray;
private s_sign: Char;

private procedure SetLengthNumber(i_length_param: integer);
protected function GetLengthNumber(): integer;

private procedure SetNumber(a_number_param: TArray);
protected function GetNumber(): TArray;

protected procedure SetSign(s_sign_param: Char);
protected function GetSign(): char;

protected function CompLong(a_nubmer: TArray; b_nubmer: TArray): integer;
protected function ArrayToString(a_number_convert: TArray): string;
protected function BalanceArray(a_number_balance: TArray; i_length_add: integer): TArray;
protected function ClearZero(a_number_clear: TArray): TArray;
protected procedure CheckDivider(a_divider: TArray);

public function GetResult(o_result: LongArithmetic): string;

private function PrepareNumber(s_number: string): TArray;

public Property PLength: integer read GetLengthNumber write SetLengthNumber;
public Property PNumber: TArray read GetNumber write SetNumber;
public Property PSign: char read GetSign write SetSign;

public constructor Create(s_number_param: string; s_sign: char = ' ');
end;

implementation

constructor LongArithmetic.Create(s_number_param: string; s_sign: char = ' ');
var a_template: TArray;
begin
  a_template := PrepareNumber(s_number_param);
  SetNumber(a_template);
  setLengthNumber(GetLengthNumber());
  setSign(s_sign);
end;

procedure LongArithmetic.setLengthNumber(i_length_param: integer);
begin
  i_length := i_length_param;
end;

function LongArithmetic.GetLengthNumber(): integer;
begin
  Result := i_length;
end;

procedure LongArithmetic.setNumber(a_number_param: TArray);
var i,i_length: integer;
begin
  i_length := GetLengthNumber();
  SetLength(a_number,i_length);
  for i := 0 to i_length-1 do
  begin
    a_number[i] := a_number_param[i];
  end;
end;

function LongArithmetic.getNumber(): TArray;
begin
  Result := a_number;
end;

function LongArithmetic.ArrayToString(a_number_convert: TArray): string;
var
  s_number: string;
  i,i_number_length: Integer;
begin
  s_number := '';
  i_number_length := Length(a_number_convert);
  for i := 0 to i_number_length-1 do
  begin
    s_number := s_number + IntToStr(a_number_convert[i]);
  end;
  Result:= s_number;
end;

function LongArithmetic.CompLong(a_nubmer: TArray; b_nubmer: TArray):integer;
 var i: integer;
begin
  for i:=0 to Length(a_nubmer)-1 do
  begin
    if(a_nubmer[i] < b_nubmer[i]) then
    begin
      Result:= -1;
      Exit;
    end;
    if(a_nubmer[i] > b_nubmer[i]) then
    begin
      Result:= 1;
      Exit;
    end;
  end;
  Result := 0;
end;

function LongArithmetic.GetResult(o_result: LongArithmetic): string;
begin
  Result := String(o_result.s_sign) + ArrayToString(o_result.GetNumber());
end;

function LongArithmetic.PrepareNumber(s_number: string): TArray;
var
  i,i_length: integer;
  a_number_template: TArray;
begin
  s_number := Trim(s_number);
  If(s_number = '') Then
      Raise Exception.Create('Заполнены не все поля!');
  i_length := Length(s_number);
  SetLength(a_number_template,i_length);
  for i := 0 to i_length-1 do
  begin
    a_number_template[i] := 0;
  end;

  for i := 0 to i_length-1 do
  begin
    If((Ord(s_number[i+1]) > 57) or (Ord(s_number[i+1]) < 48)) Then
      Raise Exception.Create('Число"'+s_number+'"введенно не корректно!');
    a_number_template[i] := Ord(s_number[i+1])-48;
  end;
  a_number_template := ClearZero(a_number_template);

  SetLengthNumber(Length(a_number_template));
  Result := a_number_template;
end;


function LongArithmetic.BalanceArray(a_number_balance: TArray; i_length_add: integer): TArray;
var
  i: integer;
  a_template: TArray;
begin
  SetLength(a_template,Length(a_number_balance)+i_length_add);
  for i := Length(a_number_balance)-1 downto 0 do
    a_template[i+i_length_add] := a_number_balance[i];

  Result := a_template;
end;

procedure LongArithmetic.SetSign(s_sign_param: Char);
begin
  s_sign := s_sign_param;
end;

function LongArithmetic.GetSign(): char;
begin
  Result := s_sign;
end;

function LongArithmetic.ClearZero(a_number_clear: TArray): TArray;
var
  i,i_template,i_length_difference,i_length: integer;
  a_template: TArray;
begin
  i_length:= Length(a_number_clear);
  i_template := i_length;
  for i := 0 to i_length-1 do
  begin
    if(a_number_clear[i] > 0) then
    begin
      i_template := i;
      break;
    end;
  end;

  i_length_difference := i_length - i_template;
  if(i_length_difference = 0) then
  begin
    i_length_difference := 1;
    SetLength(a_template, i_length_difference);
    a_template[0] := 0;
  end
  else
  begin
    SetLength(a_template, i_length_difference);
    for i := 0 to i_length_difference-1 do
      a_template[i] := a_number_clear[i_template + i];
  end;

  Result := a_template;
end;

procedure LongArithmetic.CheckDivider(a_divider: TArray);
begin
    If((Length(a_divider) = 1) and (a_divider[0] = 0)) Then Raise EZeroDivide.Create ('Деление на ноль запрещено!');
end;
end.

