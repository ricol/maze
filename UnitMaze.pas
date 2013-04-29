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
procedure SetMazeData(i, j: integer; tmpSquare: TSquare);
function GetMazeData(i, j: integer): TSquare;
function XtoI(X: integer): integer;
function YtoJ(Y: integer): integer;
function ItoX(I: integer): integer;
function JtoY(J: integer): integer;
procedure SearchPath();
function HasNextPos(tmpPos: TPoint): boolean;
function IsIllegal(tmpPos: TPoint): boolean;
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

function HaveSearchedInGPath(tmpPoint: TPoint): boolean;
var
  i: integer;
begin
  result := false;
  for i := Low(GPath) to GLen do
  begin
    if (GPath[i].X = tmpPoint.X) and (GPath[i].Y = tmpPoint.Y) then
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

procedure PutPointInGPath(tmpPoint: TPoint);
begin
  GPath[GLen].X := tmpPoint.X;
  GPath[GLen].Y := tmpPoint.Y;
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

procedure SetMazeData(i, j: integer; tmpSquare: TSquare);
begin
  Maze[i, j] := tmpSquare;
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

function HasNextPos(tmpPos: TPoint): boolean;
var
  tmpDown, tmpRight, tmpUp, tmpLeft: TPoint;
begin
  result := false;
  tmpDown.X := tmpPos.X;
  tmpDown.Y := tmpPos.Y + 1;
  tmpRight.X := tmpPos.X + 1;
  tmpRight.Y := tmpPos.Y;
  tmpUp.X := tmpPos.X;
  tmpUp.Y := tmpPos.Y - 1;
  tmpLeft.X := tmpPos.X - 1;
  tmpLeft.Y := tmpPos.Y;
  if Priority = PriorityUP then
  begin
    if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityRIGHT then
  begin
    if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityDOWN then
  begin
    if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityLEFT then
  begin
    if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityUpOther then
  begin
    if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityRightOther then
  begin
    if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityDownOther then
  begin
    if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true;
  end
  else if Priority = PriorityLeftOther then
  begin
    if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := true
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := true;
  end;
end;

function IsIllegal(tmpPos: TPoint): boolean;
begin
  result := true;
  if (tmpPos.X <= 0) or (tmpPos.X >= X - 1) or (tmpPos.Y <= 0) or (tmpPos.Y >= Y - 1) then
    result := false;
end;

function GetNextPos(tmpPos: TPoint): TPoint;
var
  tmpDown, tmpRight, tmpUp, tmpLeft: TPoint;
begin
  tmpDown.X := tmpPos.X;
  tmpDown.Y := tmpPos.Y + 1;
  tmpRight.X := tmpPos.X + 1;
  tmpRight.Y := tmpPos.Y;
  tmpUp.X := tmpPos.X;
  tmpUp.Y := tmpPos.Y - 1;
  tmpLeft.X := tmpPos.X - 1;
  tmpLeft.Y := tmpPos.Y;
  if Priority = PriorityUP then
  begin
    if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight;
  end
  else if Priority = PriorityRIGHT then
  begin
    if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown;
  end
  else if Priority = PriorityDOWN then
  begin
    if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft;
  end
  else if Priority = PriorityLEFT then
  begin
    if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp;
  end
  else if Priority = PriorityUpOther then
  begin
    if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft;
  end
  else if Priority = PriorityRightOther then
  begin
    if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp;
  end
  else if Priority = PriorityDownOther then
  begin
    if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown
    else if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight;
  end
  else if Priority = PriorityLeftOther then
  begin
    if IsIllegal(tmpLeft) and (not HaveSearchedInGPath(tmpLeft)) and (GetMazeData(tmpLeft.X, tmpLeft.Y) = BLANK) then
      result := tmpLeft
    else if IsIllegal(tmpUp) and (not HaveSearchedInGPath(tmpUp)) and (GetMazeData(tmpUp.X, tmpUp.Y) = BLANK) then
      result := tmpUp
    else if IsIllegal(tmpRight) and (not HaveSearchedInGPath(tmpRight)) and (GetMazeData(tmpRight.X, tmpRight.Y) = BLANK) then
      result := tmpRight
    else if IsIllegal(tmpDown) and (not HaveSearchedInGPath(tmpDown)) and (GetMazeData(tmpDown.X, tmpDown.Y) = BLANK) then
      result := tmpDown;
  end;
end;

procedure SearchPath();
var
  i: integer;
  tmpPos, StartPos, EndPos: TPoint;
begin
  InitGPath();
  InitStack();
  bPathFound := false;
  StartPos.X := 1;
  StartPos.Y := 1;
  EndPos.X := X - 2;
  EndPos.Y := Y - 2;
  tmpPos.x := StartPos.X;
  tmpPos.y := StartPos.Y;
  repeat
    if not GPathIsFull() and (not HaveSearchedInGPath(tmpPos)) then
      PushStack(tmpPos);
    if not GPathIsFull() and (not HaveSearchedInGPath(tmpPos)) then
      PutPointInGPath(tmpPos);
    if (tmpPos.X = EndPos.X) and (tmpPos.Y = EndPos.Y) then
    begin
      i := Low(MazePath);
      while not StackIsEmpty() do
      begin
        tmpPos := PopStack();
        MazePath[i] := tmpPos;
        inc(i);
      end;
      bPathFound := true;
      exit;
    end;
    while not HasNextPos(tmpPos) do
    begin
      if StackIsEmpty() then
        exit;
      tmpPos := PopStack();
    end;
    PushStack(tmpPos);
    tmpPos := GetNextPos(tmpPos);
  until false;
  DestroyStack();
end;

end.
