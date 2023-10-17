import 'package:expense_tracker/models/investimento.dart';
import 'package:expense_tracker/repository/investimento_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/investimento_item.dart';
import 'investimento_cadastro.dart';

class InvestimentoPage extends StatefulWidget {
  const InvestimentoPage({super.key});

  @override
  State<InvestimentoPage> createState() => _InvestimentoPageState();
}

class _InvestimentoPageState extends State<InvestimentoPage> {
  final investimentoRepo = InvestimentoRepository();
  late Future<List<Investimento>> futureInvestimento;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureInvestimento = investimentoRepo.listarInvestimento();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investimento'),
        actions: [
          // create a filter menu action
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Todas'),
                  onTap: () {
                    setState(() {
                      futureInvestimento =
                          investimentoRepo.listarInvestimento();
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Investimentos'),
                  onTap: () {
                    setState(() {
                      futureInvestimento =
                          investimentoRepo.listarInvestimento();
                    });
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Investimento>>(
        future: futureInvestimento,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar investimentos"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum investimento cadastrado"),
            );
          } else {
            final investimentos = snapshot.data!;
            return ListView.separated(
              itemCount: investimentos.length,
              itemBuilder: (context, index) {
                final investimento = investimentos[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvestimentoCadastroPage(
                                investimentoParaEdicao: investimento,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureInvestimento =
                                  investimentoRepo.listarInvestimento();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await investimentoRepo
                              .excluirInvestimento(investimento.id);

                          setState(() {
                            investimentos.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: InvestimentoItem(
                    investimento: investimento,
                    onTap: () {
                      Navigator.pushNamed(context, '/investimento-detalhes',
                          arguments: investimento);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "investimento-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/investimento-cadastro')
                  as bool?;

          if (result == true) {
            setState(() {
              futureInvestimento = investimentoRepo.listarInvestimento();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
