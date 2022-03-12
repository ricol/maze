unit Main;

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuGame: TMenuItem;
    MenuPath: TMenuItem;
    MenuHelp: TMenuItem;
    MenuGameStart: TMenuItem;
    MenuGameSeperator1: TMenuItem;
    MenuGameLow: TMenuItem;
    MenuGameMedium: TMenuItem;
    MenuGameHigh: TMenuItem;
    MenuGameSeperator2: TMenuItem;
    MenuGameExit: TMenuItem;
    MenuHelpAbout: TMenuItem;
    PaintBoxMain: TPaintBox;
    MenuGameSpecial: TMenuItem;
    MenuSearchPath: TMenuItem;
    MenuMazeRePaint: TMenuItem;
    MenuSearchUp: TMenuItem;
    MenuSearchRight: TMenuItem;
    MenuSearchDown: TMenuItem;
    MenuSearchLeft: TMenuItem;
    MenuGameDefine: TMenuItem;
    MenuSearchUpOther: TMenuItem;
    MenuSearchRightOther: TMenuItem;
    MenuSearchDownOther: TMenuItem;
    MenuSearchLeftOther: TMenuItem;
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuGameExitClick(Sender: TObject);
    procedure MenuGameStartClick(Sender: TObject);
    procedure PaintBoxMainPaint(Sender: TObject);
    procedure MenuGameLowClick(Sender: TObject);
    procedure MenuGameMediumClick(Sender: TObject);
    procedure MenuGameHighClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuGameSpecialClick(Sender: TObject);
    procedure MenuMazeRePaintClick(Sender: TObject);
    procedure MenuSearchDownClick(Sender: TObject);
    procedure MenuSearchUpClick(Sender: TObject);
    procedure MenuSearchRightClick(Sender: TObject);
    procedure MenuSearchLeftClick(Sender: TObject);
    procedure MenuGameDefineClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuSearchUpOtherClick(Sender: TObject);
    procedure MenuSearchRightOtherClick(Sender: TObject);
    procedure MenuSearchDownOtherClick(Sender: TObject);
    procedure MenuSearchLeftOtherClick(Sender: TObject);
  private
    procedure ShowOne(i, j: integer);
    procedure ShowMaze();
    procedure GameStart();
    procedure GameEnd();
    procedure StartToSearchPath();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses uMaze;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  MenuGameHighClick(Sender);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  GameEnd;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssShift in Shift then
  begin
    if Key = VK_UP then
      MenuSearchUpOtherClick(Sender);
    if Key = VK_LEFT then
      MenuSearchLeftOtherClick(Sender);
    if Key = VK_DOWN then
      MenuSearchDownOtherClick(Sender);
    if Key = VK_RIGHT then
      MenuSearchRightOtherClick(Sender);
  end
  else
  begin
    if Key = VK_ESCAPE then
      MenuGameStartClick(Sender);
    if Key = VK_UP then
      MenuSearchUpClick(Sender);
    if Key = VK_LEFT then
      MenuSearchLeftClick(Sender);
    if Key = VK_DOWN then
      MenuSearchDownClick(Sender);
    if Key = VK_RIGHT then
      MenuSearchRightClick(Sender);
    if Key = VK_NUMPAD1 then
      MenuGameLowClick(Sender);
    if Key = VK_NUMPAD2 then
      MenuGameMediumClick(Sender);
    if Key = VK_NUMPAD3 then
      MenuGameHighClick(Sender);
    if Key = VK_NUMPAD4 then
      MenuGameDefineClick(Sender);
  end;
end;

procedure TFormMain.FormPaint(Sender: TObject);
begin
  Self.Canvas.Brush.Color := clGreen;
  Self.Canvas.Pen.Color := clBlack;
  Self.Canvas.Rectangle(0, 0, Self.Width, Self.Height);
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  Self.ClientWidth := X * MulX;
  Self.ClientHeight := Y * MulY;
end;

procedure TFormMain.GameEnd;
begin
  FreeMaze();
end;

procedure TFormMain.GameStart;
begin
  InitMaze();
  InitMazeData();
  ShowMaze();
end;

