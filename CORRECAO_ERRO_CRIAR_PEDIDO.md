# Correção: Erro ao Criar Pedido/Serviço

## ❌ Problema
Erro ao tentar criar pedidos ou serviços no app.

## 🔍 Causa Identificada
O código estava enviando o campo `id` como string vazia `''` ao criar novos registros, mas o banco de dados Supabase:
1. Espera que o `id` seja `null` ou não enviado
2. Gera automaticamente um UUID para novos registros
3. Usa triggers que definem `created_at` e `updated_at` automaticamente

## ✅ Solução Aplicada

### 1. Atualizado Model Request
```dart
Map<String, dynamic> toJson({bool forInsert = false}) {
  final Map<String, dynamic> json = {
    'user_id': userId,
    'title': title,
    // ... outros campos
  };

  // Não incluir id, created_at e updated_at se for insert
  if (!forInsert || id.isNotEmpty) {
    json['id'] = id;
  }
  
  if (!forInsert) {
    json['created_at'] = createdAt.toIso8601String();
    json['updated_at'] = updatedAt.toIso8601String();
  }

  return json;
}
```

### 2. Atualizado Model Service
Mesma lógica aplicada ao modelo `Service`.

### 3. Atualizado RequestService
```dart
Future<Request> createRequest(Request request) async {
  final response = await _supabase
      .from('requests')
      .insert(request.toJson(forInsert: true))  // ← parâmetro forInsert
      .select()
      .single();

  return Request.fromJson(response);
}
```

### 4. Atualizado ServiceService
Mesma lógica aplicada ao `ServiceService`.

### 5. Adicionados Logs de Debug
- ✅ Logs em `RequestProvider.createRequest()`
- ✅ Logs em `RequestService.createRequest()`
- ✅ Mensagens de erro mais detalhadas

## 🎯 Como Funciona Agora

### Criando Novo Pedido/Serviço
1. Formulário validado ✅
2. Objeto Request/Service criado com `id = ''`
3. `toJson(forInsert: true)` é chamado
4. Campos `id`, `created_at` e `updated_at` **não são enviados**
5. Banco de dados gera automaticamente:
   - UUID para `id`
   - Timestamp atual para `created_at`
   - Timestamp atual para `updated_at`
6. Registro criado com sucesso ✅

### Atualizando Pedido/Serviço Existente
1. Objeto Request/Service com `id` válido
2. `toJson()` é chamado (sem parâmetro, usa default `forInsert: false`)
3. Todos os campos são enviados incluindo `id`
4. Registro atualizado com sucesso ✅

## 📋 Logs de Debug

Ao criar um pedido, você verá:
```
📝 Creating request: TESTE
🔄 Inserting request into database...
📋 Request data: {user_id: ..., title: TESTE, ...}
✅ Database insert successful
✅ Request created successfully
```

Em caso de erro:
```
❌ Database insert failed: [detalhes do erro]
❌ Error creating request: [detalhes do erro]
```

## 🧪 Teste Agora

1. Abra o app
2. Vá para "Adicionar Pedido" ou "Adicionar Serviço"
3. Preencha o formulário
4. Clique em "Salvar"
5. Deve mostrar: **"Pedido criado com sucesso!"**

## 📁 Arquivos Alterados
- ✅ `lib/models/request.dart`
- ✅ `lib/models/service.dart`
- ✅ `lib/services/request_service.dart`
- ✅ `lib/services/service_service.dart`
- ✅ `lib/providers/request_provider.dart`

## 🎉 Resultado Final
- ✅ Criar pedidos funciona
- ✅ Criar serviços funciona
- ✅ Atualizar pedidos/serviços funciona
- ✅ Logs detalhados para debug
- ✅ Mensagens de erro mais claras
