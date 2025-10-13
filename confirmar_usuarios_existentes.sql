-- Script para confirmar todos os usuários existentes
-- Execute este script no SQL Editor do Supabase

-- Confirmar todos os usuários que ainda não foram confirmados
UPDATE auth.users 
SET email_confirmed_at = NOW(),
    confirmed_at = NOW()
WHERE email_confirmed_at IS NULL;

-- Verificar usuários confirmados
SELECT 
  id,
  email,
  email_confirmed_at,
  confirmed_at,
  created_at
FROM auth.users
ORDER BY created_at DESC;

-- Se quiser confirmar um usuário específico, use:
-- UPDATE auth.users 
-- SET email_confirmed_at = NOW(),
--     confirmed_at = NOW()
-- WHERE email = 'seu-email@exemplo.com';
