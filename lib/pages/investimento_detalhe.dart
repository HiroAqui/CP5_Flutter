import 'package:expense_tracker/models/investimento.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestimentoDetalhesPage extends StatefulWidget {
  const InvestimentoDetalhesPage({super.key});

  @override
  State<InvestimentoDetalhesPage> createState() =>
      _InvestimentoDetalhesPageState();
}

class _InvestimentoDetalhesPageState extends State<InvestimentoDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final investimento =
        ModalRoute.of(context)!.settings.arguments as Investimento;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Valor do Investimento'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(investimento.valorInvestido)),
            ),
            ListTile(
              title: const Text('Nome do Investimento'),
              subtitle: Text(investimento.nomeInvestimento),
            ),
          ],
        ),
      ),
    );
  }
}
