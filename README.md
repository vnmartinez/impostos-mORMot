# impostos-mORMot

## Estrutura

O repositorio deve manter a pasta `mORMot` na raiz do projeto:

- `mORMot/` (na raiz)
- `src/`

O codigo em `src` esta organizado em 3 pastas principais:

1. `src/servidor`: projeto do servidor (`ProjetoServidor.dpr`).
2. `src/client`: projeto do cliente VCL (`ProjetoClient.dpr`).
3. `src/comum`: units compartilhadas entre cliente e servidor.

## Execucao

1. Compile e execute primeiro `src/servidor/ProjetoServidor.dpr` para subir o servidor HTTP em `127.0.0.1:8888`.
2. Depois compile e execute `src/client/ProjetoClient.dpr`.
