import 'package:expense_tracker/models/investimento.dart';

import 'package:flutter/material.dart';

import 'package:ionicons/ionicons.dart';

class InvestimentoItem extends StatelessWidget {
  final Investimento investimento;
  final void Function()? onTap;
  const InvestimentoItem({Key? key, required this.investimento, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(
          Ionicons.card_sharp,
          size: 20,
          color: Colors.black,
        ),
      ),
      title: Text(investimento.nomeInvestimento),
      subtitle: Text('R\$ ${investimento.valorInvestido}'),
      onTap: onTap,
    );
  }
}
