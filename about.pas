unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Lappdesc: TLabel;
    procedure Label2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation
uses LCLIntf;
{$R *.lfm}

{ TForm2 }

procedure TForm2.Label2Click(Sender: TObject);
begin
  OpenURL('http://www.rinorusso.it');
end;

procedure TForm2.Label5Click(Sender: TObject);
begin
  OpenURL('http://www.fasttools.it');
end;

end.

