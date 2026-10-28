# Flopes

App do brechó Flopes: garimpo pelo celular, gestão de drops, peças, vendas e caixa pelo computador.
Os dados ficam no Supabase e sincronizam entre os aparelhos. Sem internet, o app guarda tudo no aparelho e envia depois.

## Arquivos

- `index.html`: o app inteiro
- `manifest.webmanifest`, `sw.js`, `icons/`: instalação como aplicativo e funcionamento sem internet
- `supabase/schema.sql`: cria o banco, as regras de acesso, o armazenamento de fotos e os brechós iniciais

## Configuração (uma vez)

1. **Banco**: no Supabase, abra *SQL Editor → New query*, cole o conteúdo de `supabase/schema.sql` e clique em *Run*.
2. **Usuárias**: em *Authentication → Users → Add user → Create new user*, crie um usuário para cada pessoa
   (e-mail + senha) e marque *Auto Confirm User*.
3. **Fechar cadastro**: em *Authentication → Sign In / Providers*, desligue *Allow new users to sign up*.
   Assim só as contas criadas por você conseguem entrar.
4. **Publicar**: no GitHub, em *Settings → Pages*, escolha *Deploy from a branch*, branch `main`, pasta `/ (root)`.
   O endereço aparece ali em cerca de 1 minuto (algo como `https://SEU-USUARIO.github.io/flopes/`).

## Instalar

- **iPhone**: abra o endereço no Safari → Compartilhar → *Adicionar à Tela de Início*.
- **Android**: abra no Chrome → menu ⋮ → *Instalar app* (ou *Adicionar à tela inicial*).
- **Computador**: abra no Chrome ou Edge → ícone de instalar na barra de endereço.

Entre com e-mail e senha uma vez em cada aparelho. No iPhone, o app instalado tem login próprio, separado do Safari.

## Atualizar

Qualquer alteração enviada para a branch `main` é publicada sozinha pelo GitHub Pages em cerca de 1 minuto.
Os aparelhos recebem a versão nova na próxima vez que abrirem o app com internet. Os dados não são afetados.

## Backup

Em *Ajustes → Baixar backup*, o app gera um arquivo `.json` com todos os dados.
