import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/request_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/request_card.dart';
import '../widgets/common_widgets.dart';
import 'request_form_screen.dart';
import 'request_detail_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyRequests();
    });
  }

  void _loadMyRequests() {
    final authProvider = context.read<AuthProvider>();
    final requestProvider = context.read<RequestProvider>();
    
    if (authProvider.currentUser != null) {
      requestProvider.loadMyRequests(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Minhas Demandas'),
        backgroundColor: const Color(0xFF5a7a6a),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<RequestProvider, AuthProvider>(
        builder: (context, requestProvider, authProvider, child) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text('Usuário não autenticado'),
            );
          }

          if (requestProvider.isLoading) {
            return const LoadingWidget(message: 'Carregando suas demandas...');
          }

          if (requestProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: requestProvider.errorMessage!,
              onRetry: _loadMyRequests,
            );
          }

          if (requestProvider.myRequests.isEmpty) {
            return EmptyWidget(
              message: 'Você ainda não possui demandas cadastradas',
              icon: FontAwesomeIcons.clipboardList,
              action: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RequestFormScreen(),
                    ),
                  ).then((_) => _loadMyRequests());
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Demanda'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await requestProvider.loadMyRequests(authProvider.currentUser!.id);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: requestProvider.myRequests.length,
              itemBuilder: (context, index) {
                final request = requestProvider.myRequests[index];
                return RequestCard(
                  request: request,
                  showActions: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailScreen(request: request),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestFormScreen(request: request),
                      ),
                    ).then((_) => _loadMyRequests());
                  },
                  onDelete: () => _showDeleteDialog(request),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RequestFormScreen(),
            ),
          ).then((_) => _loadMyRequests());
        },
        backgroundColor: const Color(0xFF87a492),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Demanda'),
      ),
    );
  }

  void _showDeleteDialog(request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Demanda'),
        content: const Text('Tem certeza que deseja excluir esta demanda? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final requestProvider = context.read<RequestProvider>();
              final authProvider = context.read<AuthProvider>();
              
              final success = await requestProvider.deleteRequest(
                request.id,
                authProvider.currentUser!.id,
              );
              
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Demanda excluída com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(requestProvider.errorMessage ?? 'Erro ao excluir demanda'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
