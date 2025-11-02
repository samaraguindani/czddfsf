import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/request_provider.dart';
import '../models/request.dart';
import '../models/enums.dart';
import '../models/location.dart';
import '../services/location_service.dart';
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
  final LocationService _locationService = LocationService();
  
  List<Request> _filteredRequests = [];
  ServiceCategory? _selectedCategory;
  PricingType? _selectedPricingType;
  String? _selectedCity;
  String? _selectedState;
  
  List<Estado> _states = [];
  List<City> _cities = [];
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestProvider>().loadAllRequests().then((_) {
        _performSearch();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadStates() async {
    setState(() {
      _isLoadingStates = true;
    });
    
    try {
      final states = await _locationService.getStates();
      setState(() {
        _states = states;
        _isLoadingStates = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStates = false;
      });
    }
  }
  
  Future<void> _loadCities(String stateCode) async {
    setState(() {
      _isLoadingCities = true;
    });
    
    try {
      final cities = await _locationService.getCitiesByStateCode(stateCode);
      setState(() {
        _cities = cities;
        _isLoadingCities = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Explorar Pedidos'),
        backgroundColor: const Color(0xFF5a7a6a),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterBottomSheet,
              ),
              if (_hasActiveFilters())
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pesquisa e filtros
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Barra de pesquisa
                TextField(
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
                
                const SizedBox(height: 12),
                
                // Filtros de localização
                Row(
                  children: [
                    // Estado
                    Expanded(
                      child: _isLoadingStates
                          ? Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            )
                          : DropdownButtonFormField<String>(
                              value: _selectedState,
                              decoration: InputDecoration(
                                labelText: 'Estado',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                prefixIcon: const Icon(Icons.map, size: 20, color: Color(0xFF87a492)),
                              ),
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Todos'),
                                ),
                                ..._states.map((estado) {
                                  return DropdownMenuItem<String>(
                                    value: estado.sigla,
                                    child: Text(estado.sigla),
                                  );
                                }),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                  _selectedCity = null;
                                  _cities = [];
                                });
                                if (value != null) {
                                  _loadCities(value);
                                }
                                _performSearch();
                              },
                            ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // Cidade
                    Expanded(
                      flex: 2,
                      child: _selectedState == null
                          ? Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Selecione um estado',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          : _isLoadingCities
                              ? Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                )
                              : DropdownButtonFormField<String>(
                                  value: _selectedCity,
                                  decoration: InputDecoration(
                                    labelText: 'Cidade',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    prefixIcon: const Icon(Icons.location_city, size: 20, color: Color(0xFF87a492)),
                                  ),
                                  isExpanded: true,
                                  items: [
                                    const DropdownMenuItem<String>(
                                      value: null,
                                      child: Text('Todas'),
                                    ),
                                    ..._cities.map((city) {
                                      return DropdownMenuItem<String>(
                                        value: city.nome,
                                        child: Text(city.nome),
                                      );
                                    }),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCity = value;
                                    });
                                    _performSearch();
                                  },
                                ),
                    ),
                  ],
                ),
              ],
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

  bool _hasActiveFilters() {
    return _selectedCategory != null ||
        _selectedPricingType != null ||
        _selectedCity != null ||
        _selectedState != null;
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
