# Como Desabilitar Confirmação por Email no Supabase

## ❌ Erro Atual
```
Email not confirmed - statusCode: 400, code: email_not_confirmed
```

## ✅ Solução: Desabilitar Confirmação por Email

### Passo 1: Acesse o Painel do Supabase
1. Vá para [https://supabase.com](https://supabase.com)
2. Faça login na sua conta
3. Selecione o projeto **UNIFAZ** (ou seu projeto)

### Passo 2: Navegue até Authentication Settings
1. No menu lateral esquerdo, clique em **"Authentication"**
2. Clique na aba **"Providers"**
3. Role para baixo até encontrar **"Email"**
4. Clique em **"Email"** para expandir

### Passo 3: Desabilitar Confirmação
1. Procure a opção **"Confirm email"**
2. **Desative/Desligue** esta opção (toggle para OFF)
3. Clique em **"Save"** para salvar as alterações

### Passo 4: Configurações Adicionais (Recomendado)
1. Ainda em **Authentication → Providers → Email**:
   - ✅ "Enable email provider" = **ON**
   - ❌ "Confirm email" = **OFF**
   - ❌ "Secure email change" = **OFF** (opcional)

### Passo 5: Verificar Usuários Existentes
Se você já criou usuários antes de desabilitar a confirmação:

1. Vá para **Authentication → Users**
2. Encontre seu usuário
3. Clique nos 3 pontinhos (⋮) ao lado do usuário
4. Selecione **"Confirm user"**
5. Confirme a ação

OU execute este SQL no **SQL Editor**:
```sql
-- Confirmar todos os usuários existentes
UPDATE auth.users 
SET email_confirmed_at = NOW() 
WHERE email_confirmed_at IS NULL;
```

## Teste Após Desabilitar

### 1. Limpe o Cache do App
```bash
flutter clean
flutter pub get
```

### 2. Execute Novamente
```bash
flutter run --debug
```

### 3. Teste o Login
- Use as credenciais de um usuário existente
- O login deve funcionar imediatamente
- Você deve ser redirecionado para a HomeScreen

## Fluxo Esperado Após Correção
1. Usuário faz login → `🚀 Starting sign in for: email@exemplo.com`
2. Login bem-sucedido → `✅ Sign in successful`
3. Estado muda → `🔍 Auth state changed: AuthChangeEvent.signedIn`
4. Perfil carregado → `📋 Loading user profile for: [user-id]`
5. Redirecionamento → `✅ User authenticated, showing HomeScreen`

## Alternativa: Interface Antiga do Supabase
Se você tem a interface antiga do Supabase:

1. Vá para **Authentication → Settings**
2. Procure **"User Signups"**
3. Desative **"Enable email confirmations"**
4. Clique em **"Save"**

## Verificação Final
Após desabilitar, você deve ver nos logs:
```
✅ Sign in successful
✅ User authenticated, loading profile...
✅ User authenticated, showing HomeScreen
```

Em vez de:
```
❌ Sign in error: AuthApiException(message: Email not confirmed)
```
