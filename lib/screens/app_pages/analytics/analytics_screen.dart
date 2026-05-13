import 'package:arogyamate/controllers/analytics_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hospital Insights",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<AnalyticsController>().refreshStats(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Consumer<AnalyticsController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isWide = constraints.maxWidth > 700;
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? constraints.maxWidth * 0.1 : 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Top Stat Cards ---
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            "Total Doctors",
                            ctrl.totalDoctors.toString(),
                            Icons.person_pin_rounded,
                            const [Color(0xFF6441A5), Color(0xFF2a0845)],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            "Appointments",
                            ctrl.totalAppointments.toString(),
                            Icons.event_available_rounded,
                            const [Color(0xFF11998e), Color(0xFF38ef7d)],
                          ),
                        ),
                      ],
                    ),
                const SizedBox(height: 30),

                // --- Department Pie Chart ---
                Text(
                  "Department Distribution",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  context,
                  SizedBox(
                    height: 250,
                    child: ctrl.appointmentsByDepartment.isEmpty
                        ? const Center(child: Text("No data available"))
                        : PieChart(
                            PieChartData(
                              sectionsSpace: 5,
                              centerSpaceRadius: 40,
                              sections: _buildPieSections(ctrl.appointmentsByDepartment),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),

                // --- Appointments Trend Line Chart ---
                Text(
                  "Appointment Trends",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  context,
                  SizedBox(
                    height: 250,
                    child: ctrl.appointmentsByDay.isEmpty
                        ? const Center(child: Text("No data available"))
                        : LineChart(
                            _buildLineChartData(context, ctrl.appointmentsByDay),
                          ),
                  ),
                ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
          const SizedBox(height: 15),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, int> data) {
    final List<Color> colors = [
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    int i = 0;
    return data.entries.map((entry) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        title: '${entry.key}\n${entry.value}',
        radius: 60,
        titleStyle: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  LineChartData _buildLineChartData(BuildContext context, Map<String, int> data) {
    // Sort days chronologically
    final sortedKeys = data.keys.toList()..sort();
    
    List<FlSpot> spots = [];
    for (int i = 0; i < sortedKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[sortedKeys[i]]!.toDouble()));
    }

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < 0 || value.toInt() >= sortedKeys.length) return const SizedBox();
              // Show only a few labels to avoid clutter
              if (sortedKeys.length > 5 && value.toInt() % (sortedKeys.length ~/ 3) != 0) return const SizedBox();
              
              String date = sortedKeys[value.toInt()];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  date.substring(date.length - 5), // Show MM-DD
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Theme.of(context).colorScheme.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
