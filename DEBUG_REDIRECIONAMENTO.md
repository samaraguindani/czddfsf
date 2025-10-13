# Debug do Problema de Redirecionamento - UNIFAZ

## Problema Identificado
O usuário não consegue sair da página de login após fazer login com sucesso.

## Análise do Problema
Havia um conflito entre dois sistemas de redirecionamento:
1. **AuthWrapper** (main.dart) - Sistema automático de redirecionamento
2. **LoginScreen** - Redirecionamento manual com Navigator.pushReplacement

## Correções Aplicadas

### 1. Logs de Debug Adicionados
- ✅ AuthProvider com logs detalhados
- ✅ AuthWrapper com logs de estado
- ✅ Métodos signIn e _loadUserProfile com logs

### 2. Redirecionamento Corrigido
- ✅ Removido redirecionamento manual do LoginScreen
- ✅ Deixado apenas o AuthWrapper gerenciar o redirecionamento
- ✅ Sistema agora é totalmente automático

## Como Testar

### 1. Execute o App
```bash
flutter run --debug
```

### 2. Monitore os Logs
Procure por estas mensagens no console:
- `🚀 Starting sign in for: email@exemplo.com`
- `🔍 Sign in response: user_id`
- `✅ Sign in successful`
- `🔍 Auth state changed: SIGNED_IN`
- `📋 Loading user profile for: user_id`
- `✅ User profile loaded: Nome do Usuário`
- `🔄 AuthWrapper rebuild - isLoading: false, isAuthenticated: true`
- `✅ User authenticated, showing HomeScreen`

### 3. Fluxo Esperado
1. Usuário faz login
2. AuthProvider.signIn() retorna true
3. AuthWrapper detecta mudança de estado
4. _loadUserProfile() carrega dados do usuário
5. AuthWrapper redireciona automaticamente para HomeScreen

## Possíveis Problemas e Soluções

### Problema 1: Usuário não existe na tabela users
**Sintoma:** Erro ao carregar perfil do usuário
**Solução:** Execute o script SQL para criar o trigger

### Problema 2: Confirmação por email habilitada
**Sintoma:** Login falha mesmo com credenciais corretas
**Solução:** Desabilite confirmação por email no Supabase

### Problema 3: Políticas RLS incorretas
**Sintoma:** Erro de permissão ao buscar perfil
**Solução:** Verifique as políticas RLS da tabela users

## Script SQL para Verificar/Criar Trigger

```sql
-- Verificar se o trigger existe
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- Se não existir, criar:
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
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## Erros Corrigidos
- ✅ Erro: `The getter 'user' isn't defined for the type 'AuthState'`
  - **Causa:** AuthState não tem propriedade `user`, apenas `session`
  - **Solução:** Removida linha `data.user?.id` dos logs

## Status Atual
- ✅ Logs de debug adicionados e corrigidos
- ✅ Redirecionamento manual removido
- ✅ Sistema automático configurado
- ✅ Erro de compilação corrigido
- 🚀 App executando em modo debug
