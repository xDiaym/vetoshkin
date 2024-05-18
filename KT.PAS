Unit KT;

interface
uses Objects, Drivers, Dialogs, MsgBox, Vector;

const
  cmEnter  = 1010;
  cmExit   = 1011;


type
  PVectorDialog = ^TVectorDialog;
  TVectorDialog = object(TDialog)
    input, output, vecsize: PInputLine;
    vector: PVector;

    constructor Init(v: PVector);
    procedure HandleEvent(var Event : TEvent); virtual;
    procedure SetOutput;
    procedure ReadInput; 
  end;

implementation

constructor TVectorDialog.Init(v: PVector); 
var
  R: TRect;
  InitialVal: string;
begin
  {vector := New(PVector, Init(0));}

  R.Assign(15, 5, 73, 18);
  inherited Init(R, 'Vector');

  R.Assign(2, 3, 25, 4);
  Insert(New(PStaticText, Init(R,'Vector format: 1, 2, 3')));

  R.Assign(2, 5, 25, 6);
  Insert(New(PStaticText, Init(R, 'Enter vector:')));

  R.Assign(18, 5, 40, 6);
  input := New(PInputLine, Init(R, 35));
  Insert(input);

  R.Assign(2, 7, 25, 8);
  Insert(New(PStaticText, Init(R, 'Vector:')));
  R.Assign(18, 7, 40, 8);
  output := New(PInputLine, Init(R, 35));
  Insert(Output);

  R.Assign(2, 9, 10, 10);
  Insert(New(PStaticText, Init(R, 'Size: ')));
  R.Assign(11, 9, 15, 10);
  vecsize := New(PInputLine, Init(R, 3));
  Insert(vecsize);

  vector := v;
  SetOutput;

  R.Assign(16, 10, 27, 12);
  Insert(New(PButton, Init(R, 'Enter', cmEnter, bfNormal)));
  R.Assign(32, 10, 43, 12);
  Insert(New(PButton, Init(R, 'Close', cmExit, bfNormal)));
end;

procedure TVectorDialog.SetOutput;
var
  s, buff: string;
  i: integer;
begin
  s := '';
  Str(vector^.Size, s);
  vecsize^.SetData(s);

  s := '';
  for i := 1 to vector^.Size do begin
    Str(vector^.Data[i], buff);
    s := s + buff;
    if i < vector^.Size then begin
      s := s + ', ';
    end;
  end;
  output^.SetData(s);
end;

procedure TVectorDialog.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmEnter:  begin
        ReadInput;
        SetOutput;
      end;
      cmExit:   Close;
    end;
    ClearEvent(Event);
  end;
  if (Event.What = evKeyDown) and (Event.KeyCode = kbEnter) then
  begin
    ReadInput;
    SetOutput;
    ClearEvent(Event);
  end;
end;

procedure TVectorDialog.ReadInput;
var
  V: Vec;
  VecStr, Buff: string;
  I, Num, err, N: integer;
  IsFirst: boolean;

  procedure SkipWhitespaces;
  begin
    while ((I <= Length(VecStr)) and (VecStr[I] = ' ')) do
      I := I + 1;
  end;

  function IsDigit(c: char): boolean;
  begin
    IsDigit := (Ord('0') <= Ord(c)) and (Ord(c) <= Ord('9'));
  end;

  procedure TakeNumber;
  begin
    while ((I <= Length(VecStr)) and IsDigit(VecStr[I])) do begin
      Buff := Buff + VecStr[i];
      I := I + 1;
    end;
  end;

  procedure Warn;
  begin
    MessageBox(' Invalid input format for vector. Use "1, 2, 3"',
      nil,
      mfOkButton or mfInformation);
  end;

  procedure Push(x: integer);
  begin
    N := N + 1;
    V[N] := x;
  end;

begin
  input^.GetData(VecStr);
  N := 0; 
  I := 1;
  IsFirst := true;

  while I <= Length(VecStr) do begin
    SkipWhitespaces;
    if not IsFirst then begin
      if VecStr[I] <> ',' then begin Warn; Exit; end
      else I := I + 1;
    end;
    SkipWhitespaces;

    Buff := '';
    TakeNumber;
    Val(Buff, Num, err);
    if err <> 0 then begin Warn; Exit; end;
    Push(Num);
    IsFirst := false;
  end;

  vector^.SetLength(N);
  vector^.SetValues(V);
end;
end.
