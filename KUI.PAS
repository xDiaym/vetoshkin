uses Objects, Drivers, Views, Menus, App, KT, MsgBox, Vector, Dialogs;

const
  cmShowVectorInput1 = 1000;
  cmShowVectorInput2 = 1001;
  cmShowDot          = 1002;

  cmSaveVector1 = 1100;
  cmSaveVector2 = 1101;

var
  vec1, vec2: TVector;

type
  TMyApp = object(TApplication)
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
  end;

  PDotDialog = ^TDotDialog;
  TDotDialog = object(TDialog)
    output: PStaticText;

    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;


constructor TDotDialog.Init;
var
  R: TRect;
  s: string;
  dot: integer;
begin
  R.Assign(15, 5, 73, 18);
  inherited Init(R, 'Dot product');

  R.Assign(2, 3, 15, 4);
  Insert(New(PStaticText, Init(R, 'Dot product:')));

  if (vec1.Size <> vec2.Size) then begin
    s := 'dim v1 != dim v2';
  end else begin
    dot := vec1.DotProduct(@vec2);
    Str(dot, s);
  end;

  R.Assign(15, 3, 25, 5);
  output := New(PStaticText, Init(R, s));
  Insert(output);

  R.Assign(32, 10, 43, 12);
  Insert(New(PButton, Init(R, 'Close', cmExit, bfNormal)));
end;


procedure TDotDialog.HandleEvent(var Event: TEvent);
var
  s: string;
  dot: integer;
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmExit:   Close;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmShowVectorInput1: InsertWindow(New(PVectorDialog, Init(@vec1)));
      cmShowVectorInput2: InsertWindow(New(PVectorDialog, Init(@vec2)));
      cmShowDot:          InsertWindow(New(PDotDialog, Init));
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.InitMenuBar;
var R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R,NewMenu(
    NewItem('~F~irst', 'F2', kbF2, cmShowVectorInput1, hcNoContext,
    NewItem('~S~econd', 'F3', kbF3, cmShowVectorInput2, hcNoContext,
    NewItem('~D~ot', 'F4', kbF4, cmShowDot, hcNoContext,
    NewItem('~E~xit', 'Alt-X', kbAltX, cmQuit, hcNoContext,
    nil))))
  )));
end;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('~Alt-X~ End', kbAltX, cmQuit,
      NewStatusKey('~F2~ First', kbF2, cmShowVectorInput1,
      NewStatusKey('~F3~ Second', kbF3, cmShowVectorInput2,
      nil)))),
    nil)
  ));
end;

var
 App1: TMyApp;

begin
  vec1.Init(0);
  vec2.Init(0);

	App1.Init;
	App1.Run;
	App1.Done;
end.