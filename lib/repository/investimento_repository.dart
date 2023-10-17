import 'package:expense_tracker/models/investimento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvestimentoRepository {
  Future<List<Investimento>> listarInvestimento() async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('investimentos')
        .select<List<Map<String, dynamic>>>();

    final investimento = data.map((e) => Investimento.fromMap(e)).toList();

    return investimento;
  }

  Future cadastrarInvestimento(Investimento investimento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('investimentos').insert({
      'nome_investimento': investimento.nomeInvestimento,
      'valor_investido': investimento.valorInvestido
    });
  }

  Future alterarInvestimento(Investimento investimento) async {
    final supabase = Supabase.instance.client;

    await supabase.from('investimentos').update({
      'nome_investimento': investimento.nomeInvestimento,
      'valor_investido': investimento.valorInvestido
    }).match({'id': investimento.id});
  }

Future excluirInvestimento(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('investimentos').delete().match({'id': id});
  }

}
