import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/service_provider.dart';
import '../models/service.dart';
import '../models/enums.dart';
import '../widgets/service_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/common_widgets.dart';
import 'service_detail_screen.dart';

class ExploreServicesScreen extends StatefulWidget {
  const ExploreServicesScreen({super.key});

  @override
  State<ExploreServicesScreen> createState() => _ExploreServicesScreenState();
}

class _ExploreServicesScreenState extends State<ExploreServicesScreen> {
  final _searchController = TextEditingController();
  List<Service> _filteredServices = [];
  ServiceCategory? _selectedCategory;
  PricingType? _selectedPricingType;
  String? _selectedCity;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceProvider>().loadAllServices();
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
        title: const Text('Explorar Serviços'),
        backgroundColor: Colors.blue[600],
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
                hintText: 'Buscar serviços...',
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
          
          // Lista de serviços
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, serviceProvider, child) {
                if (serviceProvider.isLoading) {
                  return const LoadingWidget(message: 'Carregando serviços...');
                }
                
                if (serviceProvider.errorMessage != null) {
                  return CustomErrorWidget(
                    message: serviceProvider.errorMessage!,
                    onRetry: () => serviceProvider.loadAllServices(),
                  );
                }
                
                if (_filteredServices.isEmpty) {
                  return EmptyWidget(
                    message: 'Nenhum serviço encontrado',
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
                    await serviceProvider.loadAllServices();
                    _performSearch();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServices[index];
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
    final serviceProvider = context.read<ServiceProvider>();
    
    if (_searchController.text.isEmpty &&
        _selectedCategory == null &&
        _selectedPricingType == null &&
        _selectedCity == null &&
        _selectedState == null) {
      setState(() {
        _filteredServices = serviceProvider.services;
      });
      return;
    }
    
    serviceProvider.searchServices(
      query: _searchController.text.isEmpty ? null : _searchController.text,
      category: _selectedCategory,
      pricingType: _selectedPricingType,
      city: _selectedCity,
      state: _selectedState,
    ).then((results) {
      setState(() {
        _filteredServices = results;
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