procedure TFormMain.MenuGameDefineClick(Sender: TObject);
begin
  try
    X := StrToInt(InputBox('输入信息', 'X = ', '50'));
  except
    X := 50;
  end;
  try
    Y := StrToInt(InputBox('输入信息', 'Y = ', '30'));
  except
    Y := 30;
  end;
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuGameHighClick(Sender: TObject);
begin
  X := 30;
  Y := 20;
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuGameLowClick(Sender: TObject);
begin
  X := 20;
  Y := 10;
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuGameMediumClick(Sender: TObject);
begin
  X := 25;
  Y := 15;
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuGameSpecialClick(Sender: TObject);
begin
  X := 40;
  Y := 30;
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
begin
  if flag then
    GameEnd;
  GameStart;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
var
  s: string;
begin
  s := '        迷宫 - RICOL制作' + #$D + #$A;
  s := s + '  联系 - WANGXINGHE1983@GMAIL.COM';
  s := s + #$D + #$A + 'Up    - 对迷宫进行向上优先路径搜索;';
  s := s + #$D + #$A + 'Left  - 对迷宫进行向左优先路径搜索;';
  s := s + #$D + #$A + 'Down  - 对迷宫进行向下优先路径搜索;';
  s := s + #$D + #$A + 'Right - 对迷宫进行向右优先路径搜索;';
  MessageBox(Self.Handle, PChar(s), '关于', MB_OK);
end;

procedure TFormMain.MenuMazeRePaintClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
end;

procedure TFormMain.MenuSearchDownClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityDown;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchDownOtherClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityDownOther;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchLeftClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityLeft;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchLeftOtherClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityLeftOther;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchRightClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityRight;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchRightOtherClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityRightOther;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchUpClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityUp;
  StartToSearchPath();
end;

procedure TFormMain.MenuSearchUpOtherClick(Sender: TObject);
begin
  PaintBoxMainPaint(Sender);
  Priority := PriorityUpOther;
  StartToSearchPath();
end;

procedure TFormMain.PaintBoxMainPaint(Sender: TObject);
begin
  if flag then
    ShowMaze;
end;

procedure TFormMain.StartToSearchPath;
var
  i: integer;
  x, y: integer;
begin
  bPathFound := false;
  InitMazePath();
  SearchPath();
  if not bPathFound then
  begin
    MessageBox(Self.Handle, '没有发现路径!', '信息', MB_OK or MB_ICONINFORMATION);
    DestroyMazePath();
    exit;
  end;
  for i := Low(MazePath) to High(MazePath) do
  begin
    if (MazePath[i].x >= 0) and (MazePath[i].y >= 0) then
    begin
      x := MazePath[i].X;
      y := MazePath[i].Y;
      x := IToX(x);
      y := JToY(y);
      with PaintBoxMain do
      begin
        Canvas.Pen.Color := clBlack;
        Canvas.Brush.Color := clRed;
        Canvas.Rectangle(x + 2, y + 2, x + R - 2, y + R - 2);
      end;
    end;
  end;
  DestroyMazePath();
end;

procedure TFormMain.ShowMaze;
var
  i, j, m, n: integer;
begin
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
      ShowOne(i, j);
  with PaintBoxMain do
  begin
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := clGreen;
  end;
  for i := 0 to X - 1 do
  begin
    m := IToX(i);
    n := JToY(0);
    PaintBoxMain.Canvas.Rectangle(m, n, m + R, n + R);
    m := IToX(i);
    n := JToY(Y - 1);
    PaintBoxMain.Canvas.Rectangle(m, n, m + R, n + R);
  end;
  for j := 0 to Y - 1 do
  begin
    m := IToX(X - 1);
    n := JToY(j);
    PaintBoxMain.Canvas.Rectangle(m, n, m + R, n + R);
    m := IToX(0);
    n := JToY(j);
    PaintBoxMain.Canvas.Rectangle(m, n, m + R, n + R);
  end;
  FormResize(nil);
end;

procedure TFormMain.ShowOne(i, j: integer);
var
  m, n: integer;
begin
  m := IToX(i);
  n := JToY(j);
  if ((i = 1) and (j = 1)) or ((i = X - 2) and (j = Y - 2)) then
    with PaintBoxMain do
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := clBlue;
      Canvas.Rectangle(m, n, m + R, n + R);
    end
  else
    with PaintBoxMain do
    begin
      Canvas.Pen.Color := clBlack;
      if Maze[i, j] = BLANK then
        Canvas.Brush.Color := clWhite
      else if Maze[i, j] = WALL then
        Canvas.Brush.Color := clBlack;
      Canvas.Rectangle(m, n, m + R, n + R);
    end;
end;

end.
