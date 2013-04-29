program Maze;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitMaze in 'UnitMaze.pas',
  UnitStack in 'UnitStack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
