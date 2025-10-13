import 'package:flutter/material.dart';
import '../models/enums.dart';

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
  ServiceCategory? _selectedCategory;
  PricingType? _selectedPricingType;
  String? _selectedCity;
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _selectedPricingType = widget.selectedPricingType;
    _selectedCity = widget.selectedCity;
    _selectedState = widget.selectedState;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          
          // Categoria
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
          
          const SizedBox(height: 16),
          
          // Tipo de Cobrança
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
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _selectedPricingType = null;
                      _selectedCity = null;
                      _selectedState = null;
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
          ),
        ],
      ),
    );
  }
}
