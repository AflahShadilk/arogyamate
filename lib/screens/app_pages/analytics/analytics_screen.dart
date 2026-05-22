import 'package:arogyamate/controllers/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int? _touchedPieIndex;

  static const List<Color> _pieColors = [
    Color(0xFF4D8AFF),
    Color(0xFF26A69A),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFFAB47BC),
    Color(0xFF29B6F6),
    Color(0xFF66BB6A),
    Color(0xFFEF5350),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Hospital Insights',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: theme.cardColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<AnalyticsController>().refreshStats(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<AnalyticsController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 3,
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth > 700;
              return RefreshIndicator(
                onRefresh: () => ctrl.refreshStats(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? constraints.maxWidth * 0.08 : 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Metric Cards ───────────────────────────────────────
                      isTablet
                          ? Row(children: [
                              Expanded(child: _buildAppointmentsCard(ctrl)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTopDoctorCard(ctrl)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildDoctorsCard(ctrl)),
                            ])
                          : Column(children: [
                              Row(children: [
                                Expanded(child: _buildAppointmentsCard(ctrl)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildTopDoctorCard(ctrl)),
                              ]),
                              const SizedBox(height: 12),
                              _buildDoctorsCard(ctrl),
                            ]),

                      const SizedBox(height: 28),

                      // ─── Department Pie Chart ────────────────────────────────
                      _sectionTitle('Department Distribution'),
                      const SizedBox(height: 16),
                      _buildSectionCard(
                        theme,
                        ctrl.appointmentsByDepartment.isEmpty
                            ? _buildEmptyState(theme, 'No department data yet')
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 230,
                                    child: PieChart(
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback: (event, pieTouchResponse) {
                                            setState(() {
                                              if (!event.isInterestedForInteractions ||
                                                  pieTouchResponse == null ||
                                                  pieTouchResponse.touchedSection == null) {
                                                _touchedPieIndex = -1;
                                                return;
                                              }
                                              _touchedPieIndex = pieTouchResponse
                                                  .touchedSection!.touchedSectionIndex;
                                            });
                                          },
                                        ),
                                        sectionsSpace: 4,
                                        centerSpaceRadius: 45,
                                        sections: _buildPieSections(
                                          ctrl.appointmentsByDepartment,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Legend
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    children: _buildLegend(
                                      ctrl.appointmentsByDepartment,
                                      theme,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 28),

                      // ─── Appointment Trends Line Chart ───────────────────────
                      _sectionTitle('Appointment Trends'),
                      const SizedBox(height: 16),
                      _buildSectionCard(
                        theme,
                        ctrl.appointmentsByDay.isEmpty
                            ? _buildEmptyState(theme, 'No trend data yet')
                            : SizedBox(
                                height: 220,
                                child: LineChart(
                                  _buildLineChartData(context, ctrl.appointmentsByDay),
                                ),
                              ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ─── Metric Cards ────────────────────────────────────────────────────────────

  Widget _buildAppointmentsCard(AnalyticsController ctrl) {
    return _buildMetricCard(
      icon: Icons.event_available_rounded,
      label: 'Total Appointments',
      value: ctrl.totalAppointments.toString(),
      gradient: const [Color(0xFF00BCD4), Color(0xFF0097A7)],
    );
  }

  Widget _buildTopDoctorCard(AnalyticsController ctrl) {
    return _buildMetricCard(
      icon: Icons.emoji_events_rounded,
      label: 'Top Doctor',
      value: ctrl.topDoctor ?? '—',
      gradient: const [Color(0xFF43A047), Color(0xFF1B5E20)],
      isSmallValue: (ctrl.topDoctor?.length ?? 0) > 10,
    );
  }

  Widget _buildDoctorsCard(AnalyticsController ctrl) {
    return _buildMetricCard(
      icon: Icons.people_alt_rounded,
      label: 'Total Doctors',
      value: ctrl.totalDoctors.toString(),
      gradient: const [Color(0xFF5C6BC0), Color(0xFF283593)],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
    bool isSmallValue = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isSmallValue ? 14 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pie Chart Helpers ────────────────────────────────────────────────────────

  List<PieChartSectionData> _buildPieSections(Map<String, int> data) {
    final total = data.values.fold(0, (a, b) => a + b);
    int i = 0;
    return data.entries.map((entry) {
      final isTouched = i == _touchedPieIndex;
      final pct = total > 0 ? (entry.value / total * 100).toStringAsFixed(1) : '0';
      final color = _pieColors[i % _pieColors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: isTouched ? '$pct%' : '',
        radius: isTouched ? 72 : 58,
        titleStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.key,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, int> data, ThemeData theme) {
    int i = 0;
    return data.entries.map((entry) {
      final color = _pieColors[i % _pieColors.length];
      i++;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            '${entry.key} (${entry.value})',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      );
    }).toList();
  }

  // ─── Line Chart ───────────────────────────────────────────────────────────────

  LineChartData _buildLineChartData(BuildContext context, Map<String, int> data) {
    final theme = Theme.of(context);
    final sortedKeys = data.keys.toList()..sort();
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[sortedKeys[i]]!.toDouble()));
    }

    final maxY = (data.values.isEmpty ? 5 : data.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1;

    return LineChartData(
      minY: 0,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY > 5 ? (maxY / 4).ceilToDouble() : 1,
        getDrawingHorizontalLine: (v) => FlLine(
          color: theme.colorScheme.outline.withOpacity(0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: sortedKeys.length > 6 ? (sortedKeys.length / 4).ceilToDouble() : 1,
            getTitlesWidget: (value, meta) {
              final idx = value.toInt();
              if (idx < 0 || idx >= sortedKeys.length) return const SizedBox.shrink();
              final raw = sortedKeys[idx];
              final parts = raw.split('-');
              final label = parts.length >= 2 ? '${parts[parts.length - 2]}/${parts[parts.length - 1]}' : raw;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 9, color: theme.textTheme.bodySmall?.color),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: maxY > 5 ? (maxY / 4).ceilToDouble() : 1,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: GoogleFonts.poppins(fontSize: 9, color: theme.textTheme.bodySmall?.color),
            ),
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: theme.colorScheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
              radius: 4,
              color: theme.colorScheme.primary,
              strokeColor: Colors.white,
              strokeWidth: 2,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.25),
                theme.colorScheme.primary.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Utility Widgets ────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildSectionCard(ThemeData theme, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 40, color: theme.colorScheme.primary.withOpacity(0.3)),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
