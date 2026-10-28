-- =============================================================
-- Flopes · configuração do banco no Supabase
-- Como usar: Supabase → SQL Editor → New query → cole tudo → Run.
-- Pode rodar mais de uma vez sem problema.
-- =============================================================

-- 1) Tabela única com todos os registros do app
--    col = tipo (brechos, garimpos, drops, pecas, config) · id = identificador · data = conteúdo
create table if not exists public.registros (
  col        text        not null,
  id         text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);

-- 2) Segurança: só quem fez login (você e sua namorada) lê e grava
alter table public.registros enable row level security;
drop policy if exists "equipe lê"     on public.registros;
drop policy if exists "equipe cria"   on public.registros;
drop policy if exists "equipe altera" on public.registros;
drop policy if exists "equipe apaga"  on public.registros;
create policy "equipe lê"     on public.registros for select to authenticated using (true);
create policy "equipe cria"   on public.registros for insert to authenticated with check (true);
create policy "equipe altera" on public.registros for update to authenticated using (true) with check (true);
create policy "equipe apaga"  on public.registros for delete to authenticated using (true);

-- 3) Tempo real: o que um aparelho salva aparece no outro na hora
do $$ begin
  alter publication supabase_realtime add table public.registros;
exception when duplicate_object then null; end $$;

-- 4) Fotos das peças
insert into storage.buckets (id, name, public)
values ('fotos', 'fotos', true)
on conflict (id) do nothing;
drop policy if exists "equipe envia fotos" on storage.objects;
drop policy if exists "equipe apaga fotos" on storage.objects;
create policy "equipe envia fotos" on storage.objects for insert to authenticated with check (bucket_id = 'fotos');
create policy "equipe apaga fotos" on storage.objects for delete to authenticated using (bucket_id = 'fotos');

