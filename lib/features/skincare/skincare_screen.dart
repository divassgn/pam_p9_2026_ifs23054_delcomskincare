import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/skincare_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/theme_notifier.dart';
import '../../data/models/skincare_model.dart';
import '../auth/login_screen.dart';

class SkincareScreen extends StatefulWidget {
  @override
  State<SkincareScreen> createState() => _SkincareScreenState();
}

class _SkincareScreenState extends State<SkincareScreen> {
  final ScrollController _scrollController = ScrollController();

  // Pilihan jenis kulit
  final List<String> _skinTypes = [
    'normal', 'oily', 'dry', 'combination', 'sensitive'
  ];
  String _selectedSkinType = 'normal';

  @override
  void initState() {
    super.initState();
    final auth     = context.read<AuthProvider>();
    final provider = context.read<SkincareProvider>();
    provider.fetchRecommendations(auth.token!);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        provider.fetchRecommendations(auth.token!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy, HH:mm").format(parsed);
    } catch (e) {
      return date;
    }
  }

  String _skinTypeLabel(String type) {
    switch (type) {
      case 'oily':        return 'Berminyak';
      case 'dry':         return 'Kering';
      case 'combination': return 'Kombinasi';
      case 'sensitive':   return 'Sensitif';
      default:            return 'Normal';
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout"),
        content: Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              context.read<SkincareProvider>().clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _showGenerateDialog() {
    final concernController = TextEditingController();
    _selectedSkinType = 'normal';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (stfContext, setDialogState) {
            return Consumer<SkincareProvider>(
              builder: (context, provider, _) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Text("🌿 "),
                      Text("Rekomendasi Skincare"),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Keluhan Kulit",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        TextField(
                          controller: concernController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                "contoh: jerawat meradang, kulit kusam, flek hitam...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Color(0xFFEC4899), width: 2),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Jenis Kulit",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _skinTypes.map((type) {
                            final selected = _selectedSkinType == type;
                            return ChoiceChip(
                              label: Text(_skinTypeLabel(type)),
                              selected: selected,
                              selectedColor: Color(0xFFEC4899),
                              labelStyle: TextStyle(
                                color: selected ? Colors.white : null,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                setDialogState(
                                    () => _selectedSkinType = type);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: provider.isGenerating
                          ? null
                          : () => Navigator.pop(dialogContext),
                      child: Text("Batal"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFEC4899),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: provider.isGenerating
                          ? null
                          : () async {
                              final concern = concernController.text.trim();
                              if (concern.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Keluhan kulit wajib diisi."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final token =
                                  context.read<AuthProvider>().token ?? '';
                              try {
                                await provider.generate(
                                    concern, _selectedSkinType, token);
                                Navigator.pop(dialogContext);
                              } catch (e) {
                                Navigator.pop(dialogContext);
                                final msg = e
                                    .toString()
                                    .replaceFirst('Exception: ', '');
                                if (msg.contains("Sesi habis")) {
                                  context.read<AuthProvider>().logout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(msg),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                      child: provider.isGenerating
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Menganalisis..."),
                              ],
                            )
                          : Text("Analisis"),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDelete(SkincareRecommendation rec) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Hapus Rekomendasi"),
        content: Text("Hapus rekomendasi untuk \"${rec.productName}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              final token = context.read<AuthProvider>().token ?? '';
              try {
                await context.read<SkincareProvider>().delete(rec.id, token);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        e.toString().replaceFirst('Exception: ', '')),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(SkincareRecommendation item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEC4899).withValues(alpha: 0.3),
            blurRadius: 14,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: nomor, jenis kulit, tanggal, delete
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "#${index + 1}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _skinTypeLabel(item.skinType),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Spacer(),
                Text(
                  formatDate(item.createdAt),
                  style: TextStyle(color: Colors.white60, fontSize: 10),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _confirmDelete(item),
                  child: Icon(Icons.delete_outline,
                      color: Colors.white60, size: 20),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Keluhan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.face_retouching_natural,
                    color: Colors.white70, size: 16),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.skinConcern,
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),
            Divider(color: Colors.white24, thickness: 1),
            SizedBox(height: 10),

            // Nama produk
            Text(
              item.productName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.productType,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            SizedBox(height: 12),

            // Bahan aktif
            _infoBlock(
              icon: Icons.science_outlined,
              label: "Bahan Aktif",
              value: item.keyIngredients,
            ),
            SizedBox(height: 8),

            // Cara pemakaian
            _infoBlock(
              icon: Icons.format_list_numbered,
              label: "Cara Pemakaian",
              value: item.howToUse,
            ),
            SizedBox(height: 8),

            // Saran
            _infoBlock(
              icon: Icons.lightbulb_outline,
              label: "Saran AI",
              value: item.advice,
              highlight: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBlock({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 14),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SkincareProvider>();
    final theme    = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delcom Skincare AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode),
            onPressed: theme.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGenerateDialog,
        icon: Icon(Icons.auto_awesome),
        label: Text("Analisis Kulit"),
        backgroundColor: Color(0xFFEC4899),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          provider.recommendations.isEmpty && !provider.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.spa_rounded,
                          size: 80,
                          color: Colors.pink.withValues(alpha: 0.3)),
                      SizedBox(height: 16),
                      Text(
                        "Belum ada rekomendasi",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Tap \"Analisis Kulit\" untuk mulai",
                        style:
                            TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 120),
                  itemCount: provider.recommendations.length + 1,
                  itemBuilder: (context, index) {
                    if (index < provider.recommendations.length) {
                      return _buildCard(
                          provider.recommendations[index], index);
                    } else {
                      return provider.isLoading
                          ? Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                      color: Color(0xFFEC4899)),
                                  SizedBox(height: 8),
                                  Text("Loading..."),
                                ],
                              ),
                            )
                          : SizedBox();
                    }
                  },
                ),

          // Overlay saat generating
          if (provider.isGenerating)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFEC4899)),
                    SizedBox(height: 16),
                    Text(
                      "AI sedang menganalisis kulitmu... 🌿",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
