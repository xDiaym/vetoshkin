program Course;

uses
  Vector, Objects;

var
  Vec1, Vec2, Vec3: PVector;
  Dot: Integer;
const
  v1: Vec = (1, 2, 3);
  v2: Vec = (3, 2, 1);
begin

  Vec1 := New(PVector, Init(3, v1));
  Vec2 := New(PVector, Init(3, v2));

  WriteLn('Vec1:');
  Vec1^.Print;
  
  WriteLn('Vec2:');
  Vec2^.Print;

  Dot := Vec1^.DotProduct(Vec2);
  WriteLn('Vec1 . Vec2 = ', Dot);
  ReadLn;
  Dispose(Vec1, Done);
  Dispose(Vec2, Done);
end.