-- 5) Brechós de Brasília já cadastrados (vindos da versão no Claude)
insert into public.registros (col, id, data) values
  ('brechos', 'desapeguei-bonito', '{"id": "desapeguei-bonito", "nome": "Desapeguei Bonito", "regiao": "Asa Norte", "endereco": "SCRN 702/703, Bloco C, loja 50", "insta": "@desapegueibonito", "horario": "", "faixa": "medio", "notas": "Curadoria para público descolado. Estante colaborativa com estilistas locais.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'bem-qt-quis', '{"id": "bem-qt-quis", "nome": "Bem QT Quis", "regiao": "Asa Norte", "endereco": "SCRN 714/715, Bloco G, loja 30", "insta": "@bemqtquis", "horario": "", "faixa": "medio", "notas": "Slow fashion, curadoria variada. Guias antigos citam CLN 216 e Liberty Mall.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'b-ao-quadrado', '{"id": "b-ao-quadrado", "nome": "B ao Quadrado", "regiao": "Asa Sul", "endereco": "CLS 412, Bloco D, loja 19", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'balaio-brecho', '{"id": "balaio-brecho", "nome": "Balaio Brechó", "regiao": "Asa Sul", "endereco": "CLS 207, Bloco A, loja 33", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'bombau-brecho', '{"id": "bombau-brecho", "nome": "Bombaú Brechó", "regiao": "Núcleo Bandeirante", "endereco": "3ª Avenida, Área Especial 13, Lote N/O, loja 02", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'burguesinha', '{"id": "burguesinha", "nome": "Burguesinha Brechó Chic", "regiao": "Asa Sul", "endereco": "Comércio Local Sul (quadra a confirmar)", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'peca-rara-307s', '{"id": "peca-rara-307s", "nome": "Peça Rara · 307 Sul", "regiao": "Asa Sul", "endereco": "CLS 307, Bloco C, loja 03", "insta": "@pecarara_brasilia", "horario": "", "faixa": "medio", "notas": "Rede de brechós. Roupas de marca em ótimo estado.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'peca-rara-408s', '{"id": "peca-rara-408s", "nome": "Peça Rara · 408 Sul", "regiao": "Asa Sul", "endereco": "CLS 408, Bloco C, loja 29", "insta": "@pecarara_brasilia", "horario": "", "faixa": "medio", "notas": "Rede de brechós. Um guia cita também o Bloco D, loja 15.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'peca-rara-204n', '{"id": "peca-rara-204n", "nome": "Peça Rara · 204 Norte", "regiao": "Asa Norte", "endereco": "CLN 204 (bloco a confirmar)", "insta": "@pecarara_brasilia", "horario": "", "faixa": "medio", "notas": "Rede de brechós. Outro guia cita unidade na CLN 106.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'peca-rara-aguas-claras', '{"id": "peca-rara-aguas-claras", "nome": "Peça Rara · Águas Claras", "regiao": "Águas Claras", "endereco": "Endereço a confirmar", "insta": "@pecarara_brasilia", "horario": "", "faixa": "medio", "notas": "Rede de brechós.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'peca-rara-guara', '{"id": "peca-rara-guara", "nome": "Peça Rara · Guará", "regiao": "Guará", "endereco": "Endereço a confirmar", "insta": "@pecarara_brasilia", "horario": "", "faixa": "medio", "notas": "Rede de brechós.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'nosso-armario', '{"id": "nosso-armario", "nome": "Nosso Armário – Brechó de Estilo", "regiao": "Asa Norte", "endereco": "CLN 213, Bloco B, sala 114", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'retrato-brecho', '{"id": "retrato-brecho", "nome": "Retrato Brechó", "regiao": "Asa Sul", "endereco": "CRS 515, Bloco B (entrada pela W3 Sul)", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'choose-vintage', '{"id": "choose-vintage", "nome": "Choose Vintage", "regiao": "Sudoeste", "endereco": "Comércio da SQSW 101 (bloco a confirmar)", "insta": "@choosevintageoficial", "horario": "", "faixa": "caro", "notas": "Vintage e peças de luxo.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'zoe-brasil', '{"id": "zoe-brasil", "nome": "Brechó Zoe Brasil", "regiao": "Asa Norte", "endereco": "CLN 314, Bloco D, galeria subsolo, loja 61", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'acervo-chic', '{"id": "acervo-chic", "nome": "Acervo Chic Brechó", "regiao": "Asa Sul", "endereco": "CLS 405, Bloco A, loja 48", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'ana-zago', '{"id": "ana-zago", "nome": "Ana Zago Boutique Brechó", "regiao": "Asa Sul", "endereco": "CLS 310, Bloco C, sobreloja 18", "insta": "@anazagoboutiquebrecho", "horario": "", "faixa": "caro", "notas": "Brechó de luxo. Outra matéria cita 308 Sul.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'brecho-do-oculos', '{"id": "brecho-do-oculos", "nome": "Brechó do Óculos", "regiao": "Asa Norte", "endereco": "SHCGN 706/707, Bloco C, entrada 10, sala 207", "insta": "@brechodooculos", "horario": "", "faixa": "medio", "notas": "Só óculos.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'bonne-affaire', '{"id": "bonne-affaire", "nome": "Bonne Affaire", "regiao": "Lago Sul", "endereco": "SHIS QI 5 (endereço a confirmar)", "insta": "", "horario": "", "faixa": "caro", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'comadres', '{"id": "comadres", "nome": "Comadres Brechó de Luxo", "regiao": "Asa Norte", "endereco": "Liberty Mall, piso térreo", "insta": "@comadres", "horario": "", "faixa": "caro", "notas": "Luxo. Outro guia cita CLN 214, Bloco A, sala 107.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'usadao-antonios', '{"id": "usadao-antonios", "nome": "Usadão Antonio''s", "regiao": "Asa Sul", "endereco": "SHCS 213, Bloco A, loja 33", "insta": "", "horario": "", "faixa": "barato", "notas": "Preços baixos. Outro guia cita 214 Sul, Bloco B, subsolo.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'usadao-brasilia', '{"id": "usadao-brasilia", "nome": "Usadão Brasília", "regiao": "Asa Norte", "endereco": "CLN 312, Bloco C, loja 23", "insta": "", "horario": "", "faixa": "barato", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'atacado-ceilandia', '{"id": "atacado-ceilandia", "nome": "Atacado da Ceilândia", "regiao": "Ceilândia", "endereco": "QNP 10, Conjunto Z, casa 8, P Sul", "insta": "", "horario": "", "faixa": "barato", "notas": "Guia cita blusas a R$ 2, vestidos a R$ 5 e calças a R$ 10.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'retro-ativa', '{"id": "retro-ativa", "nome": "Retrô Ativa", "regiao": "Asa Norte", "endereco": "CLN 201, Bloco A, loja 67", "insta": "", "horario": "", "faixa": "medio", "notas": "Roupas, acessórios e decoração.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'garimpo-lago-sul', '{"id": "garimpo-lago-sul", "nome": "Garimpo", "regiao": "Lago Sul", "endereco": "Endereço a confirmar", "insta": "", "horario": "", "faixa": "caro", "notas": "Peças de grife.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'lixomania', '{"id": "lixomania", "nome": "Lixomania Vintage", "regiao": "Asa Norte", "endereco": "CLN 102, Bloco A, loja 10", "insta": "@lixo_mania", "horario": "", "faixa": "medio", "notas": "Estética anos 80, peças com curadoria.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'sex-machine', '{"id": "sex-machine", "nome": "Brechó Sex Machine (no Que Balaio)", "regiao": "Asa Norte", "endereco": "CLN 308, Bloco B, loja 5", "insta": "@brechosexmachine", "horario": "", "faixa": "medio", "notas": "Roupas dos anos 70, 80 e 90.", "conferir": false, "slow": 1}'::jsonb),
  ('brechos', 'usado-transado', '{"id": "usado-transado", "nome": "Usado Transado", "regiao": "Asa Sul", "endereco": "CLS 306, Bloco A, loja 22", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'varal-retro', '{"id": "varal-retro", "nome": "Varal Retrô", "regiao": "Asa Sul", "endereco": "CLS 407, Bloco B, loja 26", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'el-rastro', '{"id": "el-rastro", "nome": "Brechó El Rastro", "regiao": "Asa Norte", "endereco": "SCLRN 713, Bloco G, loja 15", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'badulake', '{"id": "badulake", "nome": "Badulake", "regiao": "Asa Norte", "endereco": "CLN 115, Bloco C, loja 19", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'evelin', '{"id": "evelin", "nome": "Evelin Brechó e Ateliê de Arte", "regiao": "Asa Norte", "endereco": "CLN 201, Bloco A, loja 71A", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'bizarro', '{"id": "bizarro", "nome": "Bizarro Brechó", "regiao": "Ceilândia", "endereco": "CNM 1, Bloco G, sala 106", "insta": "", "horario": "", "faixa": "barato", "notas": "Roupas novas e usadas.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'boca-boca', '{"id": "boca-boca", "nome": "Boca Boca Brechó", "regiao": "Guará", "endereco": "QE 42, Conjunto B, lote 13", "insta": "", "horario": "", "faixa": "barato", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'maria-mercado', '{"id": "maria-mercado", "nome": "Maria Mercado", "regiao": "Sudoeste", "endereco": "CLSW 103, Bloco B, loja 15", "insta": "", "horario": "", "faixa": "medio", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'casas-barcelos', '{"id": "casas-barcelos", "nome": "Casas Barcelos Brechó", "regiao": "Ceilândia", "endereco": "QNM 1 (endereço a confirmar)", "insta": "", "horario": "", "faixa": "barato", "notas": "", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'tachado-de-doido', '{"id": "tachado-de-doido", "nome": "Tachado de Doido Brechó & Café", "regiao": "Asa Norte", "endereco": "Endereço a confirmar", "insta": "", "horario": "", "faixa": "medio", "notas": "Curadoria descolada, com café.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'lavo-ta-novo-sul', '{"id": "lavo-ta-novo-sul", "nome": "Lavô tá Novo", "regiao": "Asa Sul", "endereco": "Endereço a confirmar", "insta": "", "horario": "", "faixa": "medio", "notas": "Roupas higienizadas e marcas conhecidas. Tem unidade na Asa Norte também.", "conferir": true, "slow": 1}'::jsonb),
  ('brechos', 'a-gosto-de-brecho', '{"id": "a-gosto-de-brecho", "nome": "A-gosto de Brechó", "regiao": "Asa Sul", "endereco": "Endereço a confirmar", "insta": "", "horario": "", "faixa": "medio", "notas": "Do básico ao sofisticado, com acessórios e calçados.", "conferir": true, "slow": 1}'::jsonb)
on conflict (col, id) do nothing;
