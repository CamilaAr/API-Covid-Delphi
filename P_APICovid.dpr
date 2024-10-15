program P_APICovid;

uses
  Vcl.Forms,
  U_APICovid in 'U_APICovid.pas' {APICovid};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAPICovid, APICovid);
  Application.Run;
end.
