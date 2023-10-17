

import 'package:expense_tracker/models/investimento.dart';
import 'package:expense_tracker/repository/investimento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class InvestimentoCadastroPage extends StatefulWidget {
  final Investimento? investimentoParaEdicao;

  const InvestimentoCadastroPage({super.key, this.investimentoParaEdicao});

  @override
  State<InvestimentoCadastroPage> createState() =>
      _InvestimentoCadastroPageState();
}

class _InvestimentoCadastroPageState extends State<InvestimentoCadastroPage> {
  User? user;
  final investimentoRepo = InvestimentoRepository();

  final nomeController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final investimento = widget.investimentoParaEdicao;

    if (investimento != null) {
      valorController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(investimento.valorInvestido);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Investimento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNome(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe o nome do investimento',
        labelText: 'Nome investimento',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um nome para o investimento';
        }
        return null;
      },
    );
  }

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor investido',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Descricao
            final nome = nomeController.text;
            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));

            final investimento = Investimento(
                id: 0,
                nomeInvestimento: nome,
                valorInvestido: valor.toDouble());

            if (widget.investimentoParaEdicao == null) {
              await _cadastrarInvestimento(investimento);
            } else {
              investimento.id = widget.investimentoParaEdicao!.id;
              await _alterarInvestimento(investimento);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }


  Future<void> _cadastrarInvestimento(Investimento investimento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await investimentoRepo.cadastrarInvestimento(investimento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'cadastrado realizado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao realizar cadastro',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarInvestimento(Investimento investimento) async {
    final scaffold = ScaffoldMessenger.of(context);
    await investimentoRepo.alterarInvestimento(investimento).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Alteração realizada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(const SnackBar(
        content: Text(
          'Erro ao realizar alteração',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
