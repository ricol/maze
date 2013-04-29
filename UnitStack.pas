unit UnitStack;

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
procedure PushStack(tmpPoint: TPoint);
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

procedure PushStack(tmpPoint: TPoint);
begin
  GStack[GPoint].x := tmpPoint.x;
  GStack[GPoint].y := tmpPoint.y;
  inc(GPoint);
end;

function PopStack(): TPoint;
var
  tmpPoint: TPoint;
begin
  dec(GPoint);
  tmpPoint.x := GStack[GPoint].x;
  tmpPoint.y := GStack[GPoint].y;
  result := tmpPoint;
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
