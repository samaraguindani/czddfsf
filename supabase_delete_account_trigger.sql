-- Script para permitir que usuários excluam suas próprias contas
-- Execute este script no SQL Editor do Supabase

-- 1. Criar função para excluir conta de autenticação quando o perfil é excluído
CREATE OR REPLACE FUNCTION delete_auth_user()
RETURNS TRIGGER AS $$
BEGIN
  -- Excluir o usuário da tabela auth.users
  DELETE FROM auth.users WHERE id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Criar trigger que executa após a exclusão de um perfil
DROP TRIGGER IF EXISTS on_user_deleted ON public.users;
CREATE TRIGGER on_user_deleted
  AFTER DELETE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION delete_auth_user();

-- 3. Permitir que usuários excluam seus próprios dados (RLS Policies)

-- Policy para excluir serviços próprios
DROP POLICY IF EXISTS "Users can delete their own services" ON public.services;
CREATE POLICY "Users can delete their own services"
  ON public.services
  FOR DELETE
  USING (auth.uid() = user_id);

-- Policy para excluir pedidos próprios
DROP POLICY IF EXISTS "Users can delete their own requests" ON public.requests;
CREATE POLICY "Users can delete their own requests"
  ON public.requests
  FOR DELETE
  USING (auth.uid() = user_id);

-- Policy para excluir perfil próprio
DROP POLICY IF EXISTS "Users can delete their own profile" ON public.users;
CREATE POLICY "Users can delete their own profile"
  ON public.users
  FOR DELETE
  USING (auth.uid() = id);

-- Verificação
SELECT 'Configuração de exclusão de conta instalada com sucesso!' as status;

