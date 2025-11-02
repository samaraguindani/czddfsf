-- =====================================================
-- UNIFAZ - Script de Configuração Inicial do Banco
-- =====================================================
-- Este script cria a estrutura inicial das tabelas,
-- políticas RLS e triggers necessários para o app.
-- =====================================================

-- ===========================
-- 1. TABELA DE USUÁRIOS
-- ===========================

CREATE TABLE IF NOT EXISTS public.users (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  cpf TEXT NOT NULL,
  description TEXT,
  cep TEXT,
  street TEXT,
  number TEXT,
  complement TEXT,
  neighborhood TEXT,
  city TEXT,
  state TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX IF NOT EXISTS users_email_idx ON public.users (email);
CREATE INDEX IF NOT EXISTS users_city_state_idx ON public.users (city, state);

-- ===========================
-- 2. TABELA DE SERVIÇOS
-- ===========================

CREATE TABLE IF NOT EXISTS public.services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  availability TEXT NOT NULL,
  value DECIMAL(10,2),
  pricing_type TEXT NOT NULL,
  contact TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  is_voluntary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS services_user_id_idx ON public.services (user_id);
CREATE INDEX IF NOT EXISTS services_category_idx ON public.services (category);
CREATE INDEX IF NOT EXISTS services_city_state_idx ON public.services (city, state);
CREATE INDEX IF NOT EXISTS services_is_voluntary_idx ON public.services (is_voluntary);
CREATE INDEX IF NOT EXISTS services_created_at_idx ON public.services (created_at DESC);

-- ===========================
-- 3. TABELA DE DEMANDAS
-- ===========================

CREATE TABLE IF NOT EXISTS public.requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  urgency TEXT NOT NULL,
  budget DECIMAL(10,2),
  pricing_type TEXT NOT NULL,
  contact TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  is_voluntary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX IF NOT EXISTS requests_user_id_idx ON public.requests (user_id);
CREATE INDEX IF NOT EXISTS requests_category_idx ON public.requests (category);
CREATE INDEX IF NOT EXISTS requests_city_state_idx ON public.requests (city, state);
CREATE INDEX IF NOT EXISTS requests_urgency_idx ON public.requests (urgency);
CREATE INDEX IF NOT EXISTS requests_is_voluntary_idx ON public.requests (is_voluntary);
CREATE INDEX IF NOT EXISTS requests_created_at_idx ON public.requests (created_at DESC);

-- ===========================
-- 4. POLÍTICAS RLS (ROW LEVEL SECURITY)
-- ===========================

-- Habilitar RLS em todas as tabelas
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.requests ENABLE ROW LEVEL SECURITY;

-- ===========================
-- 4.1 POLÍTICAS PARA USERS
-- ===========================

-- Qualquer um pode visualizar perfis públicos
DROP POLICY IF EXISTS "Anyone can view user profiles" ON public.users;
CREATE POLICY "Anyone can view user profiles" ON public.users
  FOR SELECT USING (true);

-- Usuários podem inserir seu próprio perfil
DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;
CREATE POLICY "Users can insert own profile" ON public.users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Usuários podem atualizar seu próprio perfil
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Usuários podem excluir seu próprio perfil
DROP POLICY IF EXISTS "Users can delete own profile" ON public.users;
CREATE POLICY "Users can delete own profile" ON public.users
  FOR DELETE USING (auth.uid() = id);

-- ===========================
-- 4.2 POLÍTICAS PARA SERVICES
-- ===========================

-- Qualquer um pode visualizar serviços
DROP POLICY IF EXISTS "Anyone can view services" ON public.services;
CREATE POLICY "Anyone can view services" ON public.services
  FOR SELECT USING (true);

-- Usuários podem inserir seus próprios serviços
DROP POLICY IF EXISTS "Users can insert own services" ON public.services;
CREATE POLICY "Users can insert own services" ON public.services
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios serviços
DROP POLICY IF EXISTS "Users can update own services" ON public.services;
CREATE POLICY "Users can update own services" ON public.services
  FOR UPDATE USING (auth.uid() = user_id);

-- Usuários podem excluir seus próprios serviços
DROP POLICY IF EXISTS "Users can delete own services" ON public.services;
CREATE POLICY "Users can delete own services" ON public.services
  FOR DELETE USING (auth.uid() = user_id);

-- ===========================
-- 4.3 POLÍTICAS PARA REQUESTS
-- ===========================

-- Qualquer um pode visualizar demandas
DROP POLICY IF EXISTS "Anyone can view requests" ON public.requests;
CREATE POLICY "Anyone can view requests" ON public.requests
  FOR SELECT USING (true);

-- Usuários podem inserir suas próprias demandas
DROP POLICY IF EXISTS "Users can insert own requests" ON public.requests;
CREATE POLICY "Users can insert own requests" ON public.requests
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar suas próprias demandas
DROP POLICY IF EXISTS "Users can update own requests" ON public.requests;
CREATE POLICY "Users can update own requests" ON public.requests
  FOR UPDATE USING (auth.uid() = user_id);

-- Usuários podem excluir suas próprias demandas
DROP POLICY IF EXISTS "Users can delete own requests" ON public.requests;
CREATE POLICY "Users can delete own requests" ON public.requests
  FOR DELETE USING (auth.uid() = user_id);

-- ===========================
-- 5. TRIGGERS
-- ===========================

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar trigger em todas as tabelas
DROP TRIGGER IF EXISTS update_users_updated_at ON public.users;
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_services_updated_at ON public.services;
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON public.services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_requests_updated_at ON public.requests;
CREATE TRIGGER update_requests_updated_at BEFORE UPDATE ON public.requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ===========================
-- 6. VERIFICAÇÃO
-- ===========================

-- Consulta para verificar se tudo foi criado corretamente
SELECT 
  'Tabelas criadas' as status,
  (SELECT COUNT(*) FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name IN ('users', 'services', 'requests')) as total_tables,
  (SELECT COUNT(*) FROM pg_policies 
   WHERE schemaname = 'public' 
   AND tablename IN ('users', 'services', 'requests')) as total_policies;

-- ===========================
-- FIM DO SCRIPT
-- ===========================

