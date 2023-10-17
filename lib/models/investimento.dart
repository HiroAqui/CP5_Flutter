

class Investimento{
   int id;
   String nomeInvestimento;
   double valorInvestido;

   Investimento({
    required this.id,
    required this.nomeInvestimento,
    required this.valorInvestido
   });


factory Investimento.fromMap(Map<String, dynamic> map) {
    return Investimento(
      id: map['id'],
      nomeInvestimento: map['nome_investimento'],
      valorInvestido: map['valor_investido'],
    );
  }
}
