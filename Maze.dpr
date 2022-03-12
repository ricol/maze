program Maze;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Stack in 'Stack.pas',
  uMaze in 'uMaze.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
