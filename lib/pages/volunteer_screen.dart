import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../providers/request_provider.dart';
import '../models/service.dart';
import '../models/request.dart';
import '../widgets/service_card.dart';
import '../widgets/request_card.dart';
import '../widgets/common_widgets.dart';
import 'service_detail_screen.dart';
import 'request_detail_screen.dart';
import 'user_profile_screen.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadVolunteerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadVolunteerData() async {
    setState(() => _isLoading = true);
    
    try {
      final serviceProvider = context.read<ServiceProvider>();
      final requestProvider = context.read<RequestProvider>();
      
      await Future.wait([
        serviceProvider.loadAllServices(),
        requestProvider.loadAllRequests(),
      ]);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(FontAwesomeIcons.heart, size: 20),
            SizedBox(width: 12),
            Text('Trabalhos Voluntários'),
          ],
        ),
        backgroundColor: const Color(0xFF5a7a6a),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(FontAwesomeIcons.handshakeAngle, size: 20),
              text: 'Serviços',
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.handHoldingHeart, size: 20),
              text: 'Pedidos',
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingWidget())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildVolunteerServices(),
                _buildVolunteerRequests(),
              ],
            ),
    );
  }

  Widget _buildVolunteerServices() {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        final volunteerServices = serviceProvider.services
            .where((service) => service.isVoluntary)
            .toList();

        if (volunteerServices.isEmpty) {
          return _buildEmptyState(
            icon: FontAwesomeIcons.handshakeAngle,
            title: 'Nenhum serviço voluntário',
            subtitle: 'Ainda não há serviços voluntários cadastrados',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadVolunteerData,
          color: const Color(0xFF87a492),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: volunteerServices.length,
            itemBuilder: (context, index) {
              final service = volunteerServices[index];
              return ServiceCard(
                service: service,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailScreen(service: service),
                    ),
                  );
                },
                onViewProfile: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: service.userId),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildVolunteerRequests() {
    return Consumer<RequestProvider>(
      builder: (context, requestProvider, child) {
        final volunteerRequests = requestProvider.requests
            .where((request) => request.isVoluntary)
            .toList();

        if (volunteerRequests.isEmpty) {
          return _buildEmptyState(
            icon: FontAwesomeIcons.handHoldingHeart,
            title: 'Nenhum pedido de voluntário',
            subtitle: 'Ainda não há pedidos buscando voluntários',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadVolunteerData,
          color: const Color(0xFF87a492),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: volunteerRequests.length,
            itemBuilder: (context, index) {
              final request = volunteerRequests[index];
              return RequestCard(
                request: request,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestDetailScreen(request: request),
                    ),
                  );
                },
                onViewProfile: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: request.userId),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

