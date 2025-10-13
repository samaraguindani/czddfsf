import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/service_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/service_card.dart';
import '../widgets/common_widgets.dart';
import 'service_form_screen.dart';
import 'service_detail_screen.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyServices();
    });
  }

  void _loadMyServices() {
    final authProvider = context.read<AuthProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    
    if (authProvider.currentUser != null) {
      serviceProvider.loadMyServices(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Meus Serviços'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<ServiceProvider, AuthProvider>(
        builder: (context, serviceProvider, authProvider, child) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text('Usuário não autenticado'),
            );
          }

          if (serviceProvider.isLoading) {
            return const LoadingWidget(message: 'Carregando seus serviços...');
          }

          if (serviceProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: serviceProvider.errorMessage!,
              onRetry: _loadMyServices,
            );
          }

          if (serviceProvider.myServices.isEmpty) {
            return EmptyWidget(
              message: 'Você ainda não possui serviços cadastrados',
              icon: FontAwesomeIcons.briefcase,
              action: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceFormScreen(),
                    ),
                  ).then((_) => _loadMyServices());
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Serviço'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await serviceProvider.loadMyServices(authProvider.currentUser!.id);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: serviceProvider.myServices.length,
              itemBuilder: (context, index) {
                final service = serviceProvider.myServices[index];
                return ServiceCard(
                  service: service,
                  showActions: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(service: service),
                      ),
                    );
                  },
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceFormScreen(service: service),
                      ),
                    ).then((_) => _loadMyServices());
                  },
                  onDelete: () => _showDeleteDialog(service),
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
              builder: (context) => const ServiceFormScreen(),
            ),
          ).then((_) => _loadMyServices());
        },
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Serviço'),
      ),
    );
  }

  void _showDeleteDialog(service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Serviço'),
        content: const Text('Tem certeza que deseja excluir este serviço? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final serviceProvider = context.read<ServiceProvider>();
              final authProvider = context.read<AuthProvider>();
              
              final success = await serviceProvider.deleteService(
                service.id,
                authProvider.currentUser!.id,
              );
              
              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Serviço excluído com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(serviceProvider.errorMessage ?? 'Erro ao excluir serviço'),
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
