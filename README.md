<div align="center">
  <img src="assets/images/logo.png" alt="UNIFAZ Logo" width="150"/>
  
  # UNIFAZ - Unidos Fazemos
  
  ### Conecte. Colabore. Faça acontecer.
  
  <p align="center">
    <strong>Plataforma de conexão entre prestadores de serviços e solicitantes</strong>
  </p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
  [![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
  
</div>

---

## 📖 Sobre o Projeto

**UNIFAZ** é uma plataforma mobile desenvolvida em Flutter que conecta pessoas que oferecem serviços com aquelas que precisam deles. Com foco em acessibilidade e comunidade, o app permite tanto serviços pagos quanto trabalho voluntário, facilitando a colaboração e o crescimento econômico local.

### ✨ Principais Funcionalidades

- 🔐 **Autenticação Segura** - Sistema completo de login, cadastro e recuperação de senha
- 🛠️ **Gestão de Serviços** - Publique, edite e explore serviços oferecidos pela comunidade
- 🤝 **Demandas** - Publique necessidades e encontre profissionais qualificados
- ❤️ **Trabalho Voluntário** - Seção dedicada para conexões solidárias
- 🔍 **Busca Avançada** - Filtros por categoria, localização, urgência e tipo de cobrança
- 👤 **Perfis Públicos** - Visualize informações de prestadores e solicitantes
- 🗺️ **Integração Geográfica** - Busca por estado e cidade com integração ViaCEP
- 🎨 **Interface Moderna** - Design intuitivo e responsivo


## 🏗️ Arquitetura do Projeto

```
lib/
├── main.dart                      # Ponto de entrada da aplicação
├── models/                        # Modelos de dados
│   ├── user.dart                  # Modelo de usuário
│   ├── service.dart               # Modelo de serviço
│   ├── request.dart               # Modelo de demanda
│   ├── location.dart              # Modelo de localização
│   └── enums.dart                 # Enumerações (categorias, urgências, etc.)
├── services/                      # Camada de serviços
│   ├── supabase_config.dart       # Configuração do Supabase
│   ├── auth_service.dart          # Serviço de autenticação
│   ├── service_service.dart       # CRUD de serviços
│   ├── request_service.dart       # CRUD de demandas
│   └── location_service.dart      # Integração com APIs de localização
├── providers/                     # Gerenciamento de estado (Provider)
│   ├── auth_provider.dart         # Estado de autenticação
│   ├── service_provider.dart      # Estado de serviços
│   └── request_provider.dart      # Estado de demandas
├── pages/                         # Telas da aplicação
│   ├── splash_screen.dart         # Tela de carregamento inicial
│   ├── login_screen.dart          # Tela de login
│   ├── signup_screen.dart         # Tela de cadastro
│   ├── forgot_password_screen.dart # Recuperação de senha
│   ├── home_screen.dart           # Tela principal com navegação
│   ├── explore_services_screen.dart # Exploração de serviços
│   ├── explore_requests_screen.dart # Exploração de demandas
│   ├── my_services_screen.dart    # Meus serviços publicados
│   ├── my_requests_screen.dart    # Minhas demandas publicadas
│   ├── volunteer_screen.dart      # Trabalhos voluntários
│   ├── profile_screen.dart        # Perfil do usuário logado
│   ├── user_profile_screen.dart   # Perfil público de outros usuários
│   ├── service_form_screen.dart   # Formulário de serviço
│   ├── service_detail_screen.dart # Detalhes do serviço
│   ├── request_form_screen.dart   # Formulário de demanda
│   └── request_detail_screen.dart # Detalhes da demanda
└── widgets/                       # Componentes reutilizáveis
    ├── common_widgets.dart        # Widgets comuns (Loading, Error, Empty)
    ├── service_card.dart          # Card de serviço
    ├── request_card.dart          # Card de demanda
    └── filter_bottom_sheet.dart   # Bottom sheet de filtros
```

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Descrição | Documentação |
|-----------|-----------|--------------|
| **Flutter** | Framework multiplataforma para desenvolvimento mobile | [Docs](https://flutter.dev/docs) |
| **Dart** | Linguagem de programação | [Docs](https://dart.dev/guides) |
| **Supabase** | Backend as a Service (BaaS) com PostgreSQL | [Docs](https://supabase.com/docs) |
| **Provider** | Gerenciamento de estado reativo | [Docs](https://pub.dev/packages/provider) |
| **HTTP** | Requisições para APIs externas | [Docs](https://pub.dev/packages/http) |
| **Font Awesome** | Biblioteca de ícones | [Docs](https://pub.dev/packages/font_awesome_flutter) |
| **Flutter SpinKit** | Animações de carregamento | [Docs](https://pub.dev/packages/flutter_spinkit) |

---

## 🎯 Funcionalidades Detalhadas

### 🔐 Autenticação
- Cadastro de novos usuários com validação completa
- Login seguro com email e senha
- Recuperação de senha via email
- Persistência de sessão
- Logout com confirmação

### 🛠️ Serviços
- Publicação de serviços com múltiplas categorias hierárquicas
- Edição e exclusão de serviços próprios
- Exploração pública com busca por texto
- Filtros por categoria, cidade, estado e tipo de cobrança
- Visualização detalhada com informações de contato
- Badge especial para trabalho voluntário

### 🤝 Demandas
- Publicação de necessidades com classificação de urgência
- Sistema de priorização (urgente > médio > baixo)
- Filtros avançados por localização e categoria
- Seção dedicada para voluntariado
- Orçamento flexível ou trabalho voluntário

### 👤 Perfis
- Perfil pessoal editável
- Perfis públicos para visualização
- Integração automática de endereço por CEP
- Informações de contato
- Histórico de serviços e demandas publicados
- Opção de exclusão de conta com confirmação dupla

### 🔍 Busca e Filtros
- Busca por texto livre
- Filtro por estado e cidade
- Filtro por categoria (79 categorias em 8 grupos)
- Filtro por tipo de cobrança
- Filtro por urgência (demandas)
- Indicador visual de filtros ativos

### 🛡️ Segurança
- Row Level Security (RLS) no Supabase
- Validação de dados no frontend e backend
- Proteção de rotas e dados sensíveis
- Avisos sobre golpes nas telas de exploração

---

## 📂 Banco de Dados

### Políticas RLS

Todas as tabelas possuem Row Level Security habilitado com políticas para:
- ✅ Qualquer pessoa pode visualizar serviços e demandas
- ✅ Usuários podem visualizar e editar apenas seus próprios dados
- ✅ Usuários podem criar novos registros associados a eles
- ✅ Usuários podem excluir apenas seus próprios registros

---

## 🎨 Design e UX

### Paleta de Cores

| Cor | Hex | Uso |
|-----|-----|-----|
| **Verde Principal** | `#87a492` | Botões primários, FABs, ícones principais |
| **Verde Escuro** | `#5a7a6a` | AppBars, cabeçalhos, botões secundários |
| **Dourado Suave** | `#c9a56f` | Valores monetários, ícones de destaque |
| **Coral** | `#d68a7a` | Urgente, ações de exclusão |
| **Mostarda** | `#ddb87a` | Urgência média |
| **Verde Claro** | `#a8c9a4` | Urgência baixa, sucesso |

### Componentes Reutilizáveis
- `LoadingWidget` - Indicador de carregamento com animação
- `CustomErrorWidget` - Tela de erro com ação de retry
- `EmptyWidget` - Estado vazio com mensagem personalizada
- `ServiceCard` - Card de serviço com ações
- `RequestCard` - Card de demanda com ações

---

## 📝 Roadmap

### ✅ Concluído
- [x] Sistema de autenticação completo
- [x] CRUD de serviços e demandas
- [x] Busca e filtros avançados
- [x] Perfis públicos
- [x] Trabalho voluntário
- [x] Integração geográfica (CEP/IBGE)
- [x] Avisos de segurança

### 🚧 Próximas Funcionalidades
- [ ] Sistema de mensagens entre usuários
- [ ] Avaliações e comentários
- [ ] Notificações push
- [ ] Upload de imagens para serviços/demandas
- [ ] Histórico de transações
- [ ] Sistema de reputação
- [ ] Modo escuro

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👥 Autores

João Felipe Oliveira Deconto
Samara Lazzarotto Guindani
Desenvolvido com ❤️ pela equipe UNIFAZ

---

<div align="center">
  <strong>🌟 Se este projeto foi útil, considere dar uma estrela! 🌟</strong>
  <br>
  <sub>Feito com Flutter e muito ☕</sub>
</div>
