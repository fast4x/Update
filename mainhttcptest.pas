unit mainhttcptest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, lNet,
  lHTTP, lNetComponents, ExtCtrls, StdCtrls, Buttons, Menus, lHTTPUtil,
  LSControls, IdHTTP, IdComponent, inifiles;
  
type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    ButtonSendRequest: TButton;
    EditURL: TEdit;
    GroupBox1: TGroupBox;
    HTTPClient: TLHTTPClientComponent;
    IdHTTP1: TIdHTTP;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lfastupdate: TLabel;
    Lappwebpage: TLabel;
    Lappname: TLabel;
    Lappvers: TLabel;
    LabelURI: TLabel;
    Lappdesc: TLabel;
    Lappversavail: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SSL: TLSSLSessionComponent;
    MemoHTML: TMemo;
    MemoStatus: TMemo;
    MenuPanel: TPanel;
    PanelSep: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonSendRequestClick(Sender: TObject);
    procedure EditURLKeyPress(Sender: TObject; var Key: char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure HTTPClientDisconnect(aSocket: TLSocket);
    procedure HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
    procedure HTTPClientError(const msg: string; aSocket: TLSocket);
    function HTTPClientInput(ASocket: TLHTTPClientSocket; ABuffer: pchar;
      ASize: dword): dword;
    procedure HTTPClientProcessHeaders(ASocket: TLHTTPClientSocket);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Label2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure lfastupdateClick(Sender: TObject);
    procedure LappwebpageClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure SSLSSLConnect(aSocket: TLSocket);

    function GetValueFromTag( const TagName,aText:string ):string;

  private
    HTTPBuffer: string;
    procedure AppendToMemo(aMemo: TMemo; const aText: string);
    { private declarations }
  public
    { public declarations }
  end; 

var
  MainForm: TMainForm;
  LocalAppVers:string;
  conf:tstringlist;

implementation
uses getvers, getvers_lin ,LCLIntf;

{ TMainForm }


function TMainForm.GetValueFromTag( const TagName,aText:string ):string;
var tagopen,tagclose:string;
    pos_tagopen, pos_tagclose, pos_value_start, pos_value_end :word;
begin
  tagopen:='<'+TagName+'>';
  tagclose:='</'+TagName+'>';

  pos_tagopen:=pos(tagopen,aText);
  pos_tagclose:=pos(tagclose,aText);

  pos_value_start := pos_tagopen+length(tagopen);
  pos_value_end := pos_tagclose;
  result := copy(aText,pos_value_start,pos_value_end-pos_value_start);

//  result:=inttostr(pos_tagopen)+' '+inttostr(pos_tagclose);


end;

procedure TMainForm.HTTPClientError(const msg: string; aSocket: TLSocket);
begin
  MessageDlg(msg, mtError, [mbOK], 0);
end;

procedure TMainForm.HTTPClientDisconnect(aSocket: TLSocket);
begin
  AppendToMemo(MemoStatus, 'Disconnected.');
end;

procedure TMainForm.ButtonSendRequestClick(Sender: TObject);
var
  aHost, aURI, LocalAppVers, RemoteAppVers: string;
  aPort: Word;
//  qlocalappvers, qremoteappvers: TVersionQuad;
begin

  conf:=tstringlist.Create;
  conf.LoadFromFile(extractfilepath(application.exename)+'fastUpdateConfig.xml');

  if fileexists(extractfilepath(application.ExeName)+GetValueFromTag('AppIcon',conf.Text)) then
    image1.Picture.LoadFromFile(extractfilepath(application.ExeName)+GetValueFromTag('AppIcon',conf.Text));

  LocalAppVers:=GetValueFromTag('AppVersLocal',conf.Text);
  lappname.Caption:=GetValueFromTag('AppName',conf.Text);
  lappdesc.Caption:=GetValueFromTag('AppDesc',conf.Text);
  lappvers.Caption:='Versione in uso: '+localappvers;
  label7.Caption:=GetValueFromTag('CompanyName',conf.Text);
  label8.Caption:=GetValueFromTag('CompanyWebsite',conf.Text);

  caption:=lappname.Caption+' - fastUpdate';

  (*
  HTTPBuffer := '';
  SSL.SSLActive := DecomposeURL(EditURL.Text, aHost, aURI, aPort);
  HTTPClient.Host := aHost;
  HTTPClient.URI  := aURI;
  HTTPClient.Port := aPort;
  HTTPClient.SendRequest;
  *)
 // useragent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0

  idhttp1.Head(GetValueFromTag('AppUrlChk',conf.Text));
  memohtml.Lines.Text:=idhttp1.Get(GetValueFromTag('AppUrlChk',conf.Text));


 RemoteAppVers:= GetValueFromTag('AppVersAvailable',memohtml.Lines.Text);
 lappversavail.Caption:='Nuova versione: '+RemoteAppVers;

 lappwebpage.Caption:='Visita '+GetValueFromTag('AppWebPage',memohtml.Lines.Text);


//  showmessage('R: '+RemoteAppVers+' L: '+LocalAppVers);

  if NewerVersion(RemoteAppVers,LocalAppVers) then begin
//  showmessage('Nuova versione');
  show;
  end else application.Terminate;

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin

end;

procedure TMainForm.EditURLKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    ButtonSendRequestClick(Sender);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    //canclose:=false;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var xc:string;

begin
  height:=panel1.Height+20;

  ButtonSendRequestClick(Sender);


  xc:=paramstr(0);
//  showmessage(xc);
 //xc:='../PomoManager/PomoManager.exe';
//  lfastupdate.caption:='fastUpdate ('+GetVersion(xc)+')';
lfastupdate.caption:='fastUpdate ';
end;

procedure TMainForm.HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
var ini:tinifile;
begin
  aSocket.Disconnect;
  AppendToMemo(MemoStatus, 'Finished.');
  memohtml.Lines.SaveToFile('./temp.upd');

  Try
    ini:=TiniFile.Create('./temp.upd');
    AppendToMemo(MemoStatus, 'Get due prop: '+ini.ReadString('test','due',''));
  Finally
    ini.Free;
  end;
end;

function TMainForm.HTTPClientInput(ASocket: TLHTTPClientSocket; ABuffer: pchar;
  ASize: dword): dword;
var
  oldLength: dword;
begin
  oldLength := Length(HTTPBuffer);
  setlength(HTTPBuffer,oldLength + ASize);
  move(ABuffer^,HTTPBuffer[oldLength + 1], ASize);
  MemoHTML.Text := HTTPBuffer;
  MemoHTML.SelStart := Length(HTTPBuffer);
  AppendToMemo(MemoStatus, IntToStr(ASize) + '...');
  Result := aSize; // tell the http buffer we read it all
end;

procedure TMainForm.HTTPClientProcessHeaders(ASocket: TLHTTPClientSocket);
begin
  AppendToMemo(MemoStatus, 'Response: ' + IntToStr(HTTPStatusCodes[ASocket.ResponseStatus]) +
                    ' ' + ASocket.ResponseReason + ', data...');
end;

procedure TMainForm.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
//var ini:tinifile;
//    tmpfile:string;
begin
//  tmpfile:=extractfilepath(application.exename)+'temp.upd';
  AppendToMemo(MemoStatus,'ultima risposta: '+inttostr(idhttp1.ResponseCode));
(*
  memohtml.Lines.SaveToFile(tmpfile);
  Try
    ini:=TiniFile.Create(tmpfile);
    AppendToMemo(MemoStatus, 'Get due prop: '+ini.ReadString('test','due',''));
  Finally
    ini.Free;
  end;
  *)
//  tmpfile:=memohtml.Lines.Text;


end;

procedure TMainForm.Label2Click(Sender: TObject);
begin
  OpenURL('http://www.rinorusso.it');
end;

procedure TMainForm.Label5Click(Sender: TObject);
begin
     OpenURL('http://www.fasttools.it');
end;

procedure TMainForm.Label8Click(Sender: TObject);
begin
  OpenURL(label8.Caption);
end;

procedure TMainForm.lfastupdateClick(Sender: TObject);
begin
    OpenURL('http://www.fasttools.it/fast-update');
end;

procedure TMainForm.LappwebpageClick(Sender: TObject);
begin
   //showmessage(GetValueFromTag('AppWebPage',memohtml.Lines.Text));
   OpenURL(GetValueFromTag('AppWebPage',memohtml.Lines.Text));
end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin

end;

procedure TMainForm.MenuItemAboutClick(Sender: TObject);
begin
  MessageDlg('Copyright (c) 2006-2008 by Ales Katona and Micha Nelissen. All rights deserved :)',
             mtInformation, [mbOK], 0);
end;

procedure TMainForm.MenuItemExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SSLSSLConnect(aSocket: TLSocket);
begin
  MemoStatus.Append('TLS handshake successful');
end;

procedure TMainForm.AppendToMemo(aMemo: TMemo; const aText: string);
begin
  aMemo.Append(aText);
  aMemo.SelStart := Length(aMemo.Text);
end;

initialization
  {$I mainhttcptest.lrs}

end.
