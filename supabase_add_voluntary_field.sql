-- ========================================================
-- ADICIONAR CAMPO "TRABALHO VOLUNTÁRIO" 
-- ========================================================
-- Este script adiciona o campo "is_voluntary" nas tabelas
-- services e requests para identificar trabalhos voluntários
-- 
-- Execute este SQL no painel do Supabase:
-- Dashboard > SQL Editor > Nova Query > Cole este código > Run
-- ========================================================

-- PASSO 1: Adicionar coluna is_voluntary na tabela services
ALTER TABLE public.services 
ADD COLUMN IF NOT EXISTS is_voluntary BOOLEAN DEFAULT FALSE NOT NULL;

-- PASSO 2: Adicionar coluna is_voluntary na tabela requests
ALTER TABLE public.requests 
ADD COLUMN IF NOT EXISTS is_voluntary BOOLEAN DEFAULT FALSE NOT NULL;

-- PASSO 3: Adicionar índices para melhorar consultas
CREATE INDEX IF NOT EXISTS idx_services_is_voluntary ON public.services(is_voluntary);
CREATE INDEX IF NOT EXISTS idx_requests_is_voluntary ON public.requests(is_voluntary);

-- PASSO 4: Adicionar comentários nas colunas
COMMENT ON COLUMN public.services.is_voluntary IS 'Indica se o serviço é oferecido como trabalho voluntário (sem custo)';
COMMENT ON COLUMN public.requests.is_voluntary IS 'Indica se o pedido busca voluntários (sem pagamento)';

-- ========================================================
-- VERIFICAÇÃO: Confirmar que as colunas foram adicionadas
-- ========================================================

SELECT 
  'services' as tabela,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'services' 
  AND column_name = 'is_voluntary'

UNION ALL

SELECT 
  'requests' as tabela,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'requests' 
  AND column_name = 'is_voluntary';

-- ========================================================
-- RESULTADO ESPERADO:
-- tabela    | column_name   | data_type | is_nullable | column_default
-- ----------|---------------|-----------|-------------|---------------
-- services  | is_voluntary  | boolean   | NO          | false
-- requests  | is_voluntary  | boolean   | NO          | false
-- ========================================================

