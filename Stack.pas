unit Stack;

interface

uses
  Windows;

const
  STACKMAXSIZE = 10000;

var
  GStack: array of TPoint;
  GPoint: integer = 0;

procedure InitStack();
procedure DestroyStack();
procedure PushStack(p: TPoint);
function PopStack(): TPoint;
function StackIsFull(): boolean;
function StackIsEmpty(): boolean;

implementation

procedure InitStack();
begin
  SetLength(GStack, STACKMAXSIZE);
  GPoint := 0;
end;

procedure DestroyStack();
begin
  SetLength(GStack, 0);
  GPoint := 0;
end;

procedure PushStack(p: TPoint);
begin
  GStack[GPoint].x := p.x;
  GStack[GPoint].y := p.y;
  inc(GPoint);
end;

function PopStack(): TPoint;
var
  p: TPoint;
begin
  dec(GPoint);
  p.x := GStack[GPoint].x;
  p.y := GStack[GPoint].y;
  result := p;
end;

function StackIsFull(): boolean;
begin
  result := false;
  if GPoint > High(GStack) then
    result := true;
end;

function StackIsEmpty(): boolean;
begin
  result := false;
  if GPoint < Low(GStack) then
    result := true;
end;

end.
