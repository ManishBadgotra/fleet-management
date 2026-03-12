import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'models/vehicle.dart';
import 'ui/fleet_card.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // window_manager is desktop only — skip on Android/iOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const Size minSize = Size(400, 600);
    WindowOptions windowOptions = const WindowOptions(
      size: minSize,
      minimumSize: minSize,
      center: true,
      title: 'Fleet Management',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fleet Management",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 30),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        primary: true,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: const Icon(Icons.fire_truck),
          title: const Text(
            "Fleet Management",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ),
        body: const Listing(),
      ),
    );
  }
}

// ─── Shimmer helper ──────────────────────────────────────────────────────────

class _ShimmerBox extends StatefulWidget {
  final double width, height, radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ShimmerBox(width: 120, height: 16),
            SizedBox(height: 6),
            _ShimmerBox(width: 180, height: 13),
            SizedBox(height: 6),
            _ShimmerBox(width: 100, height: 13),
            SizedBox(height: 6),
            _ShimmerBox(width: 80, height: 26, radius: 20),
          ],
        ),
      ),
    );
  }
}

// ─── WrapGrid ────────────────────────────────────────────────────────────────

class _WrapGrid extends StatelessWidget {
  final int cols;
  final double spacing;
  final List<Widget> children;

  const _WrapGrid({
    required this.cols,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <List<Widget>>[];
    for (var i = 0; i < children.length; i += cols) {
      rows.add(
        children.sublist(
          i,
          (i + cols > children.length) ? children.length : i + cols,
        ),
      );
    }

    return Column(
      children: rows.map((rowItems) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(cols, (colIdx) {
              if (colIdx < rowItems.length) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: colIdx == 0 ? 0 : spacing / 2,
                      right: colIdx == cols - 1 ? 0 : spacing / 2,
                    ),
                    child: rowItems[colIdx],
                  ),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Alert banner row ────────────────────────────────────────────────────────

/// [activeFilter] — null means no filter active.
/// [AlertType.overDue] / [AlertType.dueIn] means that banner is active.
class _AlertBannerRow extends StatelessWidget {
  final int dueInCount;
  final int overdueCount;
  final AlertType? activeFilter;
  final ValueChanged<AlertType?> onFilterTap;

  const _AlertBannerRow({
    required this.dueInCount,
    required this.overdueCount,
    required this.activeFilter,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasAlerts = dueInCount > 0 || overdueCount > 0;

    if (!hasAlerts) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green.shade600,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "All vehicle documents are up to date.",
              style: TextStyle(color: Colors.green.shade800, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          if (overdueCount > 0)
            Expanded(
              child: _BannerTile(
                icon: Icons.warning_amber_rounded,
                label: "$overdueCount Overdue",
                sublabel: "Tap to filter",
                color: Colors.red,
                isActive: activeFilter == AlertType.overDue,
                onTap: () => onFilterTap(
                  activeFilter == AlertType.overDue ? null : AlertType.overDue,
                ),
              ),
            ),
          if (overdueCount > 0 && dueInCount > 0) const SizedBox(width: 8),
          if (dueInCount > 0)
            Expanded(
              child: _BannerTile(
                icon: Icons.access_time_rounded,
                label: "$dueInCount Due Soon",
                sublabel: "Tap to filter",
                color: Colors.orange,
                isActive: activeFilter == AlertType.dueIn,
                onTap: () => onFilterTap(
                  activeFilter == AlertType.dueIn ? null : AlertType.dueIn,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final MaterialColor color;
  final bool isActive;
  final VoidCallback onTap;

  const _BannerTile({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // Filled background when active, light when inactive
          color: isActive ? color.shade100 : color.shade50,
          border: Border.all(
            color: isActive ? color.shade700 : color.shade300,
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color.shade700, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color.shade900,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    // Show "Tap to clear" hint when active
                    isActive ? "Tap to clear filter" : sublabel,
                    style: TextStyle(color: color.shade700, fontSize: 11),
                  ),
                ],
              ),
            ),
            // Active indicator icon
            if (isActive)
              Icon(Icons.filter_alt, color: color.shade700, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Active filter chip ───────────────────────────────────────────────────────

class _ActiveFilterChip extends StatelessWidget {
  final AlertType filter;
  final int count;
  final VoidCallback onClear;

  const _ActiveFilterChip({
    required this.filter,
    required this.count,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = filter == AlertType.overDue;
    final color = isOverdue ? Colors.red : Colors.orange;
    final label = isOverdue ? 'Overdue vehicles' : 'Due Soon vehicles';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          // Filter chip
          Chip(
            avatar: Icon(
              isOverdue
                  ? Icons.warning_amber_rounded
                  : Icons.access_time_rounded,
              size: 16,
              color: color.shade700,
            ),
            label: Text(
              '$label ($count)',
              style: TextStyle(
                color: color.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: color.shade50,
            side: BorderSide(color: color.shade300),
            deleteIcon: Icon(Icons.close, size: 16, color: color.shade700),
            onDeleted: onClear,
          ),
          const SizedBox(width: 8),
          // Show All button
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.list_alt, size: 16),
            label: const Text('Show All', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Listing ─────────────────────────────────────────────────────────────────

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  final _searchController = TextEditingController();

  bool _loading = true;
  String? _error;

  List<FleetModel> _allVehicles = [];
  List<FleetModel> _filtered = [];

  // null = no filter, AlertType.overDue / AlertType.dueIn = active filter
  AlertType? _alertFilter;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _fetchVehicles() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final vehicles = await Vehicle.getVehicles();
      setState(() {
        _allVehicles = vehicles;
        _filtered = vehicles;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Called when search text changes — respects active alert filter too.
  void _onSearchChanged() => _applyFilters();

  /// Called when a banner tile is tapped.
  void _onAlertFilterTap(AlertType? type) {
    setState(() {
      _alertFilter = type;
      // Clear search when switching to alert filter for clean UX
      if (type != null) _searchController.clear();
    });
    _applyFilters();
  }

  /// Single source of truth — applies both search + alert filter.
  void _applyFilters() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      var list = _allVehicles;

      // Apply alert type filter first
      if (_alertFilter != null) {
        list = list.where((v) => _resolveAlertType(v) == _alertFilter).toList();
      }

      // Then apply search on top
      if (q.isNotEmpty) {
        list = list
            .where((v) => v.licensePlate?.toLowerCase().contains(q) ?? false)
            .toList();
      }

      _filtered = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dueInCount = Vehicle.dueIn().length;
    final overdueCount = Vehicle.expired().length;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // ── Search bar ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            controller: _searchController,
            hintText: "Search by license plate…",
            elevation: const WidgetStatePropertyAll(4),
            leading: const Icon(Icons.search_outlined),
          ),
        ),

        // ── Alert banner row ────────────────────────────────────
        if (!_loading && _error == null)
          _AlertBannerRow(
            dueInCount: dueInCount,
            overdueCount: overdueCount,
            activeFilter: _alertFilter,
            onFilterTap: _onAlertFilterTap,
          ),

        // ── Active filter chip + Clear / Show All ───────────────
        if (_alertFilter != null && !_loading && _error == null)
          _ActiveFilterChip(
            filter: _alertFilter!,
            count: _filtered.length,
            onClear: () => _onAlertFilterTap(null),
          ),

        const SizedBox(height: 4),

        // ── Body ────────────────────────────────────────────────
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              "Failed to load vehicles",
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              _error!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _fetchVehicles,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final int cols = w >= 960
            ? 3
            : w >= 600
            ? 2
            : 1;
        const double spacing = 8;

        if (_loading) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: _WrapGrid(
              cols: cols,
              spacing: spacing,
              children: List.generate(6, (_) => const _SkeletonCard()),
            ),
          );
        }

        if (_filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  _alertFilter != null
                      ? 'No ${_alertFilter == AlertType.overDue ? 'overdue' : 'due soon'} vehicles found'
                      : 'No vehicles match "${_searchController.text}"',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                // Show All button in empty state too
                if (_alertFilter != null) ...[
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => _onAlertFilterTap(null),
                    child: const Text('Show All Vehicles'),
                  ),
                ],
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: _WrapGrid(
            cols: cols,
            spacing: spacing,
            children: List.generate(_filtered.length, (i) {
              final v = _filtered[i];
              final alertType = _resolveAlertType(v);
              return FleetCard(
                license: v.licensePlate ?? '—',
                vehicleModel: _vehicleLabel(v.brandName, v.brandModel),
                voilation: _resolveViolationLabel(v, alertType),
                voilationText: _resolveViolationText(v, alertType),
                alertType: alertType,
                registrationDate: v.registrationDate ?? '—',
                puccValidTill: v.puccUpto ?? '—',
                insuranceLastDate: v.insuranceExpiry ?? '—',
                tax: v.taxUpto ?? '—',
                permitDate: v.permitValidUpto,
                nationalPermitDate: v.nationalPermitUpto,
              );
            }),
          ),
        );
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  AlertType _resolveAlertType(FleetModel v) {
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 30));
    bool hasExpired = false;
    bool hasDueIn = false;

    for (final date in _documentDates(v)) {
      if (date == null) continue;
      if (date.isBefore(now)) {
        hasExpired = true;
        break;
      }
      if (date.isBefore(threshold)) hasDueIn = true;
    }

    if (hasExpired) return AlertType.overDue;
    if (hasDueIn) return AlertType.dueIn;
    return AlertType.okay;
  }

  String _resolveViolationLabel(FleetModel v, AlertType type) {
    if (type == AlertType.okay) return "All Okay";
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 30));

    final labels = <String, DateTime?>{
      'Insurance': Vehicle.parseDate(v.insuranceExpiry),
      'Fitness': Vehicle.parseDate(v.fitUpTo),
      'National Permit': Vehicle.parseDate(v.nationalPermitUpto),
      'PUC': Vehicle.parseDate(v.puccUpto),
      'Tax': Vehicle.parseDate(v.taxUpto),
      'Permit': Vehicle.parseDate(v.permitValidUpto),
    };

    for (final entry in labels.entries) {
      final d = entry.value;
      if (d == null) continue;
      if (type == AlertType.overDue && d.isBefore(now)) {
        return "${entry.key} Expired";
      }
      if (type == AlertType.dueIn && d.isAfter(now) && d.isBefore(threshold)) {
        return "${entry.key} Expiring";
      }
    }
    return "Document Alert";
  }

  String _resolveViolationText(FleetModel v, AlertType type) {
    if (type == AlertType.okay) return "Nothing needs attention";
    final now = DateTime.now();
    final threshold = now.add(const Duration(days: 30));

    final labels = <String, DateTime?>{
      'Insurance': Vehicle.parseDate(v.insuranceExpiry),
      'Fitness': Vehicle.parseDate(v.fitUpTo),
      'National Permit': Vehicle.parseDate(v.nationalPermitUpto),
      'PUC': Vehicle.parseDate(v.puccUpto),
      'Tax': Vehicle.parseDate(v.taxUpto),
      'Permit': Vehicle.parseDate(v.permitValidUpto),
    };

    for (final entry in labels.entries) {
      final d = entry.value;
      if (d == null) continue;
      if (type == AlertType.overDue && d.isBefore(now)) {
        final days = now.difference(d).inDays;
        return "${entry.key} expired $days day${days == 1 ? '' : 's'} ago";
      }
      if (type == AlertType.dueIn && d.isAfter(now) && d.isBefore(threshold)) {
        final days = d.difference(now).inDays;
        return "${entry.key} expiring in $days day${days == 1 ? '' : 's'}";
      }
    }
    return "Check vehicle documents";
  }

  String _vehicleLabel(String? brand, String? model) {
    final full = '${brand ?? ''} ${model ?? ''}'.trim();
    return full.length > 16 ? '${full.substring(0, 12)}…' : full;
  }

  List<DateTime?> _documentDates(FleetModel v) => [
    Vehicle.parseDate(v.insuranceExpiry),
    Vehicle.parseDate(v.fitUpTo),
    Vehicle.parseDate(v.nationalPermitUpto),
    Vehicle.parseDate(v.puccUpto),
    Vehicle.parseDate(v.taxUpto),
    Vehicle.parseDate(v.permitValidUpto),
  ];
}
