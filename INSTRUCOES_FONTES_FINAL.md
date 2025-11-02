# Como Adicionar as Fontes Gliker e Garet Book

Este projeto usa **duas fontes personalizadas**:
- **Gliker** (Regular e Bold): Para títulos e headings
- **Garet Book**: Para textos normais

## Passo 1: Baixar os arquivos das fontes

### Fonte Gliker (Títulos)
Você precisará de:
- `Gliker-Regular.ttf`
- `Gliker-Bold.ttf`

### Fonte Garet Book (Texto Normal)
Você precisará de:
- `Garet-Book.ttf` ✅ (você já tem!)

## Passo 2: Criar a estrutura de pastas

No seu projeto, crie a seguinte estrutura:

```
unifaz/
├── assets/
│   ├── fonts/
│   │   ├── Gliker-Regular.ttf
│   │   ├── Gliker-Bold.ttf
│   │   └── Garet-Book.ttf          ✓ (já está!)
│   └── images/
│       └── logo.png
```

## Passo 3: Adicionar os arquivos das fontes

1. ✅ O arquivo `Garet-Book.ttf` já está em `assets/fonts/`
2. Baixe e adicione os arquivos da fonte Gliker:
   - `Gliker-Regular.ttf`
   - `Gliker-Bold.ttf`

## Passo 4: Aplicar as mudanças

Após adicionar os arquivos, execute:

```bash
flutter clean
flutter pub get
```

## Passo 5: Executar o app

```bash
flutter run
```

## Onde cada fonte será aplicada

### 📝 **Gliker (Títulos)**

#### Títulos de AppBar:
- ✅ Explorar Serviços
- ✅ Explorar Demandas
- ✅ Meus Serviços
- ✅ Minhas Demandas
- ✅ Meu Perfil
- ✅ Detalhes do Serviço
- ✅ Detalhes da Demanda
- ✅ Adicionar/Editar Serviço
- ✅ Adicionar/Editar Demanda
- ✅ Trabalhos Voluntários

#### Títulos Principais:
- ✅ "Unidos Fazemos" (Home, Login, Cadastro)
- ✅ "Criar Conta" (Cadastro)
- ✅ "Trabalhos Voluntários" (Botão destaque)
- ✅ "Navegação Rápida"
- ✅ "Como funciona?"

#### Títulos de Cards:
- ✅ Títulos de serviços
- ✅ Títulos de demandas

#### Títulos de Seções:
- ✅ "Descrição"
- ✅ "Disponibilidade"
- ✅ "Tipo de Cobrança"
- ✅ "Contato"

#### Passos e Subtítulos:
- ✅ "Cadastre-se", "Ofereça ou Solicite", "Conecte-se"

### 📖 **Garet Book (Texto Normal)**

#### Textos de Leitura:
- ✅ Descrições de serviços e demandas
- ✅ Disponibilidade
- ✅ Informações de contato
- ✅ Textos explicativos
- ✅ "Conecte. Colabore. Faça acontecer."

#### Labels e Campos:
- ✅ Labels de formulários
- ✅ Hints de input
- ✅ Textos de botões
- ✅ Mensagens de erro/sucesso

#### Informações Gerais:
- ✅ Categorias
- ✅ Localização
- ✅ Valores/orçamentos
- ✅ Datas
- ✅ Subtítulos

#### Navegação:
- ✅ Textos do Bottom Navigation
- ✅ Legendas e descrições

---

## Onde baixar as fontes

### Gliker (precisa baixar)
- [Google "Gliker font download"]
- Verifique sites de fontes como: DaFont, FontSquirrel, MyFonts
- ⚠️ **Atenção**: Verifique a licença da fonte antes de usar

### Garet Book (já está no projeto!)
- ✅ Arquivo `Garet-Book.ttf` já está em `assets/fonts/`

---

## Alternativa: Usar Google Fonts

Se você não conseguir os arquivos da fonte Gliker, pode usar uma fonte similar do Google Fonts:

### Para substituir Gliker:
- **Montserrat** (bold para títulos) ⭐ Recomendado
- **Poppins** (bold para títulos)
- **Raleway** (bold para títulos)

