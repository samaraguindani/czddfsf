enum ServiceCategory {
  // Cuidado e Bem-Estar Pessoal
  cuidadorIdosos('Cuidador de idosos'),
  baba('Babá / Cuidadora infantil'),
  enfermeiroParticular('Enfermeiro(a) particular'),
  massoterapeuta('Massoterapeuta'),
  personalTrainer('Personal trainer'),
  fisioterapeuta('Fisioterapeuta'),
  nutricionista('Nutricionista'),
  psicologo('Psicólogo(a)'),
  esteticista('Esteticista'),
  depiladora('Depiladora'),
  maquiadora('Maquiadora'),
  cabeleireiro('Cabelereiro(a) / Barbeiro'),
  
  // Pets
  petSitter('Pet sitter (cuidador de pets)'),
  dogWalker('Dog walker (passeador de cães)'),
  banhoTosa('Banho e tosa'),
  adestrador('Adestrador'),
  veterinarioDomiciliar('Veterinário domiciliar'),
  hospedagemPets('Hospedagem para pets'),
  
  // Educação e Aulas
  professorParticular('Professor particular (reforço escolar)'),
  aulasIdiomas('Aulas de idiomas'),
  aulasMusica('Aulas de música'),
  aulasDanca('Aulas de dança'),
  aulasInformatica('Aulas de informática'),
  reforcoVestibular('Reforço para vestibular ou ENEM'),
  aulasArtes('Aulas de artes / desenho / pintura'),
  
  // Serviços Domésticos
  faxineira('Faxineira / diarista'),
  passadeira('Passadeira'),
  cozinheira('Cozinheira'),
  jardineiro('Jardineiro'),
  piscineiro('Piscineiro'),
  encanador('Encanador'),
  eletricista('Eletricista'),
  pintor('Pintor'),
  pedreiro('Pedreiro / servente'),
  montadorMoveis('Montador de móveis'),
  tecnicoArCondicionado('Técnico de ar-condicionado / geladeira'),
  
  // Tecnologia e Design
  desenvolvedorWeb('Desenvolvedor web / app'),
  tecnicoInformatica('Técnico de informática'),
  designerGrafico('Designer gráfico'),
  editorVideo('Editor de vídeo / social media'),
  fotografo('Fotógrafo / videomaker'),
  marketingDigital('Marketing digital / tráfego pago'),
  
  // Transporte e Logística
  motoristaParticular('Motorista particular'),
  motoboy('Motoboy / entregador'),
  transporteEscolar('Transporte escolar'),
  freteiro('Freteiro / mudança'),
  guincho('Guincho'),
  lavagemAutomotiva('Lavagem automotiva'),
  
  // Eventos e Festas
  organizadorEventos('Organizador de eventos'),
  decorador('Decorador'),
  buffet('Buffet / chef de cozinha'),
  garcom('Garçom / copeira'),
  dj('DJ'),
  fotografoEventos('Fotógrafo de eventos'),
  locutor('Locutor / animador'),
  aluguelSom('Aluguel de som e iluminação'),
  
  // Serviços Empresariais
  contador('Contador'),
  advogado('Advogado'),
  consultorNegocios('Consultor de negócios'),
  assistenteVirtual('Assistente virtual'),
  redator('Redator / copywriter'),
  tradutor('Tradutor'),
  
  outros('Outros');

  const ServiceCategory(this.displayName);
  final String displayName;
  
  static Map<String, List<ServiceCategory>> get categoriesByGroup => {
    'Cuidado e Bem-Estar Pessoal': [
      cuidadorIdosos, baba, enfermeiroParticular, massoterapeuta,
      personalTrainer, fisioterapeuta, nutricionista, psicologo,
      esteticista, depiladora, maquiadora, cabeleireiro,
    ],
    'Pets': [
      petSitter, dogWalker, banhoTosa, adestrador,
      veterinarioDomiciliar, hospedagemPets,
    ],
    'Educação e Aulas': [
      professorParticular, aulasIdiomas, aulasMusica, aulasDanca,
      aulasInformatica, reforcoVestibular, aulasArtes,
    ],
    'Serviços Domésticos': [
      faxineira, passadeira, cozinheira, jardineiro, piscineiro,
      encanador, eletricista, pintor, pedreiro, montadorMoveis,
      tecnicoArCondicionado,
    ],
    'Tecnologia e Design': [
      desenvolvedorWeb, tecnicoInformatica, designerGrafico,
      editorVideo, fotografo, marketingDigital,
    ],
    'Transporte e Logística': [
      motoristaParticular, motoboy, transporteEscolar,
      freteiro, guincho, lavagemAutomotiva,
    ],
    'Eventos e Festas': [
      organizadorEventos, decorador, buffet, garcom,
      dj, fotografoEventos, locutor, aluguelSom,
    ],
    'Serviços Empresariais': [
      contador, advogado, consultorNegocios, assistenteVirtual,
      redator, tradutor,
    ],
  };
}

enum PricingType {
  porHora('Por Hora'),
  porDia('Por Dia'),
  porServico('Por Serviço'),
  aCombinar('A Combinar');

  const PricingType(this.displayName);
  final String displayName;
}