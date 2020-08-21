unit UnitMaze;

interface

uses
  Windows;

type
  TSquare = (BLANK, WALL);

  TMaze = array of array of TSquare;

  TPriority = (PriorityUp, PriorityRight, PriorityDown, PriorityLeft, PriorityUpOther, PriorityRightOther, PriorityDownOther, PriorityLeftOther);

var
  X: integer = 20;
  Y: integer = 10;
  Maze: TMaze;
  flag: boolean = false;
  MazePath: array of TPoint;
  bPathFound: boolean = false;
  Priority: TPriority;

const
  R = 20;
  MulX = 20;
  MulY = 20;
  ADDX = 0;
  ADDY = 0;
  LEN =10000;

procedure InitMaze();
procedure FreeMaze();
procedure InitMazeData();
procedure SetMazeData(i, j: integer; square: TSquare);
function GetMazeData(i, j: integer): TSquare;
function XtoI(X: integer): integer;
function YtoJ(Y: integer): integer;
function ItoX(I: integer): integer;
function JtoY(J: integer): integer;
procedure SearchPath();
function HasNextPos(pos: TPoint): boolean;
function IsIllegal(pos: TPoint): boolean;
procedure InitMazePath();
procedure DestroyMazePath();

implementation

uses UnitStack;

var
  GPath: array[0..LEN] of TPoint;
  GLen: integer = 0;

procedure InitMazePath();
var
  i: integer;
begin
  SetLength(MazePath, LEN);
  for i := Low(MazePath) to High(MazePath) do
  begin
    MazePath[i].x := -1;
    MazePath[i].y := -1;
  end;
end;

procedure DestroyMazePath();
begin
  SetLength(MazePath, 0);
end;

procedure InitGPath();
var
  i: integer;
begin
  for i := Low(GPath) to High(GPath) do
  begin
    GPath[i].X := 0;
    GPath[i].Y := 0;
    GLen := 0;
  end;
end;

function HaveSearchedInGPath(p: TPoint): boolean;
var
  i: integer;
begin
  result := false;
  for i := Low(GPath) to GLen do
  begin
    if (GPath[i].X = p.X) and (GPath[i].Y = p.Y) then
    begin
      result := true;
      break;
    end;
  end;
end;

function GPathIsFull(): boolean;
begin
  result := false;
  if GLen > High(GPath) then
    result := true;
end;

function GPathIsEmpty(): boolean;
begin
  result := false;
  if GLen = Low(GPath) then
    result := true;
end;

procedure PutPointInGPath(p: TPoint);
begin
  GPath[GLen].X := p.X;
  GPath[GLen].Y := p.Y;
  inc(GLen);
end;

procedure InitMaze();
begin
  SetLength(Maze, X, Y);
  flag := true;
end;

procedure FreeMaze();
begin
  SetLength(Maze, 0, 0);
  flag := false;
end;

procedure InitMazeData();
var
  i, j: integer;
begin
  randomize;
  for I := 0 to X - 1 do
    for j := 0 to Y - 1 do
    begin
      if random(10) <= 2 then
        Maze[i, j] := WALL
      else
        Maze[i, j] := BLANK;
    end;
  for i := 0 to X - 1 do
  begin
    Maze[i, 0] := WALL;
    Maze[i, Y - 1] := WALL;
  end;
  for j := 0 to Y - 1 do
  begin
    Maze[X - 1, j] := WALL;
    Maze[0, j] := WALL;
  end;
  Maze[1, 1] := BLANK;
  Maze[X - 2, Y - 2] := BLANK;
end;

procedure SetMazeData(i, j: integer; square: TSquare);
begin
  Maze[i, j] := square;
end;

function GetMazeData(i, j: integer): TSquare;
begin
  result := Maze[i, j];
end;

function XtoI(X: integer): integer;
begin
  result := (X - ADDX) div MulX;
end;

function YtoJ(Y: integer): integer;
begin
  result := (Y - ADDY) div MulY;
end;

