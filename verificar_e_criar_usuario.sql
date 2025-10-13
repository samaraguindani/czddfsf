-- Script para verificar e criar usuário na tabela users
-- Execute este script no SQL Editor do Supabase

-- 1. Verificar se o trigger existe
SELECT 
  tgname as trigger_name,
  tgenabled as enabled
FROM pg_trigger 
WHERE tgname = 'on_auth_user_created';

-- 2. Se o trigger não existir, criar:
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, phone, cpf, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    COALESCE(NEW.raw_user_meta_data->>'cpf', ''),
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Remover trigger antigo se existir
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Criar novo trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 3. Verificar usuários existentes no auth.users
SELECT 
  id,
  email,
  email_confirmed_at,
  created_at,
  raw_user_meta_data
FROM auth.users
ORDER BY created_at DESC;

-- 4. Verificar usuários na tabela users
SELECT 
  id,
  email,
  full_name,
  phone,
  cpf,
  created_at
FROM public.users
ORDER BY created_at DESC;

-- 5. Se houver usuários no auth.users mas não na tabela users, inseri-los manualmente:
INSERT INTO public.users (id, email, full_name, phone, cpf, created_at, updated_at)
SELECT 
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'full_name', '') as full_name,
  COALESCE(au.raw_user_meta_data->>'phone', '') as phone,
  COALESCE(au.raw_user_meta_data->>'cpf', '') as cpf,
  au.created_at,
  NOW() as updated_at
FROM auth.users au
LEFT JOIN public.users u ON au.id = u.id
WHERE u.id IS NULL;

-- 6. Verificar novamente se todos os usuários foram criados
SELECT 
  au.id,
  au.email as auth_email,
  u.email as users_email,
  u.full_name,
  CASE 
    WHEN u.id IS NULL THEN '❌ Missing in users table'
    ELSE '✅ Exists in both tables'
  END as status
FROM auth.users au
LEFT JOIN public.users u ON au.id = u.id
ORDER BY au.created_at DESC;
