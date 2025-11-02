import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/request_provider.dart';
import '../models/request.dart';
import '../models/enums.dart';
import '../widgets/request_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/common_widgets.dart';
import 'request_detail_screen.dart';
import 'user_profile_screen.dart';

class ExploreRequestsScreen extends StatefulWidget {
  const ExploreRequestsScreen({super.key});

  @override
  State<ExploreRequestsScreen> createState() => _ExploreRequestsScreenState();
}

class _ExploreRequestsScreenState extends State<ExploreRequestsScreen> {
  final _searchController = TextEditingController();
  List<Request> _filteredRequests = [];
  ServiceCategory? _selectedCategory;
  PricingType? _selectedPricingType;
  String? _selectedCity;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestProvider>().loadAllRequests();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Explorar Pedidos'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar pedidos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) => _performSearch(),
            ),
          ),
          
          // Lista de pedidos
          Expanded(
            child: Consumer<RequestProvider>(
              builder: (context, requestProvider, child) {
                if (requestProvider.isLoading) {
                  return const LoadingWidget(message: 'Carregando pedidos...');
                }
                
                if (requestProvider.errorMessage != null) {
                  return CustomErrorWidget(
                    message: requestProvider.errorMessage!,
                    onRetry: () => requestProvider.loadAllRequests(),
                  );
                }
                
                if (_filteredRequests.isEmpty) {
                  return EmptyWidget(
                    message: 'Nenhum pedido encontrado',
                    icon: FontAwesomeIcons.search,
                    action: ElevatedButton(
                      onPressed: () {
                        _searchController.clear();
                        _selectedCategory = null;
                        _selectedPricingType = null;
                        _selectedCity = null;
                        _selectedState = null;
                        _performSearch();
                      },
                      child: const Text('Limpar Filtros'),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    await requestProvider.loadAllRequests();
                    _performSearch();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = _filteredRequests[index];
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
                              builder: (context) => UserProfileScreen(
                                userId: request.userId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    final requestProvider = context.read<RequestProvider>();
    
    if (_searchController.text.isEmpty &&
        _selectedCategory == null &&
        _selectedPricingType == null &&
        _selectedCity == null &&
        _selectedState == null) {
      setState(() {
        _filteredRequests = requestProvider.requests;
      });
      return;
    }
    
    requestProvider.searchRequests(
      query: _searchController.text.isEmpty ? null : _searchController.text,
      category: _selectedCategory,
      pricingType: _selectedPricingType,
      city: _selectedCity,
      state: _selectedState,
    ).then((results) {
      setState(() {
        _filteredRequests = results;
      });
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        selectedCategory: _selectedCategory,
        selectedPricingType: _selectedPricingType,
        selectedCity: _selectedCity,
        selectedState: _selectedState,
        onApplyFilters: (category, pricingType, city, state) {
          setState(() {
            _selectedCategory = category;
            _selectedPricingType = pricingType;
            _selectedCity = city;
            _selectedState = state;
          });
          _performSearch();
        },
      ),
    );
  }
}
