# Contribuindo para o UNIFAZ

Primeiramente, obrigado por considerar contribuir para o UNIFAZ! 🎉

Este documento fornece diretrizes para contribuir com o projeto. Seguir estas diretrizes ajuda a comunicar que você respeita o tempo dos desenvolvedores que gerenciam e desenvolvem este projeto open source.

## 📋 Índice

- [Código de Conduta](#código-de-conduta)
- [Como Posso Contribuir?](#como-posso-contribuir)
- [Diretrizes de Estilo](#diretrizes-de-estilo)
- [Processo de Pull Request](#processo-de-pull-request)
- [Configuração do Ambiente de Desenvolvimento](#configuração-do-ambiente-de-desenvolvimento)

## 📜 Código de Conduta

Este projeto e todos os participantes dele são regidos por um código de conduta. Ao participar, espera-se que você mantenha este código. Por favor, reporte comportamentos inaceitáveis.

## 🤔 Como Posso Contribuir?

### Reportando Bugs

Bugs são rastreados como issues do GitHub. Antes de criar uma issue:

1. **Verifique se o bug já não foi reportado** procurando nas issues existentes
2. Se não encontrar uma issue aberta, [crie uma nova](../../issues/new)
3. Inclua um **título claro e descritivo**
4. Descreva os **passos exatos para reproduzir o problema**
5. Forneça **exemplos específicos** quando possível
6. Descreva o **comportamento observado** e o **comportamento esperado**
7. Inclua **screenshots** se relevante
8. Mencione a **versão do Flutter** e do **dispositivo/emulador**

### Sugerindo Melhorias

Melhorias também são rastreadas como issues. Ao criar uma issue de melhoria:

1. Use um **título claro e descritivo**
2. Forneça uma **descrição detalhada da melhoria sugerida**
3. Explique **por que essa melhoria seria útil**
4. Liste alguns **exemplos** de como a feature funcionaria
5. Inclua **mockups ou wireframes** se possível

### Contribuindo com Código

Não sabe por onde começar? Você pode começar procurando por issues marcadas com:

- `good first issue` - issues que devem ser relativamente simples
- `help wanted` - issues que precisam de atenção

#### Fluxo de Trabalho Local

1. **Fork o repositório** e crie uma branch a partir de `main`
2. **Instale as dependências**: `flutter pub get`
3. **Faça suas mudanças** seguindo as [diretrizes de estilo](#diretrizes-de-estilo)
4. **Teste suas mudanças** em múltiplos dispositivos/emuladores
5. **Commit suas mudanças** com mensagens de commit descritivas
6. **Push para sua fork** e submeta um pull request

## 🎨 Diretrizes de Estilo

### Código Dart/Flutter

- Siga o [Effective Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` para verificar problemas de análise estática
- Use `dart format` para formatar o código
- Mantenha as funções pequenas e focadas
- Comente código complexo quando necessário
- Use nomes de variáveis descritivos

### Estrutura de Arquivos

```dart
// Ordem de imports
import 'dart:async';  // Dart SDK
import 'package:flutter/material.dart';  // Flutter
import 'package:provider/provider.dart';  // Packages externos
import '../models/user.dart';  // Imports locais
```

### Convenções de Nomenclatura

- **Classes**: `PascalCase` (ex: `ServiceCard`, `AuthProvider`)
- **Arquivos**: `snake_case` (ex: `service_card.dart`, `auth_provider.dart`)
- **Variáveis/Funções**: `camelCase` (ex: `userName`, `getUserProfile()`)
- **Constantes**: `lowerCamelCase` (ex: `primaryColor`, `maxLength`)
- **Privados**: prefixo `_` (ex: `_privateMethod`, `_internalState`)

### Widgets

- Prefira widgets `StatelessWidget` quando não houver estado
- Extraia widgets complexos em componentes separados
- Use `const` construtores sempre que possível para performance
- Mantenha o método `build()` limpo e legível

### Commits

Formato de mensagem de commit:

```
tipo(escopo): descrição curta

Descrição mais longa e detalhada, se necessário.

Closes #123
```

**Tipos:**
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `docs`: mudanças em documentação
- `style`: formatação, ponto e vírgula, etc (sem mudança de código)
- `refactor`: refatoração de código
- `test`: adição ou refatoração de testes
- `chore`: atualização de tarefas, configurações, etc

**Exemplos:**
```
feat(auth): adiciona recuperação de senha via email

fix(services): corrige filtro por cidade
Corrige bug onde o filtro de cidade não era aplicado corretamente
na busca de serviços.

Closes #45
```

## 🔄 Processo de Pull Request

1. **Atualize o README.md** com detalhes das mudanças, se relevante
2. **Atualize a documentação** relacionada às suas mudanças
3. **Garanta que todos os testes passem** e o código esteja formatado
4. **Referencie a issue** relacionada no PR
5. **Aguarde o review** - mantenha a discussão respeitosa e construtiva

### Checklist do Pull Request

- [ ] Meu código segue as diretrizes de estilo deste projeto
- [ ] Realizei uma auto-revisão do meu código
- [ ] Comentei código em áreas particularmente complexas
- [ ] Fiz mudanças correspondentes na documentação
- [ ] Minhas mudanças não geram novos warnings
- [ ] Testei em múltiplos dispositivos/emuladores
- [ ] Referenciei a issue relacionada

## 🛠️ Configuração do Ambiente de Desenvolvimento

### Requisitos

- Flutter SDK 3.x ou superior
- Dart SDK (incluído no Flutter)
- Editor de código (VS Code ou Android Studio recomendados)
- Git

### Setup

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/unifaz.git
   cd unifaz
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Configure o Supabase:
   - Copie `lib/services/supabase_config.dart.example` para `supabase_config.dart`
   - Adicione suas credenciais

4. Execute o app:
   ```bash
   flutter run
   ```

### Comandos Úteis

```bash
# Verificar problemas
flutter analyze

# Formatar código
dart format .

# Limpar build
flutter clean

# Ver devices disponíveis
flutter devices

# Executar em dispositivo específico
flutter run -d <device-id>
```

## 📚 Recursos Adicionais

- [Documentação do Flutter](https://flutter.dev/docs)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Provider Package](https://pub.dev/packages/provider)
- [Supabase Docs](https://supabase.com/docs)

## ❓ Dúvidas?

Se tiver alguma dúvida, sinta-se à vontade para:
- Abrir uma issue com a tag `question`
- Entrar em contato com os mantenedores
- Consultar a documentação existente

---

**Obrigado por contribuir! 🚀**

Cada contribuição, não importa quão pequena, ajuda a tornar o UNIFAZ melhor para todos.

