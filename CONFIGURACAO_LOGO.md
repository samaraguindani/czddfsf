# Configuração da Logo UNIFAZ

## ✅ Implementado

- ✅ Estrutura de assets criada
- ✅ Tela de splash screen com animação
- ✅ Logo configurada no app (assets)
- ✅ Navegação automática após splash

## 📋 Passos para Adicionar a Logo

### 1. Salvar a Imagem da Logo

**Salve a imagem circular verde com o aperto de mãos e texto "unifaz" em:**
```
assets/images/logo.png
```

**Importante:**
- A imagem deve ser PNG com fundo transparente (ou branco)
- Tamanho recomendado: 512x512 pixels ou maior
- Formato quadrado para melhor visualização

### 2. Configurar Ícone do Aplicativo (Android e iOS)

Para configurar o ícone do app, você pode usar o pacote `flutter_launcher_icons`:

#### Adicionar ao `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo.png"
  adaptive_icon_background: "#7FA99B"  # Cor verde da logo
  adaptive_icon_foreground: "assets/images/logo.png"
```

#### Executar os comandos:

```bash
# Instalar dependências
flutter pub get

# Gerar ícones
flutter pub run flutter_launcher_icons
```

### 3. Testar a Splash Screen

Execute o app e você verá:
1. Logo animada (fade + escala)
2. Nome "UNIFAZ"
3. Slogan "Unidos Fazemos"
4. Indicador de carregamento
5. Navegação automática para login ou home (se já autenticado)

## 🎨 Customizações Disponíveis

### Alterar Cores do Gradiente

Em `lib/pages/splash_screen.dart`, linha 81-85:

```dart
colors: [
  Colors.blue[600]!,     // Cor superior
  Colors.purple[600]!,   // Cor inferior
],
```

### Alterar Duração da Splash

Em `lib/pages/splash_screen.dart`, linha 53:

```dart
await Future.delayed(const Duration(seconds: 3)); // Alterar aqui
```

### Alterar Tamanho da Logo

Em `lib/pages/splash_screen.dart`, linha 90-91:

```dart
width: 200,   // Alterar largura
height: 200,  // Alterar altura
```

## 📱 Estrutura Criada

```
unifaz/
├── assets/
│   └── images/
│       └── logo.png  ⬅️ ADICIONE A IMAGEM AQUI
├── lib/
│   ├── main.dart (✅ atualizado)
│   └── pages/
│       └── splash_screen.dart (✅ novo)
└── pubspec.yaml (✅ atualizado)
```

## 🚀 Como Funciona

1. **App inicia** → Mostra `SplashScreen`
2. **SplashScreen** → Anima logo e verifica autenticação
3. **Após 3 segundos** → Navega para:
   - `LoginScreen` (se não autenticado)
   - `HomeScreen` (se autenticado)

## 🎯 Próximos Passos

1. ✅ Salve a imagem da logo em `assets/images/logo.png`
2. ✅ Execute `flutter pub get`
3. ✅ Teste o app e veja a splash screen
4. 🔲 (Opcional) Configure os ícones do launcher usando `flutter_launcher_icons`

## 💡 Dica

Se a logo não aparecer, verifique:
- O arquivo está no caminho correto
- O nome do arquivo é exatamente `logo.png`
- Você executou `flutter pub get` após editar o `pubspec.yaml`

