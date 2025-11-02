-- =================================================================
-- MIGRAÇÃO: Criar Perfis para Usuários Existentes
-- =================================================================
-- Execute este SQL no painel do Supabase:
-- Dashboard > SQL Editor > Nova Query > Cole este código > Run
-- =================================================================

-- PASSO 1: Remover políticas RLS existentes (se houver)
DROP POLICY IF EXISTS "Anyone can view user profiles" ON public.users;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.users;
DROP POLICY IF EXISTS "Users can update their own profile" ON public.users;

-- PASSO 2: Criar política para permitir leitura de todos os perfis
CREATE POLICY "Anyone can view user profiles"
ON public.users FOR SELECT
USING (true);

-- PASSO 3: Criar política para permitir inserção do próprio perfil
CREATE POLICY "Users can insert their own profile"
ON public.users FOR INSERT
WITH CHECK (auth.uid() = id);

-- PASSO 4: Criar política para permitir atualização do próprio perfil
CREATE POLICY "Users can update their own profile"
ON public.users FOR UPDATE
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- =================================================================
-- MIGRAÇÃO: Popular tabela users com usuários do auth
-- =================================================================

DO $$
DECLARE
  rec RECORD;
  inserted_count INTEGER := 0;
BEGIN
  -- Iterar sobre todos os usuários do auth.users
  FOR rec IN 
    SELECT 
      au.id,
      au.email,
      au.created_at,
      au.raw_user_meta_data
    FROM auth.users au
    WHERE NOT EXISTS (
      SELECT 1 FROM public.users u WHERE u.id = au.id
    )
  LOOP
    BEGIN
      -- Tentar inserir o perfil
      INSERT INTO public.users (id, email, full_name, phone, cpf, created_at, updated_at)
      VALUES (
        rec.id,
        COALESCE(rec.email, ''),
        COALESCE(rec.raw_user_meta_data->>'full_name', 'Usuário'),
        COALESCE(rec.raw_user_meta_data->>'phone', ''),
        COALESCE(rec.raw_user_meta_data->>'cpf', ''),
        rec.created_at,
        NOW()
      );
      inserted_count := inserted_count + 1;
      RAISE NOTICE 'Perfil criado para usuário: % (%)', rec.raw_user_meta_data->>'full_name', rec.email;
    EXCEPTION
      WHEN others THEN
        RAISE NOTICE 'Erro ao criar perfil para %: %', rec.email, SQLERRM;
    END;
  END LOOP;
  
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Migração concluída!';
  RAISE NOTICE 'Total de perfis criados: %', inserted_count;
  RAISE NOTICE '========================================';
END $$;

-- =================================================================
-- VERIFICAÇÃO: Conferir resultado
-- =================================================================

SELECT 
  (SELECT COUNT(*) FROM auth.users) as total_usuarios_auth,
  (SELECT COUNT(*) FROM public.users) as total_usuarios_public,
  CASE 
    WHEN (SELECT COUNT(*) FROM auth.users) = (SELECT COUNT(*) FROM public.users) 
    THEN '✅ TODOS OS USUÁRIOS TÊM PERFIL'
    ELSE '⚠️ ALGUNS USUÁRIOS AINDA NÃO TÊM PERFIL'
  END as status;