function ItoX(I: integer): integer;
begin
  result := I * MulX + ADDX;
end;

function JToY(J: integer): integer;
begin
  result := J * MulY + ADDY;
end;

function HasNextPos(pos: TPoint): boolean;
var
  down, right, up, left: TPoint;
begin
  result := false;
  down.X := pos.X;
  down.Y := pos.Y + 1;
  right.X := pos.X + 1;
  right.Y := pos.Y;
  up.X := pos.X;
  up.Y := pos.Y - 1;
  left.X := pos.X - 1;
  left.Y := pos.Y;
  if Priority = PriorityUP then
  begin
    if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityRIGHT then
  begin
    if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityDOWN then
  begin
    if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityLEFT then
  begin
    if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityUpOther then
  begin
    if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityRightOther then
  begin
    if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityDownOther then
  begin
    if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityLeftOther then
  begin
    if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := true
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := true
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := true
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := true;
  end;
end;

function IsIllegal(pos: TPoint): boolean;
begin
  result := true;
  if (pos.X <= 0) or (pos.X >= X - 1) or (pos.Y <= 0) or (pos.Y >= Y - 1) then
    result := false;
end;

function GetNextPos(pos: TPoint): TPoint;
var
  down, right, up, left: TPoint;
begin
  down.X := pos.X;
  down.Y := pos.Y + 1;
  right.X := pos.X + 1;
  right.Y := pos.Y;
  up.X := pos.X;
  up.Y := pos.Y - 1;
  left.X := pos.X - 1;
  left.Y := pos.Y;
  if Priority = PriorityUP then
  begin
    if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right;
  end
  else if Priority = PriorityRIGHT then
  begin
    if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down;
  end
  else if Priority = PriorityDOWN then
  begin
    if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left;
  end
  else if Priority = PriorityLEFT then
  begin
    if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up;
  end
  else if Priority = PriorityUpOther then
  begin
    if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left;
  end
  else if Priority = PriorityRightOther then
  begin
    if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up;
  end
  else if Priority = PriorityDownOther then
  begin
    if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down
    else if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right;
  end
  else if Priority = PriorityLeftOther then
  begin
    if IsIllegal(left) and (not HaveSearchedInGPath(left)) and (GetMazeData(left.X, left.Y) = BLANK) then
      result := left
    else if IsIllegal(up) and (not HaveSearchedInGPath(up)) and (GetMazeData(up.X, up.Y) = BLANK) then
      result := up
    else if IsIllegal(right) and (not HaveSearchedInGPath(right)) and (GetMazeData(right.X, right.Y) = BLANK) then
      result := right
    else if IsIllegal(down) and (not HaveSearchedInGPath(down)) and (GetMazeData(down.X, down.Y) = BLANK) then
      result := down;
  end;
end;

procedure SearchPath();
var
  i: integer;
  pos, StartPos, EndPos: TPoint;
begin
  InitGPath();
  InitStack();
  bPathFound := false;
  StartPos.X := 1;
  StartPos.Y := 1;
  EndPos.X := X - 2;
  EndPos.Y := Y - 2;
  pos.x := StartPos.X;
  pos.y := StartPos.Y;
  repeat
    if not GPathIsFull() and (not HaveSearchedInGPath(pos)) then
      PushStack(pos);
    if not GPathIsFull() and (not HaveSearchedInGPath(pos)) then
      PutPointInGPath(pos);
    if (pos.X = EndPos.X) and (pos.Y = EndPos.Y) then
    begin
      i := Low(MazePath);
      while not StackIsEmpty() do
      begin
        pos := PopStack();
        MazePath[i] := pos;
        inc(i);
      end;
      bPathFound := true;
      exit;
    end;
    while not HasNextPos(pos) do
    begin
      if StackIsEmpty() then
        exit;
      pos := PopStack();
    end;
    PushStack(pos);
    pos := GetNextPos(pos);
  until false;
  DestroyStack();
end;

end.
