# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Planejado
- Sistema de mensagens entre usuários
- Avaliações e comentários
- Upload de imagens para serviços/demandas
- Sistema de favoritos
- Notificações push
- Modo escuro

## [1.0.0] - 2025-11-02

### 🎉 Lançamento Inicial

#### Adicionado
- Sistema completo de autenticação (login, cadastro, recuperação de senha)
- CRUD de serviços oferecidos
- CRUD de demandas solicitadas
- Busca avançada com filtros por:
  - Categoria (79 categorias em 8 grupos)
  - Localização (estado e cidade)
  - Tipo de cobrança
  - Urgência (para demandas)
- Perfil pessoal editável
- Perfis públicos de prestadores e solicitantes
- Integração com ViaCEP para busca automática de endereço
- Seção dedicada para trabalho voluntário
- Sistema de categorias hierárquico
- Priorização de demandas urgentes nos resultados de busca
- Avisos de segurança contra golpes
- Splash screen customizada
- Interface responsiva com design moderno
- Loading states e feedback visual
- Validação de formulários

#### Funcionalidades de Segurança
- Row Level Security (RLS) habilitado no Supabase
- Políticas de acesso por usuário
- Validação de dados no frontend
- Opção de exclusão de conta com confirmação dupla
- Trigger de exclusão em cascata para dados relacionados

#### Design
- Paleta de cores harmônica com verde como cor principal (#87a492)
- Logo customizado integrado
- Badges visuais para trabalho voluntário
- Indicadores de urgência com cores específicas
- Ícones intuitivos com Font Awesome
- Animações de carregamento com SpinKit

#### Integrações
- Supabase para autenticação e banco de dados
- ViaCEP para busca de endereços
- IBGE (indiretamente via LocationService) para estados e cidades

#### Documentação
- README completo com instruções de instalação
- Guia de contribuição (CONTRIBUTING.md)
- Documentação do sistema de design
- Scripts SQL para configuração do banco
- Documentação de segurança (SECURITY.md)
- Licença MIT

#### Infraestrutura
- Configuração de .gitignore para arquivos sensíveis
- .gitattributes para line endings consistentes
- Exemplo de configuração do Supabase
- Scripts de migração do banco de dados

---

## Tipos de Mudanças

- `Added` - para novas funcionalidades
- `Changed` - para mudanças em funcionalidades existentes
- `Deprecated` - para funcionalidades que serão removidas
- `Removed` - para funcionalidades removidas
- `Fixed` - para correções de bugs
- `Security` - para vulnerabilidades de segurança

---

## Links

- [Unreleased]: https://github.com/seu-usuario/unifaz/compare/v1.0.0...HEAD
- [1.0.0]: https://github.com/seu-usuario/unifaz/releases/tag/v1.0.0

