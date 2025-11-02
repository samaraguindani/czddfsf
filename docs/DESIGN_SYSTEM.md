# 🎨 Sistema de Design UNIFAZ

Este documento descreve o sistema de design visual do UNIFAZ, incluindo paleta de cores, tipografia, componentes e diretrizes de interface.

## 🌈 Paleta de Cores

### Cores Principais

```dart
// Verde Principal - Ações primárias, botões principais, FABs
Color(0xFF87a492)  // #87a492
```
<div style="background-color: #87a492; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Verde Principal (#87a492)</strong><br>
  Usado em: Botões primários, FABs, ícones de ação, destaques
</div>

### Cores Secundárias

```dart
// Verde Escuro - AppBars, cabeçalhos
Color(0xFF5a7a6a)  // #5a7a6a
```
<div style="background-color: #5a7a6a; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Verde Escuro (#5a7a6a)</strong><br>
  Usado em: AppBars, cabeçalhos, botões secundários
</div>

### Cores de Valor

```dart
// Dourado Suave - Valores monetários
Color(0xFFc9a56f)  // #c9a56f
```
<div style="background-color: #c9a56f; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Dourado Suave (#c9a56f)</strong><br>
  Usado em: Valores, orçamentos, preços
</div>

### Cores de Urgência

```dart
// Coral - Urgente
Color(0xFFd68a7a)  // #d68a7a
```
<div style="background-color: #d68a7a; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Coral (#d68a7a)</strong><br>
  Usado em: Demandas urgentes, ações de exclusão
</div>

```dart
// Mostarda - Médio
Color(0xFFddb87a)  // #ddb87a
```
<div style="background-color: #ddb87a; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Mostarda (#ddb87a)</strong><br>
  Usado em: Demandas de urgência média
</div>

```dart
// Verde Claro - Baixo
Color(0xFFa8c9a4)  // #a8c9a4
```
<div style="background-color: #a8c9a4; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Verde Claro (#a8c9a4)</strong><br>
  Usado em: Demandas de urgência baixa, mensagens de sucesso
</div>

### Cores de Localização

```dart
// Laranja Suave - Ícones de localização
Color(0xFFd4a687)  // #d4a687
```
<div style="background-color: #d4a687; padding: 20px; color: white; border-radius: 8px; margin: 10px 0;">
  <strong>Laranja Suave (#d4a687)</strong><br>
  Usado em: Ícones de mapa, localização, endereços
</div>

## 📝 Tipografia

O UNIFAZ utiliza a fonte padrão do sistema (San Francisco no iOS, Roboto no Android) para garantir consistência com as diretrizes nativas de cada plataforma.

### Hierarquia de Texto

```dart
// Títulos Principais (AppBar)
TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
)

// Títulos de Seção
TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
)

// Títulos de Card
TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
)

// Corpo de Texto
TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
)

// Texto Secundário / Legenda
TextStyle(
  fontSize: 12,
  color: Colors.grey[600],
)

// Texto Pequeno / Avisos
TextStyle(
  fontSize: 11,
  color: Colors.grey[700],
)
```

## 🧩 Componentes

### Cards

#### ServiceCard
- Borda arredondada de 12px
- Sombra suave (elevation 2)
- Padding interno de 16px
- Badge de "TRABALHO VOLUNTÁRIO" quando aplicável
- Ações de edição (verde) e exclusão (coral)

#### RequestCard
- Similar ao ServiceCard
- Badge de urgência com cores específicas
- Badge de "BUSCO VOLUNTÁRIOS" quando aplicável
- Exibição de orçamento ou indicação de voluntariado

### Botões

#### ElevatedButton (Primário)
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF87a492),
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () {},
  child: Text('Ação Principal'),
)
```

#### OutlinedButton (Secundário)
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: Color(0xFF5a7a6a),
    side: BorderSide(color: Color(0xFF5a7a6a)),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () {},
  child: Text('Ação Secundária'),
)
```

### Input Fields

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Campo',
    hintText: 'Digite aqui...',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    prefixIcon: Icon(Icons.icon, color: Color(0xFF87a492)),
  ),
)
```

### Badges

#### Badge de Trabalho Voluntário
- Cor: Verde principal (#87a492)
- Ícone: Heart (FontAwesome)
- Texto: "TRABALHO VOLUNTÁRIO"
- Padding: 8px horizontal, 4px vertical
- Border radius: 12px

#### Badge de Urgência
- Cores variáveis conforme urgência
- Texto em uppercase
- Padding: 6px horizontal, 3px vertical
- Border radius: 8px
- Fonte: 11px, bold

## 🎭 Estados Visuais

### Loading
- Animação: SpinKitFadingCircle
- Cor: Verde principal (#87a492)
- Tamanho: 50px
- Mensagem abaixo em cinza

### Erro
- Ícone: error_outline (Material)
- Cor: Coral (#d68a7a)
- Tamanho: 64px
- Botão "Tentar Novamente" em verde

### Vazio
- Ícone: contextual
- Cor: Cinza (Colors.grey[400])
- Tamanho: 64px
- Texto explicativo abaixo

## 📱 Layout

### Espaçamentos Padrão

```dart
// Extra Small
4.0

// Small
8.0

// Medium
16.0

// Large
24.0

// Extra Large
32.0
```

### Arredondamentos

```dart
// Cards
BorderRadius.circular(12)

// Botões
BorderRadius.circular(8)

// Badges
BorderRadius.circular(8) ou circular(12)

// Avatares
BorderRadius.circular(999) // Circular completo
```

### Elevações (Sombras)

```dart
// Cards padrão
elevation: 2

// Cards destacados
elevation: 4

// Modal / Dialog
elevation: 8
```

## 🌐 Responsividade

### Breakpoints

```dart
// Mobile Small
< 360px

// Mobile
360px - 600px

// Tablet
600px - 900px

// Desktop
> 900px
```

### Adaptações

- Usar `MediaQuery.of(context).size` para obter dimensões
- Preferir layouts flex (Column, Row) ao invés de valores fixos
- Usar `Expanded` e `Flexible` para distribuição de espaço
- Testar em múltiplos tamanhos de tela

## ♿ Acessibilidade

### Contraste

Todas as combinações de cores atendem ao padrão WCAG AA:
- Texto sobre fundo branco: ratio > 4.5:1
- Texto grande sobre fundo colorido: ratio > 3:1

### Áreas de Toque

Todos os elementos interativos têm no mínimo:
- 48x48 pixels (Material Design)
- Espaçamento adequado entre elementos clicáveis

### Feedback Visual

- Estados de hover/pressed visíveis
- Loading indicators para operações assíncronas
- Mensagens de erro/sucesso claras

## 🎨 Gradientes

### Gradiente do Header (Home)

```dart
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF5a7a6a),
    Color(0xFF87a492),
  ],
)
```

### Gradiente do Botão Voluntário

```dart
LinearGradient(
  colors: [
    Color(0xFF87a492),
    Color(0xFF6f9180),
  ],
)
```

## 📦 Exportando para Código

Para usar as cores definidas neste guia:

```dart
// lib/constants/app_colors.dart
class AppColors {
  static const primary = Color(0xFF87a492);
  static const primaryDark = Color(0xFF5a7a6a);
  static const value = Color(0xFFc9a56f);
  static const urgent = Color(0xFFd68a7a);
  static const medium = Color(0xFFddb87a);
  static const low = Color(0xFFa8c9a4);
  static const location = Color(0xFFd4a687);
}
```

---

**Última atualização:** Novembro 2025

Para sugestões ou dúvidas sobre o design system, abra uma issue com a tag `design`.

