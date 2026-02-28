import 'package:flutter/material.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> pengeluaran = [];

  void tambahData(String data) {
    setState(() {
      pengeluaran.add(data);
    });
  }

  void updateData(int index, String data) {
    setState(() {
      pengeluaran[index] = data;
    });
  }

  void hapusData(int index) {
    setState(() {
      pengeluaran.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Dompet Nangis 💸'),
        backgroundColor: const Color(0xFFFFE4EC),
        centerTitle: true,
      ),

      body: pengeluaran.isEmpty
          ? _emptyState(context)
          : ListView.builder(
              itemCount: pengeluaran.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(pengeluaran[index]),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormPage(
                          initialData: pengeluaran[index],
                        ),
                      ),
                    );

                    if (result != null) {
                      updateData(index, result);
                    }
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => hapusData(index),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_wallet,
              size: 80, color: Colors.pink),
          const SizedBox(height: 20),
          const Text(
            'Dompet masih aman 😌',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('Belum ada pengeluaran tercatat'),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FormPage()),
              );

              if (result != null) {
                tambahData(result);
              }
            },
            child: const Text('+ Tambah Pengeluaran'),
          ),
        ],
      ),
    );
  }
}