### Como usar Google Fonts:

1. Adicione a dependência no `pubspec.yaml`:
```yaml
dependencies:
  google_fonts: ^6.1.0
```

2. Execute:
```bash
flutter pub get
```

3. Substitua no `lib/main.dart`:
```dart
import 'package:google_fonts/google_fonts.dart';

// Nos TextStyles de títulos, substitua:
fontFamily: 'Gliker',
// por:
fontFamily: GoogleFonts.montserrat().fontFamily,
```

---

## Verificar se as fontes estão funcionando

Após executar o app, verifique:

1. **Títulos** devem aparecer com a fonte **Gliker** (visual mais display/decorativo)
2. **Textos normais** devem aparecer com a fonte **Garet Book** (visual mais limpo/legível)

Se aparecer a fonte padrão do sistema:
- ✓ Verifique se os arquivos estão na pasta `assets/fonts/`
- ✓ Verifique se os nomes dos arquivos estão corretos
- ✓ Execute `flutter clean` e `flutter pub get`
- ✓ Reinicie o app completamente (não apenas hot reload)

---

## Solução de Problemas

### Erro: "Unable to load asset"
```
✓ Verifique se os arquivos da fonte estão em assets/fonts/
✓ Verifique se os nomes dos arquivos estão exatamente como no pubspec.yaml
✓ Execute: flutter clean && flutter pub get
```

### A fonte não aparece
```
✓ Reinicie o app completamente (hot reload não funciona para fontes)
✓ Verifique se não há erros no console
✓ Confirme que o pubspec.yaml está com indentação correta
```

### Fonte não encontrada
```
✓ Certifique-se de que os arquivos .ttf estão onde especificado
✓ Verifique se o pubspec.yaml foi salvo corretamente
✓ Tente remover e adicionar os arquivos novamente
```

---

## Licenças

⚠️ **IMPORTANTE**: Antes de usar as fontes em produção:

1. ✓ Verifique a licença de cada fonte
2. ✓ Algumas fontes requerem licença comercial
3. ✓ Certifique-se de ter direito de uso
4. ✓ Considere fontes open-source como alternativa segura

---

## Estrutura Final

Após configurar tudo, sua estrutura deve ficar assim:

```
unifaz/
├── assets/
│   ├── fonts/
│   │   ├── Gliker-Regular.ttf      ← Adicionar
│   │   ├── Gliker-Bold.ttf         ← Adicionar
│   │   └── Garet-Book.ttf          ✓ (já está!)
│   └── images/
│       └── logo.png                ✓
├── lib/
│   └── main.dart                   ✓ (configurado)
└── pubspec.yaml                    ✓ (configurado)
```

---

## Configuração no código

O código já está **100% configurado**! 🎉

No `pubspec.yaml`:
```yaml
fonts:
  - family: Gliker
    fonts:
      - asset: assets/fonts/Gliker-Regular.ttf
      - asset: assets/fonts/Gliker-Bold.ttf
        weight: 700
  - family: Garet
    fonts:
      - asset: assets/fonts/Garet-Book.ttf
```

No `lib/main.dart`:
```dart
fontFamily: 'Garet',  // Padrão para textos normais
textTheme: TextTheme(
  titleLarge: TextStyle(fontFamily: 'Gliker'),   // Títulos
  headlineLarge: TextStyle(fontFamily: 'Gliker'), // Títulos grandes
  bodyLarge: TextStyle(fontFamily: 'Garet'),      // Textos normais
  // ... etc
),
```

---

## Resumo

🎨 **Gliker**: Títulos, Headings, AppBars  
📖 **Garet Book**: Textos normais, Parágrafos, Labels

**O que falta**: Apenas adicionar os arquivos `Gliker-Regular.ttf` e `Gliker-Bold.ttf` na pasta `assets/fonts/`! ✨

---

## Próximos passos:

1. ✅ `Garet-Book.ttf` já está no projeto
2. 📥 Baixe a fonte Gliker (Regular e Bold)
3. 📁 Adicione os arquivos `.ttf` em `assets/fonts/`
4. 🚀 Execute `flutter clean && flutter pub get && flutter run`

Pronto! 🎉

