import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/request_provider.dart';
import '../providers/auth_provider.dart';
import '../models/request.dart';
import '../models/enums.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../widgets/common_widgets.dart';

class RequestFormScreen extends StatefulWidget {
  final Request? request;

  const RequestFormScreen({super.key, this.request});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urgencyController = TextEditingController();
  final _budgetController = TextEditingController();
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
    
    if (widget.request != null) {
      _populateForm();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urgencyController.dispose();
    _budgetController.dispose();
    _contactController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _populateForm() async {
    final request = widget.request!;
    _titleController.text = request.title;
    _descriptionController.text = request.description;
    _urgencyController.text = request.urgency;
    _budgetController.text = request.budget?.toString() ?? '';
    _contactController.text = request.contact;
    _selectedCategory = request.category;
    _selectedPricingType = request.pricingType;
    _isVoluntary = request.isVoluntary;
    
    // Carregar estados
    await _loadStates();
    
    // Encontrar e selecionar o estado
    if (_states.isNotEmpty) {
      final state = _states.firstWhere(
        (s) => s.sigla == request.state,
        orElse: () => _states.first,
      );
      
      setState(() {
        _selectedState = state;
        _stateController.text = state.sigla;
      });
      
      // Carregar cidades do estado
      await _loadCities(state.sigla);
      
      // Encontrar e selecionar a cidade
      if (_cities.isNotEmpty) {
        final city = _cities.firstWhere(
          (c) => c.nome == request.city,
          orElse: () => _cities.first,
        );
        
        setState(() {
          _selectedCity = city;
          _cityController.text = city.nome;
        });
      }
    }
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
        title: Text(widget.request == null ? 'Adicionar Demanda' : 'Editar Demanda'),
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
                  labelText: 'Título da Demanda',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título da demanda';
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
              InkWell(
                onTap: () => _showCategoryPicker(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedCategory?.displayName ?? 'Selecione uma categoria',
                          style: TextStyle(
                            color: _selectedCategory == null ? Colors.grey : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Urgência
              DropdownButtonFormField<String>(
                value: _urgencyController.text.isEmpty ? 'Médio' : _urgencyController.text,
                decoration: const InputDecoration(
                  labelText: 'Urgência',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Baixo', child: Text('Baixo')),
                  DropdownMenuItem(value: 'Médio', child: Text('Médio')),
                  DropdownMenuItem(value: 'Urgente', child: Text('Urgente')),
                ],
                onChanged: (value) {
                  setState(() {
                    _urgencyController.text = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Orçamento
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Orçamento (opcional)',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 200.00',
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
                    'Busco Voluntários',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    'Marque esta opção se você procura voluntários sem custo',
                    style: TextStyle(fontSize: 12),
                  ),
                  value: _isVoluntary,
                  activeColor: const Color(0xFF87a492),
                  onChanged: (bool? value) {
                    setState(() {
                      _isVoluntary = value ?? false;
                      if (_isVoluntary) {
                        _budgetController.clear();
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
                value: _states.contains(_selectedState) ? _selectedState : null,
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
                value: _cities.contains(_selectedCity) ? _selectedCity : null,
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
                  onPressed: _isLoading ? null : _saveRequest,
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
                          widget.request == null ? 'Criar Demanda' : 'Atualizar Demanda',
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

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF87a492),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selecione uma Categoria',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ServiceCategory.categoriesByGroup.length,
                    itemBuilder: (context, index) {
                      final entry = ServiceCategory.categoriesByGroup.entries.elementAt(index);
                      final groupName = entry.key;
                      final categories = entry.value;
                      
                      return ExpansionTile(
                        title: Text(
                          groupName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF5a7a6a),
                          ),
                        ),
                        children: categories.map((category) {
                          return ListTile(
                            title: Text(category.displayName),
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                              Navigator.of(context).pop();
                            },
                            trailing: _selectedCategory == category
                                ? const Icon(Icons.check, color: Color(0xFF87a492))
                                : null,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRequest() async {
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
      final requestProvider = context.read<RequestProvider>();
      
      final request = Request(
        id: widget.request?.id ?? '',
        userId: authProvider.currentUser!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        urgency: _urgencyController.text,
        budget: _budgetController.text.isNotEmpty 
            ? double.tryParse(_budgetController.text) 
            : null,
        pricingType: _selectedPricingType,
        contact: _contactController.text.trim(),
        city: _selectedCity!.nome,
        state: _selectedState!.sigla,
        isVoluntary: _isVoluntary,
        createdAt: widget.request?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.request == null) {
        success = await requestProvider.createRequest(request);
      } else {
        success = await requestProvider.updateRequest(request);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.request == null 
                    ? 'Demanda criada com sucesso!' 
                    : 'Demanda atualizada com sucesso!'
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(requestProvider.errorMessage ?? 'Erro ao salvar demanda'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar demanda: $e'),
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
