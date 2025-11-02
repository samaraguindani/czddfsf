enum ServiceCategory {
  jardinagem('Jardinagem'),
  aulas('Aulas'),
  design('Design'),
  limpeza('Limpeza'),
  manutencao('Manutenção'),
  tecnologia('Tecnologia'),
  saude('Saúde'),
  transporte('Transporte'),
  alimentacao('Alimentação'),
  outros('Outros');

  const ServiceCategory(this.displayName);
  final String displayName;
}

enum PricingType {
  porHora('Por Hora'),
  porDia('Por Dia'),
  porServico('Por Serviço'),
  aCombinar('A Combinar');

  const PricingType(this.displayName);
  final String displayName;
}