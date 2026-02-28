import 'package:flutter/material.dart';

void main() {
  runApp(const CatatanPengeluaranApp());
}

class CatatanPengeluaranApp extends StatelessWidget {
  const CatatanPengeluaranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catatan Pengeluaran',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
      ),
      home: const HomePage(),
    );
  }
}

/* ================= MODEL ================= */
class Pengeluaran {
  String judul;
  String kategori;
  int nominal;

  Pengeluaran({
    required this.judul,
    required this.kategori,
    required this.nominal,
  });
}

/* ================= HOME PAGE ================= */
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Pengeluaran> data = [];

  void tambahData(Pengeluaran item) {
    setState(() => data.add(item));
  }

  void updateData(int index, Pengeluaran item) {
    setState(() => data[index] = item);
  }

  void hapusData(int index) {
    setState(() => data.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Pengeluaran 💸'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: data.isEmpty
          ? _emptyState(context)
          : Column(
              children: [
                Expanded(child: _listData()),
                _tombolTambah(context),
              ],
            ),
    );
  }

  /* ================= EMPTY STATE ================= */
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFF48FB1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dompet masih aman 😊',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Belum ada pengeluaran tercatat.\n'
              'Yuk mulai catat biar nggak nyesel 💸',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _tombolTambah(context),
          ],
        ),
      ),
    );
  }

  /* ================= LIST DATA ================= */
  Widget _listData() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Text(item.judul),
            subtitle: Text('${item.kategori} • Rp ${item.nominal}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✏️ UPDATE
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final hasil = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormPage(data: item),
                      ),
                    );
                    if (hasil != null) updateData(index, hasil);
                  },
                ),
                // 🗑 DELETE
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => hapusData(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* ================= TOMBOL TAMBAH ================= */
  Widget _tombolTambah(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () async {
            final hasil = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormPage()),
            );
            if (hasil != null) tambahData(hasil);
          },
          child: const Text(
            '+ Tambah Pengeluaran',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

/* ================= FORM PAGE ================= */
class FormPage extends StatefulWidget {
  final Pengeluaran? data;

  const FormPage({super.key, this.data});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final judulCtrl = TextEditingController();
  final kategoriCtrl = TextEditingController();
  final nominalCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      judulCtrl.text = widget.data!.judul;
      kategoriCtrl.text = widget.data!.kategori;
      nominalCtrl.text = widget.data!.nominal.toString();
    }
  }

  void simpan() {
    final hasil = Pengeluaran(
      judul: judulCtrl.text.trim(),
      kategori: kategoriCtrl.text.trim(),
      nominal: int.tryParse(nominalCtrl.text.trim()) ?? 0,
    );
    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data == null ? 'Tambah Pengeluaran' : 'Edit Pengeluaran',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: kategoriCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Kategori'),
                ),
                TextField(
                  controller: nominalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal',
                    prefixText: 'Rp ',
                    hintText: '15000',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: simpan,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}