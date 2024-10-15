# API Covid Delphi
 API de dados sobre Covid criada em DELPHI


Este projeto é um aplicativo Delphi que consome uma API para obter dados sobre COVID-19 por país. Ele permite visualizar informações sobre casos confirmados, mortes e recuperações.

## Dependências

Antes de executar o projeto, certifique-se de ter as seguintes dependências instaladas:

- **Embarcadero Delphi** (versão 10.3 ou superior)
- **Componentes de Rede**: Certifique-se de que os componentes `TNetHTTPClient`, `TClientDataSet`, `TDataSource` e `TDBGrid` estejam disponíveis no seu ambiente Delphi.

## Instalação

1. **Clone o repositório:**

   ```bash
   git clone <https://github.com/CamilaAr/API-Covid-Delphi.git>


2. Abra o projeto no Delphi:

Abra o Delphi e selecione File -> Open Project.
Navegue até a pasta do projeto e abra o arquivo .dpr.


3. Compilar o projeto:

Após abrir o projeto, clique em Project -> Build All Projects para compilar todos os arquivos necessários.


## Uso
1. Inicie o aplicativo:

Execute o aplicativo no Delphi clicando em Run -> Run ou pressionando F9.


2. Visualização dos dados:

O aplicativo se conectará automaticamente à API e exibirá os dados sobre COVID-19 em uma grade.


3. Filtragem de dados:

Utilize o campo de entrada "Nome do País" para filtrar os dados exibidos na grade. Ao digitar, a lista será atualizada automaticamente.


3. Ordenação de dados:

Utilize as opções de ordenação (por casos confirmados, mortes ou recuperações) para reordenar a lista exibida.

## Tratamento de Erros
O aplicativo possui tratamento básico de erros para comunicação com a API, incluindo:

1. Erros de conexão.
2. Respostas inválidas da API.
3. Formato inválido do JSON retornado.
Caso ocorra algum erro, uma mensagem será exibida informando sobre o problema.
