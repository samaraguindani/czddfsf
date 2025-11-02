import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import '../providers/auth_provider.dart';
import '../models/service.dart';
import '../models/enums.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../widgets/common_widgets.dart';

class ServiceFormScreen extends StatefulWidget {
  final Service? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _valueController = TextEditingController();
  final _contactController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  ServiceCategory _selectedCategory = ServiceCategory.outros;
  PricingType _selectedPricingType = PricingType.aCombinar;
  bool _isVoluntary = false;
  
  List<Estado> _states = [];
  List<City> _cities = [];
  Estado? _selectedState;
  City? _selectedCity;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
    
    if (widget.service != null) {
      _populateForm();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _availabilityController.dispose();
    _valueController.dispose();
    _contactController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _populateForm() {
    final service = widget.service!;
    _titleController.text = service.title;
    _descriptionController.text = service.description;
    _availabilityController.text = service.availability;
    _valueController.text = service.value?.toString() ?? '';
    _contactController.text = service.contact;
    _cityController.text = service.city;
    _stateController.text = service.state;
    _selectedCategory = service.category;
    _selectedPricingType = service.pricingType;
    _isVoluntary = service.isVoluntary;
  }

  Future<void> _loadStates() async {
    try {
      final locationService = LocationService();
      final states = await locationService.getStates();
      setState(() {
        _states = states;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar estados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCities(String stateCode) async {
    try {
      final locationService = LocationService();
      final cities = await locationService.getCitiesByStateCode(stateCode);
      setState(() {
        _cities = cities;
        _selectedCity = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar cidades: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.service == null ? 'Adicionar Serviço' : 'Editar Serviço'),
        backgroundColor: const Color(0xFF5a7a6a),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título do Serviço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título do serviço';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Descrição
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Categoria
              DropdownButtonFormField<ServiceCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: ServiceCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Disponibilidade
              TextFormField(
                controller: _availabilityController,
                decoration: const InputDecoration(
                  labelText: 'Disponibilidade',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Segunda a sexta, 8h às 18h',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a disponibilidade';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Valor
              TextFormField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 50.00',
                  prefixText: 'R\$ ',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tipo de Cobrança
              DropdownButtonFormField<PricingType>(
                value: _selectedPricingType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Cobrança',
                  border: OutlineInputBorder(),
                ),
                items: PricingType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPricingType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Trabalho Voluntário
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF87a492)),
                  borderRadius: BorderRadius.circular(8),
                  color: _isVoluntary ? const Color(0xFF87a492).withOpacity(0.1) : Colors.transparent,
                ),
                child: CheckboxListTile(
                  title: const Text(
                    'Trabalho Voluntário',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Marque esta opção se o serviço for oferecido gratuitamente',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _isVoluntary,
                  activeColor: const Color(0xFF87a492),
                  onChanged: (bool? value) {
                    setState(() {
                      _isVoluntary = value ?? false;
                      if (_isVoluntary) {
                        _valueController.clear();
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Contato
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contato',
                  border: OutlineInputBorder(),
                  hintText: 'Telefone, WhatsApp ou e-mail',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um contato';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Estado
              DropdownButtonFormField<Estado>(
                value: _selectedState,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                items: _states.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                    _cities.clear();
                  });
                  if (value != null) {
                    _loadCities(value.sigla);
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Cidade
              DropdownButtonFormField<City>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Botão Salvar
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87a492),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const LoadingWidget()
                      : Text(
                          widget.service == null ? 'Criar Serviço' : 'Atualizar Serviço',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedState == null || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione estado e cidade'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final serviceProvider = context.read<ServiceProvider>();
      
      final service = Service(
        id: widget.service?.id ?? '',
        userId: authProvider.currentUser!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        availability: _availabilityController.text.trim(),
        value: _valueController.text.isNotEmpty 
            ? double.tryParse(_valueController.text) 
            : null,
        pricingType: _selectedPricingType,
        contact: _contactController.text.trim(),
        city: _selectedCity!.nome,
        state: _selectedState!.sigla,
        isVoluntary: _isVoluntary,
        createdAt: widget.service?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.service == null) {
        success = await serviceProvider.createService(service);
      } else {
        success = await serviceProvider.updateService(service);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.service == null 
                    ? 'Serviço criado com sucesso!' 
                    : 'Serviço atualizado com sucesso!'
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(serviceProvider.errorMessage ?? 'Erro ao salvar serviço'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar serviço: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
