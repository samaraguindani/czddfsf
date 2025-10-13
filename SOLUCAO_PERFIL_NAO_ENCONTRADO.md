# Solução: Erro ao Carregar Perfil do Usuário

## ❌ Problema Atual
```
Error loading user profile: PostgrestException(message: Cannot coerce the result to a single JSON object)
```

## 🔍 Causa
O usuário existe no `auth.users` mas **não existe** na tabela `public.users`. Isso acontece quando:
1. O trigger não foi criado
2. O trigger não executou corretamente
3. O usuário foi criado antes do trigger ser configurado

## ✅ Solução Completa

### Passo 1: Execute o Script SQL
No **SQL Editor** do Supabase, execute o arquivo `verificar_e_criar_usuario.sql`:

```sql
-- 1. Criar/Recriar a função do trigger
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

-- 2. Criar o trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 3. Inserir usuários existentes que estão faltando
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
```

### Passo 2: Verificar se Funcionou
Execute esta query para verificar:
```sql
SELECT 
  au.id,
  au.email as auth_email,
  u.email as users_email,
  u.full_name,
  CASE 
    WHEN u.id IS NULL THEN '❌ Missing'
    ELSE '✅ OK'
  END as status
FROM auth.users au
LEFT JOIN public.users u ON au.id = u.id;
```

Todos os usuários devem mostrar `✅ OK`.

### Passo 3: Teste o App Novamente
```bash
# Hot reload (se o app ainda estiver rodando)
# Pressione 'r' no terminal

# OU reinicie o app
flutter run --debug
```

### Passo 4: Faça Login
Agora você deve ver nos logs:
```
✅ Sign in successful
🔍 Auth state changed: AuthChangeEvent.signedIn
📋 Loading user profile for: [user-id]
✅ User profile loaded: [Seu Nome]
✅ User authenticated, showing HomeScreen
```

## 🔧 Alterações no Código

### 1. AuthService
- ✅ Mudado `.single()` para `.maybeSingle()`
- ✅ Adicionado tratamento para quando o perfil não existe
- ✅ Logs mais detalhados

### 2. AuthProvider
- ✅ Melhor tratamento de erro ao carregar perfil
- ✅ Mensagem informativa quando perfil não existe

## 📋 Checklist de Verificação

- [ ] Trigger `on_auth_user_created` existe e está habilitado
- [ ] Função `handle_new_user()` está criada
- [ ] Todos os usuários do `auth.users` existem em `public.users`
- [ ] Políticas RLS estão configuradas corretamente
- [ ] Confirmação por email está desabilitada
- [ ] App compila sem erros
- [ ] Login funciona e redireciona para HomeScreen

## 🎯 Resultado Esperado

Após executar o script SQL:
1. ✅ Trigger criado e funcionando
2. ✅ Usuários existentes inseridos na tabela `users`
3. ✅ Login funciona completamente
4. ✅ Perfil carregado com sucesso
5. ✅ Redirecionamento automático para HomeScreen
