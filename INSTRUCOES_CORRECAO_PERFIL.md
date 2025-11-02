# 🔧 Instruções para Corrigir Perfis de Usuário

## ❗ Problema Identificado

Os usuários antigos (cadastrados antes da correção) não têm perfil na tabela `users`, causando o erro "Usuário não encontrado" quando alguém tenta visualizar seus perfis.

**Causa:** O trigger do Supabase que deveria criar perfis automaticamente não está funcionando.

---

## ✅ Solução: Migração do Banco de Dados

Para corrigir os usuários existentes, você **PRECISA** executar o SQL no Supabase:

#### **Passo a Passo:**

1. **Acesse o Painel do Supabase**
   - Vá para: https://app.supabase.com
   - Selecione seu projeto

2. **Abra o SQL Editor**
   - No menu lateral, clique em **"SQL Editor"**
   - Clique em **"New query"**

3. **Execute o Script**
   - Abra o arquivo `supabase_migration_user_profile.sql`
   - Copie TODO o conteúdo
   - Cole no editor SQL do Supabase
   - Clique em **"Run"**

4. **Verifique os Resultados**
   - O script mostrará quantos usuários foram criados
   - Exemplo de resultado:
   ```
   total_users_in_auth | total_users_in_public
   -------------------|---------------------
   10                 | 10
   ```

---

## 🎯 O Que o Script SQL Faz

### **1. Configura Políticas RLS (Row Level Security)**
- ✅ Permite que **qualquer um** veja perfis de usuários (necessário para "Ver Perfil")
- ✅ Permite que usuários **criem** seu próprio perfil no cadastro
- ✅ Permite que usuários **atualizem** apenas seu próprio perfil

### **2. Migra Usuários Existentes**
- ✅ Busca todos os usuários em `auth.users` que não têm perfil em `public.users`
- ✅ Cria perfis com dados do `raw_user_meta_data` (nome, telefone, CPF)
- ✅ Trata erros individualmente (se um falhar, continua com os outros)
- ✅ Mostra progresso no console

### **3. Verifica o Resultado**
- ✅ Compara total de usuários no auth vs public
- ✅ Mostra mensagem de sucesso se todos tiverem perfil

---

## 🧪 Como Testar

### **Teste 1: Usuário Antigo**
1. Faça login com um usuário antigo
2. Vá para "Explorar Serviços" ou "Explorar Pedidos"
3. Clique em "Ver perfil do prestador/solicitante"
4. ✅ O perfil deve carregar sem erros

### **Teste 2: Novo Cadastro**
1. Faça logout
2. Crie um novo usuário
3. Faça login com outro usuário
4. Veja o perfil do novo usuário
5. ✅ O perfil deve aparecer imediatamente

---

## 📊 O Que Você Verá

### **No Supabase SQL Editor:**
```
NOTICE: Perfil criado para usuário: Samara Guindani (samara@email.com)
NOTICE: Perfil criado para usuário: João Silva (joao@email.com)
NOTICE: ========================================
NOTICE: Migração concluída!
NOTICE: Total de perfis criados: 2
NOTICE: ========================================

total_usuarios_auth | total_usuarios_public | status
--------------------|----------------------|---------------------------
5                   | 5                    | ✅ TODOS OS USUÁRIOS TÊM PERFIL
```

### **No App Flutter:**
```
✅ User profile loaded: Samara Guindani
```

Antes da migração, você veria:
```
! User profile not found in database for ID: bf91b2ae-4650-4c59-9fe4-1d353ee6356d
```

---

## ⚠️ Importante

- ✅ Execute o SQL **UMA VEZ APENAS**
- ✅ O script é **seguro** - não cria duplicatas
- ✅ Trata erros individualmente (se um usuário falhar, continua com os outros)
- ✅ Novos cadastros já funcionam corretamente (não precisam da migração)

---

## 🆘 Solucionando Problemas

### **Erro: "relation 'public.users' does not exist"**
❌ A tabela `users` não existe
✅ Solução: Verifique se a tabela foi criada corretamente no Supabase

### **Erro: "permission denied for table users"**
❌ Você não tem permissão para executar o script
✅ Solução: Certifique-se de estar logado como proprietário do projeto

### **Erro: "policy ... already exists"**
⚠️ As políticas já foram criadas antes
✅ Solução: Isso é normal! O script continua e cria os perfis

### **Ainda aparece "Usuário não encontrado"**
1. ✅ Confirme que o script foi executado com sucesso
2. ✅ Verifique no Table Editor > `users` se os perfis existem
3. ✅ Faça hot reload (pressione `r` no terminal do Flutter)
4. ✅ Se não funcionar, reinicie o app completamente

---

## 📝 Verificar Perfis Criados

Para ver todos os usuários na tabela `users`:

1. Vá em **Table Editor** > **users**
2. Você verá todos os perfis com:
   - ID
   - Email
   - Nome completo
   - Telefone
   - CPF
   - Datas de criação

---

## 🎉 Resultado Final

Após executar o script SQL:
- ✅ Todos os usuários terão perfil na tabela `users`
- ✅ Qualquer um pode ver o perfil de qualquer usuário
- ✅ "Usuário não encontrado" não aparece mais
- ✅ Sistema funciona perfeitamente para ver perfis de criadores de serviços/pedidos

