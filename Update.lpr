program Update;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pl_lnetcomp, pl_indycomp
  { add your units here }, mainhttcptest, getvers, getvers_simple_win;

{$R *.res}

begin
  Application.Title:='fastUpdate';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.showmainform:=false;
  Application.Run;
end.

