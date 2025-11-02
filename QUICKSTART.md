# ⚡ Guia de Início Rápido - UNIFAZ

Este guia vai te ajudar a ter o UNIFAZ rodando em minutos!

## 📋 Pré-requisitos Rápidos

```bash
# Verificar se Flutter está instalado
flutter --version

# Deve retornar versão 3.x ou superior
```

Não tem Flutter? [Instale aqui](https://flutter.dev/docs/get-started/install) ⚡

## 🚀 5 Passos para Rodar

### 1️⃣ Clone o Repositório

```bash
git clone https://github.com/seu-usuario/unifaz.git
cd unifaz
```

### 2️⃣ Instale as Dependências

```bash
flutter pub get
```

### 3️⃣ Configure o Supabase

**Opção A: Usar configuração de exemplo (apenas para testes)**

```bash
cp lib/services/supabase_config.dart.example lib/services/supabase_config.dart
```

**Opção B: Criar seu próprio projeto (recomendado)**

1. Acesse [supabase.com](https://supabase.com) e crie uma conta
2. Crie um novo projeto
3. Copie a URL e a chave anon
4. Cole em `lib/services/supabase_config.dart`:

```dart
static const String url = 'https://seu-projeto.supabase.co';
static const String anonKey = 'sua-chave-aqui';
```

### 4️⃣ Configure o Banco (se criar seu próprio Supabase)

No dashboard do Supabase:

1. Vá em **SQL Editor**
2. Execute os scripts nesta ordem:
   - `docs/database/01_initial_setup.sql`
   - `docs/database/supabase_migration_user_profile.sql`
   - `docs/database/supabase_add_voluntary_field.sql`
   - `docs/database/supabase_delete_account_trigger.sql`

Ou copie e cole todo o conteúdo de uma vez! 🎯

### 5️⃣ Execute o App

```bash
# Ver dispositivos disponíveis
flutter devices

# Rodar no dispositivo/emulador
flutter run
```

## 🎉 Pronto!

Você deve ver a tela de splash do UNIFAZ! 

### Testando

1. Clique em **"Criar Conta"**
2. Preencha os dados
3. Faça login
4. Explore os serviços e demandas de exemplo

## 🐛 Problemas Comuns

### "No devices found"

```bash
# Android: Certifique-se de ter um emulador rodando ou dispositivo conectado
flutter emulators --launch <emulator_id>

# iOS (Mac): Abra o simulador
open -a Simulator
```

### "Gradle build failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "Supabase connection failed"

- Verifique se a URL e chave estão corretas
- Certifique-se de que o projeto Supabase está ativo
- Verifique sua conexão com a internet

### "RLS policy error"

- Execute os scripts SQL do passo 4
- Certifique-se de que RLS está habilitado
- Verifique se as políticas foram criadas

## 📱 Dispositivos Recomendados

### Para Desenvolvimento

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Emulador Android**: Pixel 5 ou superior
- **Simulador iOS**: iPhone 14 ou superior

### Para Testes

Teste em pelo menos:
- 1 dispositivo Android físico
- 1 dispositivo iOS físico (se possível)
- 1 tablet (para verificar responsividade)

## 🔧 Comandos Úteis

```bash
# Verificar problemas
flutter analyze

# Formatar código
dart format .

# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade

# Ver logs detalhados
flutter run -v

# Build para release (Android)
flutter build apk --release

# Build para release (iOS)
flutter build ios --release
```

## 📚 Próximos Passos

Agora que está rodando, explore:

1. 📖 [README.md](README.md) - Documentação completa
2. 🎨 [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) - Guia de design
3. 🤝 [CONTRIBUTING.md](CONTRIBUTING.md) - Como contribuir
4. 📋 [CATEGORIES.md](docs/CATEGORIES.md) - Lista de categorias
5. 🗂️ [DATABASE_SETUP.md](docs/DATABASE_SETUP.md) - Detalhes do banco

## 💡 Dicas Pro

### Hot Reload

Após fazer mudanças no código:
- Pressione `r` no terminal para hot reload
- Pressione `R` para hot restart
- Pressione `q` para quit

### Debug Mode

O app mostra informações de debug no console. Procure por:
- `✅` - Operações bem-sucedidas
- `❌` - Erros
- `⚠️` - Avisos

### Supabase Dashboard

Acesse o dashboard para:
- Ver dados em tempo real
- Executar queries SQL
- Monitorar autenticação
- Verificar logs de API

## 🆘 Precisa de Ajuda?

- 📖 Leia a [documentação completa](README.md)
- 🐛 [Reporte bugs](../../issues/new?template=bug_report.md)
- 💬 [Faça perguntas](../../issues/new?template=question.md)
- 📧 Email: contato@unifaz.com

## ⭐ Gostou?

Se este projeto foi útil, considere:
- Dar uma ⭐ no repositório
- Compartilhar com amigos
- Contribuir com código
- Reportar bugs

---

<div align="center">
  <strong>Happy Coding! 🚀</strong>
  <br>
  <sub>Qualquer dúvida, estamos aqui para ajudar!</sub>
</div>

