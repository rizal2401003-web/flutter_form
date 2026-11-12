import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulir Data Pengguna',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller (sudah terisi data Rizal)
  final _namaController = TextEditingController(text: 'Rizal Fany Triyanto');
  final _nimController = TextEditingController(text: '24670022');
  final _emailController = TextEditingController(text: 'mar56bel@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');

  bool _obscurePassword = true;

  // Radio: jenis kelamin
  String? _jenisKelamin = 'Laki-laki';

  // Checkbox: hobi (hanya Olahraga yang dicentang)
  bool _membaca = false;
  bool _olahraga = true;
  bool _musik = false;
  bool _fotografi = false;

  // Dropdown: program studi
  final List<String> _programStudi = [
    'Pendidikan Matematika',
    'Informatika',
    'Bisnis Digital',
    'Manajemen',
  ];
  String? _selectedProdi;

  // Persetujuan
  bool _setuju = false;
  String? _setujuError;
  String? _hobiError;

  // ===== Tambahan: Studi Kasus Pendaftaran Kegiatan =====
  final _teleponController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _alasanController = TextEditingController();

  final List<String> _daftarKegiatan = [
    'Seminar Nasional Teknologi',
    'Workshop Flutter',
    'Lomba Coding',
    'Bakti Sosial',
  ];
  String? _selectedKegiatan;
  DateTime? _tanggalKegiatan;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalKegiatan ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalKegiatan = picked;
        _tanggalController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _teleponController.dispose();
    _tanggalController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  List<String> get _hobiTerpilih {
    final list = <String>[];
    if (_membaca) list.add('Membaca');
    if (_olahraga) list.add('Olahraga');
    if (_musik) list.add('Musik');
    if (_fotografi) list.add('Fotografi');
    return list;
  }

  void _simpan() {
    final formValid = _formKey.currentState!.validate();

    setState(() {
      _hobiError =
          _hobiTerpilih.isEmpty ? 'Pilih minimal satu hobi' : null;
      _setujuError =
          !_setuju ? 'Anda harus menyetujui syarat dan ketentuan' : null;
    });

    if (formValid && _hobiError == null && _setujuError == null) {
      _tampilkanRingkasan();
    }
  }

  void _tampilkanRingkasan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Data Tersimpan'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _baris('Nama', _namaController.text),
              _baris('NIM', _nimController.text),
              _baris('Email', _emailController.text),
              _baris('Password', '•' * _passwordController.text.length),
              _baris('Jenis Kelamin', _jenisKelamin ?? '-'),
              _baris('Hobi', _hobiTerpilih.join(', ')),
              _baris('Program Studi', _selectedProdi ?? '-'),
              const Divider(),
              _baris('Telepon', _teleponController.text),
              _baris('Kegiatan', _selectedKegiatan ?? '-'),
              _baris('Tanggal', _tanggalController.text),
              _baris('Alasan', _alasanController.text),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(nilai)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        title: const Text('Formulir Data Pengguna'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Nama Lengkap =====
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== NIM =====
              TextFormField(
                controller: _nimController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'NIM harus berupa angka';
                  }
                  if (value.trim().length < 8) {
                    return 'NIM minimal 8 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Email =====
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'nama@email.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  final emailRegex =
                      RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Password =====
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password wajib diisi';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ===== Jenis Kelamin (Radio) =====
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Laki-laki'),
                value: 'Laki-laki',
                groupValue: _jenisKelamin,
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Perempuan'),
                value: 'Perempuan',
                groupValue: _jenisKelamin,
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // ===== Hobi (Checkbox) =====
              Row(
                children: [
                  const Text(
                    'Hobi ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '(boleh lebih dari satu)',
                    style: TextStyle(fontSize: 12, color: scheme.primary),
                  ),
                ],
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Membaca'),
                value: _membaca,
                onChanged: (value) {
                  setState(() {
                    _membaca = value!;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Olahraga'),
                value: _olahraga,
                onChanged: (value) {
                  setState(() {
                    _olahraga = value!;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Musik'),
                value: _musik,
                onChanged: (value) {
                  setState(() {
                    _musik = value!;
                  });
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Fotografi'),
                value: _fotografi,
                onChanged: (value) {
                  setState(() {
                    _fotografi = value!;
                  });
                },
              ),
              if (_hobiError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    _hobiError!,
                    style: TextStyle(color: scheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),

              // ===== Program Studi (Dropdown) =====
              DropdownButtonFormField<String>(
                value: _selectedProdi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Pilih program studi'),
                items: _programStudi
                    .map(
                      (prodi) => DropdownMenuItem<String>(
                        value: prodi,
                        child: Text(prodi),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProdi = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Program studi wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Tambahan: Pendaftaran Kegiatan =====
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Pendaftaran Kegiatan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 16),

              // Nomor Telepon
              TextFormField(
                controller: _teleponController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor telepon wajib diisi';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                    return 'Nomor telepon harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pilihan Kegiatan (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedKegiatan,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Pilih Kegiatan',
                  prefixIcon: Icon(Icons.event),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Pilih kegiatan yang diikuti'),
                items: _daftarKegiatan
                    .map(
                      (kegiatan) => DropdownMenuItem<String>(
                        value: kegiatan,
                        child: Text(kegiatan),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKegiatan = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Kegiatan wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tanggal Kegiatan (Date Picker)
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kegiatan',
                  hintText: 'dd/mm/yyyy',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickDate(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tanggal kegiatan wajib dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Alasan Mengikuti (Text Area)
              TextFormField(
                controller: _alasanController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Alasan Mengikuti Kegiatan',
                  hintText: 'Tuliskan alasan Anda...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alasan wajib diisi';
                  }
                  if (value.trim().length < 10) {
                    return 'Alasan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ===== Syarat & Ketentuan =====
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Saya menyetujui syarat dan ketentuan'),
                value: _setuju,
                onChanged: (value) {
                  setState(() {
                    _setuju = value!;
                    if (_setuju) _setujuError = null;
                  });
                },
              ),
              if (_setujuError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    _setujuError!,
                    style: TextStyle(color: scheme.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // ===== Tombol Simpan =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: const Icon(Icons.send),
                  label: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}