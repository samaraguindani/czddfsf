# Instruções para Configurar Exclusão de Conta

Este documento explica como configurar a funcionalidade de exclusão de conta no Supabase.

## O que foi implementado?

### No Aplicativo:

1. ✅ **Botão "Excluir Conta"** na tela de perfil (em vermelho)
2. ✅ **Dupla confirmação** de segurança:
   - Primeiro dialog explicando as consequências
   - Segundo dialog pedindo para digitar "EXCLUIR"
3. ✅ **Exclusão automática** de:
   - Todos os serviços do usuário
   - Todos os pedidos do usuário
   - Perfil do usuário
   - Conta de autenticação

## Configuração no Supabase

Para que a exclusão funcione completamente, você precisa executar o script SQL no banco de dados.

### Passo 1: Acessar o SQL Editor

1. Acesse o [Supabase Dashboard](https://app.supabase.com)
2. Selecione seu projeto
3. No menu lateral, clique em **"SQL Editor"**

### Passo 2: Executar o Script

1. Clique em **"New Query"**
2. Copie todo o conteúdo do arquivo `supabase_delete_account_trigger.sql`
3. Cole no editor
4. Clique em **"Run"** ou pressione `Ctrl+Enter`

### O que o script faz?

1. **Cria uma função** que exclui automaticamente o usuário da tabela `auth.users` quando seu perfil é excluído
2. **Cria um trigger** que executa essa função após a exclusão de um perfil
3. **Cria políticas RLS** que permitem que usuários excluam:
   - Seus próprios serviços
   - Seus próprios pedidos
   - Seu próprio perfil

### Resultado Esperado

Se tudo der certo, você verá:

```
✓ Success. No rows returned
status: "Configuração de exclusão de conta instalada com sucesso!"
```

## Como usar no App

1. O usuário acessa **"Meu Perfil"**
2. Rola até o final da página
3. Clica em **"Excluir Conta"** (botão vermelho)
4. Confirma no primeiro dialog
5. Digite "EXCLUIR" no segundo dialog
6. A conta será excluída e o usuário será redirecionado para o login

## Segurança

### Medidas de Proteção:

- ✅ **Dupla confirmação** obrigatória
- ✅ **Aviso claro** sobre perda de dados
- ✅ **Ação irreversível** claramente comunicada
- ✅ **RLS policies** garantem que usuários só podem excluir seus próprios dados

### O que é excluído:

- ❌ Todos os serviços cadastrados
- ❌ Todos os pedidos cadastrados
- ❌ Perfil completo
- ❌ Conta de autenticação

### O que NÃO é possível:

- ❌ Recuperar a conta após exclusão
- ❌ Recuperar dados após exclusão
- ❌ Desfazer a ação

## Solução de Problemas

### Erro: "Permission denied"

Se aparecer erro de permissão, verifique se:
1. O script foi executado completamente
2. As RLS policies foram criadas
3. O usuário está autenticado

### Erro: "Function does not exist"

Execute o script novamente no SQL Editor.

### A conta não é excluída do auth.users

Verifique se:
1. O trigger foi criado corretamente
2. A função `delete_auth_user()` existe
3. O trigger está ativo na tabela `public.users`

## Verificação

Para verificar se está tudo configurado, execute no SQL Editor:

```sql
-- Verificar se a função existe
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_name = 'delete_auth_user';

-- Verificar se o trigger existe
SELECT trigger_name 
FROM information_schema.triggers 
WHERE trigger_name = 'on_user_deleted';

-- Verificar políticas RLS
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename IN ('users', 'services', 'requests')
  AND policyname LIKE '%delete%';
```

## Notas Importantes

⚠️ **ATENÇÃO**: Esta é uma ação destrutiva e irreversível!

- Não há como recuperar dados após a exclusão
- Certifique-se de que o usuário entende as consequências
- Considere implementar um backup automático antes da exclusão (opcional)

## Suporte

Se encontrar problemas:
1. Verifique os logs do Supabase
2. Confirme que todas as policies estão ativas
3. Teste com uma conta de desenvolvimento primeiro

