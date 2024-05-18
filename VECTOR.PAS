unit Vector;

interface

uses
  Objects, Views;

const
  MaxSize = 20;

type
  PVector = ^TVector;
  Vec = array[1..MaxSize] of integer;
  TVector = object(TObject)
    Data: Vec;
    Size: Integer;
    constructor Init(aSize: Integer);
    procedure SetValues(Values: Vec);
    procedure SetLength(aSize: Integer);
    procedure AddValue(Value: Integer);
    function DotProduct(Other: PVector): Integer;
    procedure Print;
  end;

implementation

constructor TVector.Init(aSize: Integer);
var
  I: Integer;
begin
  Size := aSize;
  for I := 1 to Size do
    Data[I] := 0;
end;

procedure TVector.SetValues(Values: Vec);
var
  I: Integer;
begin
  for I := 1 to Size do
    Data[I] := Values[I];
end;

procedure TVector.SetLength(aSize: Integer);
begin
  Size := aSize;
end;

procedure TVector.AddValue(Value: Integer);
begin
  Size := Size + 1;
  Data[Size] := Value;
end;

function TVector.DotProduct(Other: PVector): Integer;
var
  Result: Integer;
  I: Integer;
begin
  Result := 0;
  for I := 1 to Size do
    Result := Result + Data[I] * Other^.Data[I];

  DotProduct := Result;
end;

procedure TVector.Print;
var
  I: Integer;
begin
  Write('Vector: (');
  for I := 1 to Size do
  begin
    Write(Data[I]);
    if I < Size then
      Write(', ');
  end;
  WriteLn(')');
end;

end.