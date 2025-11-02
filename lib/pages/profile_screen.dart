import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth_provider.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();

  List<Estado> _states = [];
  List<City> _cities = [];
  Estado? _selectedState;
  City? _selectedCity;
  
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
    _populateForm();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _descriptionController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  void _populateForm() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user != null) {
      _fullNameController.text = user.fullName;
      _phoneController.text = user.phone;
      _cpfController.text = user.cpf;
      _descriptionController.text = user.description ?? '';
      _cepController.text = user.cep ?? '';
      _streetController.text = user.street ?? '';
      _numberController.text = user.number ?? '';
      _complementController.text = user.complement ?? '';
      _neighborhoodController.text = user.neighborhood ?? '';
      
      // Encontrar estado e cidade se existirem
      if (user.state != null && user.city != null) {
        _findStateAndCity(user.state!, user.city!);
      }
    }
  }

  void _findStateAndCity(String stateCode, String cityName) {
    // Verificar se há estados carregados
    if (_states.isEmpty) {
      print('⚠️ States list is empty, cannot find state');
      return;
    }
    
    // Encontrar estado
    try {
      final state = _states.firstWhere(
        (s) => s.sigla == stateCode,
      );
      
      setState(() {
        _selectedState = state;
      });
      
      _loadCities(state.sigla).then((_) {
        // Encontrar cidade
        if (_cities.isEmpty) {
          print('⚠️ Cities list is empty, cannot find city');
          return;
        }
        
        try {
          final city = _cities.firstWhere(
            (c) => c.nome == cityName,
          );
          
          setState(() {
            _selectedCity = city;
          });
        } catch (e) {
          print('⚠️ City not found: $cityName');
        }
      });
    } catch (e) {
      print('⚠️ State not found: $stateCode');
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
        if (_selectedCity != null && !cities.contains(_selectedCity)) {
          _selectedCity = null;
        }
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
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                _populateForm();
              },
            ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.currentUser == null) {
            return const Center(
              child: Text('Usuário não autenticado'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card do perfil
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.indigo[600],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Nome
                          Text(
                            authProvider.currentUser!.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Email
                          Text(
                            authProvider.currentUser!.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Informações pessoais
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informações Pessoais',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Nome completo
                          TextFormField(
                            controller: _fullNameController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Nome Completo',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_isEditing && (value == null || value.isEmpty)) {
                                return 'Por favor, insira seu nome completo';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Telefone
                          TextFormField(
                            controller: _phoneController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Telefone',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_isEditing && (value == null || value.isEmpty)) {
                                return 'Por favor, insira seu telefone';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // CPF
                          TextFormField(
                            controller: _cpfController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'CPF',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (_isEditing && (value == null || value.isEmpty)) {
                                return 'Por favor, insira seu CPF';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Descrição
                          TextFormField(
                            controller: _descriptionController,
                            enabled: _isEditing,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Descrição Pessoal',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Endereço
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Endereço',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // CEP
                          TextFormField(
                            controller: _cepController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'CEP',
                              border: OutlineInputBorder(),
                              hintText: '00000-000',
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Rua
                          TextFormField(
                            controller: _streetController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Rua',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _numberController,
                                  enabled: _isEditing,
                                  decoration: const InputDecoration(
                                    labelText: 'Número',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _complementController,
                                  enabled: _isEditing,
                                  decoration: const InputDecoration(
                                    labelText: 'Complemento',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Bairro
                          TextFormField(
                            controller: _neighborhoodController,
                            enabled: _isEditing,
                            decoration: const InputDecoration(
                              labelText: 'Bairro',
                              border: OutlineInputBorder(),
                            ),
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
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                    _cities.clear();
                  });
                  if (value != null) {
                    _loadCities(value.sigla);
                  }
                } : null,
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
                onChanged: _isEditing ? (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                } : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botões de ação
                  if (_isEditing) ...[
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const LoadingWidget()
                            : const Text(
                                'Salvar Alterações',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                          _populateForm();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Botão de logout
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sair da Conta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final currentUser = authProvider.currentUser!;
      
      final updatedUser = currentUser.copyWith(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        description: _descriptionController.text.trim(),
        cep: _cepController.text.trim(),
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        complement: _complementController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        city: _selectedCity?.nome,
        state: _selectedState?.sigla,
        updatedAt: DateTime.now(),
      );

      final success = await authProvider.updateProfile(updatedUser);
      
      if (mounted) {
        if (success) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Erro ao atualizar perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: $e'),
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              // Mostra loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              
              // Pega o authProvider do contexto original, não do dialog
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              
              if (mounted) {
                // Fecha o loading
                Navigator.pop(context);
                
                // Remove todas as rotas e vai para o login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
