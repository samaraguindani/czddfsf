# Política de Segurança

## 🔒 Versões Suportadas

Atualmente, estamos fornecendo atualizações de segurança para as seguintes versões:

| Versão | Suportada          |
| ------ | ------------------ |
| 1.x.x  | :white_check_mark: |
| < 1.0  | :x:                |

## 🛡️ Reportando uma Vulnerabilidade

A segurança dos usuários do UNIFAZ é nossa prioridade máxima. Se você descobriu uma vulnerabilidade de segurança, pedimos que nos ajude de forma responsável, reportando-a de forma privada.

### Como Reportar

**Por favor, NÃO reporte vulnerabilidades de segurança através de issues públicas.**

Em vez disso, envie um email para: **security@unifaz.com** (ou crie um Security Advisory privado no GitHub)

Inclua as seguintes informações em seu relatório:

- Tipo de vulnerabilidade (ex: XSS, SQL Injection, etc.)
- Caminhos completos dos arquivos fonte relacionados à manifestação da vulnerabilidade
- Localização do código fonte afetado (tag/branch/commit ou URL direto)
- Qualquer configuração especial necessária para reproduzir o problema
- Instruções passo a passo para reproduzir o problema
- Prova de conceito ou código de exploração (se possível)
- Impacto do problema, incluindo como um atacante poderia explorar o problema

### O Que Esperar

Após enviar um relatório de vulnerabilidade, você pode esperar:

1. **Confirmação de recebimento** dentro de 48 horas
2. **Avaliação inicial** dentro de 5 dias úteis
3. **Atualizações regulares** sobre o progresso da correção
4. **Crédito público** pela descoberta (se desejado) após a correção ser lançada

### Política de Divulgação

- Mantenha a vulnerabilidade confidencial até que seja corrigida
- Dê-nos tempo razoável para corrigir o problema antes de divulgá-lo publicamente
- Evite explorar a vulnerabilidade além do necessário para demonstrá-la

## 🔐 Práticas de Segurança do Projeto

### Dados Sensíveis

- **NUNCA** commite credenciais, chaves de API ou tokens no repositório
- Use variáveis de ambiente para dados sensíveis
- O arquivo `supabase_config.dart` está no `.gitignore`
- Use `supabase_config.dart.example` como template

### Autenticação

- Senhas são gerenciadas pelo Supabase Auth
- Tokens de sessão são armazenados de forma segura
- Row Level Security (RLS) habilitado em todas as tabelas

### Dados do Usuário

- Coleta mínima de dados necessários
- Criptografia em trânsito (HTTPS)
- RLS garante que usuários só acessem seus próprios dados
- Opção de exclusão completa de conta disponível

### Dependências

- Dependências são revisadas regularmente
- Use `flutter pub outdated` para verificar atualizações
- Atualize dependências com vulnerabilidades conhecidas imediatamente

### API e Backend

- Supabase fornece proteção contra ataques comuns
- Row Level Security (RLS) ativo em todas as tabelas
- Validação de dados no frontend e backend
- Rate limiting configurado no Supabase

## 🛠️ Recomendações para Desenvolvedores

### Ao Desenvolver

1. **Validação de Input**: Sempre valide e sanitize inputs do usuário
2. **Autenticação**: Verifique autenticação antes de operações sensíveis
3. **Autorização**: Confirme que o usuário tem permissão para a ação
4. **Logs**: Não logue informações sensíveis
5. **Erros**: Não exponha detalhes internos em mensagens de erro ao usuário

### Antes de Fazer Deploy

1. Remova todos os `print()` e `debugPrint()` de dados sensíveis
2. Verifique que não há credenciais hardcoded
3. Confirme que RLS está ativo e funcionando
4. Teste políticas de segurança com diferentes usuários
5. Execute `flutter analyze` e corrija warnings de segurança

### Ao Configurar Supabase

1. **Habilite Row Level Security** em TODAS as tabelas
2. **Configure políticas RLS** apropriadas para cada tabela
3. **Desabilite confirmação de email** apenas em desenvolvimento
4. **Use Secrets** para chaves sensíveis, não variáveis de ambiente públicas
5. **Configure Rate Limiting** para evitar abuso

## 📚 Recursos Adicionais

- [Supabase Security Best Practices](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter Security](https://flutter.dev/docs/deployment/security)
- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)

## 🏆 Hall da Fama de Segurança

Agradecemos publicamente aos pesquisadores de segurança que nos ajudaram a manter o UNIFAZ seguro:

<!-- 
Quando alguém reportar uma vulnerabilidade de forma responsável, 
eles podem ser listados aqui (com permissão deles):

- [Nome] - [Descrição da vulnerabilidade] - [Data]
-->

*Nenhum relatório de segurança ainda. Seja o primeiro!*

---

**Obrigado por ajudar a manter o UNIFAZ seguro! 🛡️**

