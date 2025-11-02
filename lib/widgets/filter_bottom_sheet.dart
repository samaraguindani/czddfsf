import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/location.dart';
import '../services/location_service.dart';

class FilterBottomSheet extends StatefulWidget {
  final ServiceCategory? selectedCategory;
  final PricingType? selectedPricingType;
  final String? selectedCity;
  final String? selectedState;
  final Function(ServiceCategory?, PricingType?, String?, String?) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    this.selectedCategory,
    this.selectedPricingType,
    this.selectedCity,
    this.selectedState,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final LocationService _locationService = LocationService();
  
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
    _selectedCategory = widget.selectedCategory;
    _selectedPricingType = widget.selectedPricingType;
    _selectedCity = widget.selectedCity;
    _selectedState = widget.selectedState;
    _loadStates();
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
      
      // Se há um estado selecionado, carregar suas cidades
      if (_selectedState != null) {
        _loadCities(_selectedState!);
      }
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
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryFilter(),
                      const SizedBox(height: 16),
                      _buildPricingTypeFilter(),
                      const SizedBox(height: 16),
                      _buildLocationFilter(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoria',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Todas'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = null;
                });
              },
            ),
            ...ServiceCategory.values.map((category) => FilterChip(
              label: Text(category.displayName),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : null;
                });
              },
            )),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPricingTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de Cobrança',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('Todos'),
              selected: _selectedPricingType == null,
              onSelected: (selected) {
                setState(() {
                  _selectedPricingType = null;
                });
              },
            ),
            ...PricingType.values.map((type) => FilterChip(
              label: Text(type.displayName),
              selected: _selectedPricingType == type,
              onSelected: (selected) {
                setState(() {
                  _selectedPricingType = selected ? type : null;
                });
              },
            )),
          ],
        ),
      ],
    );
  }
  
  Widget _buildLocationFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localização',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // Estado
        if (_isLoadingStates)
          const Center(child: CircularProgressIndicator())
        else
          DropdownButtonFormField<String>(
            value: _selectedState,
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.map),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todos os estados'),
              ),
              ..._states.map((estado) {
                return DropdownMenuItem<String>(
                  value: estado.sigla,
                  child: Text(estado.nome),
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
            },
          ),
        
        const SizedBox(height: 12),
        
        // Cidade
        if (_selectedState != null) ...[
          if (_isLoadingCities)
            const Center(child: CircularProgressIndicator())
          else
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Todas as cidades'),
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
              },
            ),
        ],
      ],
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _selectedPricingType = null;
                _selectedCity = null;
                _selectedState = null;
                _cities = [];
              });
            },
            child: const Text('Limpar'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onApplyFilters(
                _selectedCategory,
                _selectedPricingType,
                _selectedCity,
                _selectedState,
              );
              Navigator.pop(context);
            },
            child: const Text('Aplicar'),
          ),
        ),
      ],
    );
  }
}
