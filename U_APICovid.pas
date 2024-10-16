unit U_APICovid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Datasnap.DBClient,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, System.JSON, Vcl.StdCtrls;

type
  TAPICovid = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    gridAPI: TDBGrid;
    cdsAPI: TClientDataSet;
    httpClientAPI: TNetHTTPClient;
    dsAPI: TDataSource;
    Label1: TLabel;
    edtPais: TEdit;
    rgOrdem: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    procedure FetchCovidData;
    procedure ProcessApiResponse(const JsonResponse: string);
    procedure FilterData(Sender: TObject);
    procedure SortData(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  APICovid: TAPICovid;

implementation

{$R *.dfm}

procedure TAPICovid.FormCreate(Sender: TObject);
begin
  // Configura o ClientDataSet com os campos esperados
  cdsAPI.FieldDefs.Add('Country', ftString, 100);
  cdsAPI.FieldDefs.Add('Confirmed', ftInteger);
  cdsAPI.FieldDefs.Add('Deaths', ftInteger);
  cdsAPI.FieldDefs.Add('Recovered', ftInteger);
  cdsAPI.CreateDataSet;

  // Conectar o DataSource ao ClientDataSet
  dsAPI.DataSet := cdsAPI;

  // Conectar o grid ao DataSource
  gridAPI.DataSource := dsAPI;

  // Configurar eventos de filtro e ordena��o
  edtPais.OnChange := FilterData;
  rgOrdem.OnClick := SortData;

  // Carregar os dados da API ao iniciar
  FetchCovidData;
end;

// Filtra pelos pa�ses descritos
procedure TAPICovid.FilterData(Sender: TObject);
begin
  if edtPais.Text <> '' then
    cdsAPI.Filter := 'Country LIKE ' + QuotedStr('%' + edtPais.Text + '%')
  else
    cdsAPI.Filter := '';  // Limpa o filtro quando o campo de busca est� vazio

  cdsAPI.Filtered := edtPais.Text <> '';  // Ativa o filtro se h� texto no campo
end;


//Ordena pelas op��es disponiveis
 procedure TAPICovid.SortData(Sender: TObject);
begin
  case rgOrdem.ItemIndex of
    0: cdsAPI.IndexFieldNames := 'Confirmed';  // Ordenar por casos confirmados
    1: cdsAPI.IndexFieldNames := 'Deaths';     // Ordenar por mortes
    2: cdsAPI.IndexFieldNames := 'Recovered';  // Ordenar por recuperados
  else
    cdsAPI.IndexFieldNames := '';  // Nenhuma ordena��o
  end;
end;



// Pega os dados da API
procedure TAPICovid.FetchCovidData;
var
  HttpResponse: IHTTPResponse;
  JsonResponse: string;
begin
  try
    // Faz a requisi��o GET para a API
    HttpResponse := httpClientAPI.Get('https://covid19-brazil-api.vercel.app/api/report/v1/countries');

    // Verifica se a requisi��o foi bem-sucedida
    if HttpResponse.StatusCode = 200 then
    begin
      JsonResponse := HttpResponse.ContentAsString();

      // Verificar se a resposta � v�lida (n�o nula e em formato JSON)
      if JsonResponse.Trim.IsEmpty then
      begin
        ShowMessage('A resposta da API est� vazia.');
        Exit;
      end;

      // Processar os dados da API
      try
        ProcessApiResponse(JsonResponse);
      except
        on E: Exception do
          ShowMessage('Erro ao processar os dados da API: ' + E.Message);
      end;
    end
    else
    begin
      // Tratar c�digos de status que indicam erro
      ShowMessage('Erro ao acessar a API. C�digo: ' + HttpResponse.StatusCode.ToString);
    end;
  except
    on E: ENetHTTPClientException do
      ShowMessage('Falha na comunica��o com a API: ' + E.Message);
    on E: Exception do
      ShowMessage('Erro inesperado: ' + E.Message);
  end;
end;

// Processa o JSON retornado
procedure TAPICovid.ProcessApiResponse(const JsonResponse: string);
var
  JsonData: TJSONObject;
  CountriesArray: TJSONArray;
  CountryData: TJSONObject;
  i: Integer;
  Value: TJSONValue;
begin
  // Inicializa o JsonData como nil
  JsonData := nil;

  // Tentar fazer o parse do JSON, capturando erros
  try
    JsonData := TJSONObject.ParseJSONValue(JsonResponse) as TJSONObject;

    // Verificar se o JSON foi parseado corretamente
    if not Assigned(JsonData) then
    begin
      ShowMessage('Erro ao parsear o JSON. Formato inv�lido.');
      Exit;
    end;

    // Verificar se o campo "data" existe e � um array
    CountriesArray := JsonData.GetValue('data') as TJSONArray;
    if not Assigned(CountriesArray) then
    begin
      ShowMessage('Formato de dados inv�lido. Campo "data" n�o encontrado.');
      Exit;
    end;

    // Limpar o ClientDataSet antes de popular
    cdsAPI.EmptyDataSet;

    // Iterar pelos dados de cada pa�s
    for i := 0 to CountriesArray.Count - 1 do
    begin
      CountryData := CountriesArray.Items[i] as TJSONObject;

      // Adicionar dados ao ClientDataSet
      cdsAPI.Append;

      // Atribuir o valor do pa�s
      cdsAPI.FieldByName('Country').AsString := CountryData.GetValue<string>('country');

      // Verificar e atribuir o campo 'confirmed'
      Value := CountryData.GetValue('confirmed');
      if Assigned(Value) and not Value.Null then
        cdsAPI.FieldByName('Confirmed').AsInteger := (Value as TJSONNumber).AsInt
      else
        cdsAPI.FieldByName('Confirmed').AsInteger := 0;

      // Verificar e atribuir o campo 'deaths'
      Value := CountryData.GetValue('deaths');
      if Assigned(Value) and not Value.Null then
        cdsAPI.FieldByName('Deaths').AsInteger := (Value as TJSONNumber).AsInt
      else
        cdsAPI.FieldByName('Deaths').AsInteger := 0;

      // Verificar e atribuir o campo 'recovered'
      Value := CountryData.GetValue('recovered');
      if Assigned(Value) and not Value.Null then
        cdsAPI.FieldByName('Recovered').AsInteger := (Value as TJSONNumber).AsInt
      else
        cdsAPI.FieldByName('Recovered').AsInteger := 0;

      cdsAPI.Post;
    end;

  except
    on E: Exception do
      ShowMessage('Erro ao processar os dados da API: ' + E.Message);
  end;
  // Certifique-se de liberar o JsonData se ele foi criado
  if Assigned(JsonData) then
      JsonData.Free;
end;





end.
