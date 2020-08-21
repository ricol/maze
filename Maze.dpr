program Maze;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  uMain in 'uMain.pas',
  Stack in 'Stack.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
