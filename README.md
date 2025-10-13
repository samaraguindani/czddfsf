# UNIFAZ - Aplicativo de Conectividade de Serviços

## Descrição
O UNIFAZ é um aplicativo Flutter completo que conecta pessoas que oferecem serviços autônomos ou voluntários com pessoas que procuram esses serviços. O aplicativo utiliza o Supabase como backend para autenticação e armazenamento de dados.

## Funcionalidades

### Autenticação
- ✅ Cadastro de usuários com validação
- ✅ Login com e-mail e senha
- ✅ Recuperação de senha
- ✅ Logout seguro

### Gestão de Serviços
- ✅ Cadastro de serviços oferecidos
- ✅ Edição e exclusão de serviços
- ✅ Exploração pública de serviços
- ✅ Filtros por categoria, tipo de cobrança e localização
- ✅ Busca por texto

### Gestão de Pedidos
- ✅ Cadastro de pedidos de serviços
- ✅ Edição e exclusão de pedidos
- ✅ Exploração pública de pedidos
- ✅ Filtros por categoria, tipo de cobrança e localização
- ✅ Busca por texto

### Perfil do Usuário
- ✅ Visualização e edição de dados pessoais
- ✅ Integração com API do IBGE para estados e cidades
- ✅ Gestão de endereço completo

### Interface
- ✅ Design moderno e responsivo
- ✅ Navegação por bottom navigation bar
- ✅ Feedback visual (loading, erros, sucessos)
- ✅ Validação de formulários

## Configuração do Projeto

### 1. Dependências
O projeto já está configurado com todas as dependências necessárias no `pubspec.yaml`:
- `supabase_flutter`: Para integração com Supabase
- `provider`: Para gerenciamento de estado
- `http`: Para requisições HTTP
- `form_field_validator`: Para validação de formulários
- `flutter_spinkit`: Para indicadores de carregamento
- `font_awesome_flutter`: Para ícones
- `intl`: Para formatação de datas

### 2. Configuração do Supabase

#### 2.1 Criar Projeto no Supabase
1. Acesse [supabase.com](https://supabase.com)
2. Crie uma nova conta ou faça login
3. Crie um novo projeto
4. Anote a URL do projeto e a chave anônima

#### 2.2 Configurar Credenciais
Edite o arquivo `lib/services/supabase_config.dart` e substitua:
```dart
static const String url = 'https://your-project-id.supabase.co';
static const String anonKey = 'your-anon-key-here';
```

#### 2.3 Criar Tabelas no Banco de Dados

Execute os seguintes comandos SQL no editor SQL do Supabase:

```sql
-- Tabela de usuários (perfil)
CREATE TABLE users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
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

-- Tabela de serviços
CREATE TABLE services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  availability TEXT NOT NULL,
  value DECIMAL(10,2),
  pricing_type TEXT NOT NULL,
  contact TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de pedidos
CREATE TABLE requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  urgency TEXT NOT NULL,
  budget DECIMAL(10,2),
  pricing_type TEXT NOT NULL,
  contact TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Políticas de segurança (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;

-- Políticas para usuários
CREATE POLICY "Users can view own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para serviços
CREATE POLICY "Anyone can view services" ON services
  FOR SELECT USING (true);

CREATE POLICY "Users can insert own services" ON services
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own services" ON services
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own services" ON services
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas para pedidos
CREATE POLICY "Anyone can view requests" ON requests
  FOR SELECT USING (true);

CREATE POLICY "Users can insert own requests" ON requests
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own requests" ON requests
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own requests" ON requests
  FOR DELETE USING (auth.uid() = user_id);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para atualizar updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_requests_updated_at BEFORE UPDATE ON requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 3. Executar o Aplicativo

```bash
# Instalar dependências
flutter pub get

# Executar o aplicativo
flutter run
```

## Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── user.dart
│   ├── service.dart
│   ├── request.dart
│   └── location.dart
├── services/                 # Serviços de integração
│   ├── supabase_config.dart
│   ├── auth_service.dart
│   ├── service_service.dart
│   ├── request_service.dart
│   └── location_service.dart
├── providers/                # Gerenciamento de estado
│   ├── auth_provider.dart
│   ├── service_provider.dart
│   └── request_provider.dart
├── pages/                    # Telas da aplicação
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── forgot_password_screen.dart
│   ├── home_screen.dart
│   ├── explore_services_screen.dart
│   ├── explore_requests_screen.dart
│   ├── my_services_screen.dart
│   ├── my_requests_screen.dart
│   ├── profile_screen.dart
│   ├── service_form_screen.dart
│   ├── service_detail_screen.dart
│   ├── request_form_screen.dart
│   └── request_detail_screen.dart
└── widgets/                  # Componentes reutilizáveis
    ├── common_widgets.dart
    ├── service_card.dart
    ├── request_card.dart
    └── filter_bottom_sheet.dart
```

## Funcionalidades Implementadas

### ✅ Completas
- Sistema de autenticação completo
- CRUD de serviços e pedidos
- Exploração pública com filtros
- Gestão de perfil com integração IBGE
- Interface responsiva e moderna
- Validação de formulários
- Feedback visual para o usuário

### 🔄 Melhorias Futuras
- Sistema de mensagens entre usuários
- Avaliações e comentários
- Notificações push
- Geolocalização automática
- Upload de imagens
- Sistema de favoritos
- Chat em tempo real

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Supabase**: Backend como serviço (BaaS)
- **Provider**: Gerenciamento de estado
- **HTTP**: Requisições para API do IBGE
- **Material Design**: Design system

## Suporte

Para dúvidas ou problemas:
1. Verifique se as credenciais do Supabase estão corretas
2. Confirme se as tabelas foram criadas corretamente
3. Verifique se as políticas RLS estão ativas
4. Execute `flutter clean` e `flutter pub get` se houver problemas de dependências

## Licença

Este projeto foi desenvolvido como demonstração de um aplicativo completo em Flutter com integração Supabase.