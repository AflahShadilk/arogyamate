import 'package:arogyamate/controllers/appointment_controller.dart';
import 'package:arogyamate/controllers/session_controller.dart';
import 'package:arogyamate/data_base/models/appointment_model.dart';
import 'package:arogyamate/screens/app_pages/appoinment_section/add_appoinment.dart';
import 'package:arogyamate/screens/app_pages/appoinment_section/edit_appoinment.dart';
import 'package:arogyamate/screens/app_pages/patient/patient_history_screen.dart';
import 'package:arogyamate/utilities/reporting/pdf_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecieptPage extends StatefulWidget {
  final AppointModel? appoint;
  const RecieptPage({super.key, this.appoint});

  @override
  State<RecieptPage> createState() => _RecieptPageState();
}

class _RecieptPageState extends State<RecieptPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  final List<String> _statusFilters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusFilters.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _selectedFilter() => _statusFilters[_tabController.index];

  List<AppointModel> _applyFilters(List<AppointModel> all) {
    final filter = _selectedFilter();
    final query = _searchController.text.trim().toLowerCase();
    return all.where((a) {
      final matchStatus = filter == 'All' || (a.status ?? 'Upcoming') == filter;
      final matchSearch = query.isEmpty ||
          (a.name ?? '').toLowerCase().contains(query) ||
          (a.doctorName ?? '').toLowerCase().contains(query) ||
          (a.department ?? '').toLowerCase().contains(query);
      return matchStatus && matchSearch;
    }).toList();
  }

  Color _statusColor(String? status) {
    switch (status ?? 'Upcoming') {
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return const Color(0xFF4D8AFF);
    }
  }

  IconData _statusIcon(String? status) {
    switch (status ?? 'Upcoming') {
      case 'Completed':
        return Icons.check_circle_rounded;
      case 'Cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Appointments',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: theme.cardColor,
        elevation: 0,
        actions: const [
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
          tabs: _statusFilters.map((f) => Tab(text: f)).toList(),
        ),
      ),
      body: Column(
        children: [
          // ─── Search Bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by patient, doctor...',
                hintStyle: GoogleFonts.poppins(fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded,
                    color: theme.colorScheme.primary.withOpacity(0.6)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // ─── List ────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<AppointmentController>(
              builder: (context, ctrl, _) {
                final filtered = _applyFilters(ctrl.appointments);
                if (filtered.isEmpty) {
                  return _buildEmptyState(theme);
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildAppointmentCard(
                        context, theme, ctrl, filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddAppointmentScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Appointment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, ThemeData theme,
      AppointmentController ctrl, AppointModel data) {
    final status = data.status ?? 'Upcoming';
    final statusColor = _statusColor(status);
    final statusIcon = _statusIcon(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Card Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                // Avatar placeholder
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded,
                      color: theme.colorScheme.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name ?? 'Unknown Patient',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Dr. ${data.doctorName ?? 'N/A'} · ${data.department ?? 'N/A'}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info Row ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _infoChip(
                    theme, Icons.calendar_today_rounded, data.date ?? 'N/A'),
                const SizedBox(width: 8),
                _infoChip(
                    theme, Icons.access_time_rounded, data.time ?? 'N/A'),
                const SizedBox(width: 8),
                _infoChip(theme, Icons.bloodtype_rounded, data.blood ?? 'N/A'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Actions Divider ───────────────────────────────────────────────
          Divider(
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.08)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              children: [
                // Status Change
                if (data.status != 'Completed' && data.status != 'Cancelled')
                  PopupMenuButton<String>(
                    tooltip: 'Change status',
                    icon: Icon(Icons.more_horiz_rounded,
                        size: 20, color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (newStatus) async {
                      data.status = newStatus;
                      await ctrl.update(data);
                      setState(() {});
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'Upcoming',
                          child: Text('Mark Upcoming')),
                      const PopupMenuItem(
                          value: 'Completed',
                          child: Text('Mark Completed')),
                      const PopupMenuItem(
                          value: 'Cancelled',
                          child: Text('Mark Cancelled')),
                    ],
                  ),
                const Spacer(),
                // PDF
                Consumer<SessionController>(
                  builder: (context, session, _) => IconButton(
                    icon: Icon(Icons.picture_as_pdf_rounded,
                        size: 19, color: theme.colorScheme.primary),
                    tooltip: 'Export PDF',
                    onPressed: () {
                      PdfHelper.generateIndividualReceipt(
                        hospitalName: session.hospitalName ?? 'ArogyaMate',
                        hospitalId: session.hospitalId ?? 'N/A',
                        appointment: data,
                      );
                    },
                  ),
                ),
                // History
                IconButton(
                  icon: Icon(Icons.history_rounded,
                      size: 19, color: theme.colorScheme.primary),
                  tooltip: 'Patient History',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PatientHistoryScreen(
                        phone: data.phone ?? '',
                        patientName: data.name ?? 'Patient',
                      ),
                    ));
                  },
                ),
                // Edit
                IconButton(
                  icon: Icon(Icons.edit_rounded,
                      size: 19, color: theme.colorScheme.primary),
                  tooltip: 'Edit',
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditAppoinment(appoint: data),
                    ));
                  },
                ),
                // Delete
                IconButton(
                  icon: Icon(Icons.delete_rounded,
                      size: 19, color: theme.colorScheme.error),
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, ctrl, data),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(ThemeData theme, IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 12, color: theme.colorScheme.primary.withOpacity(0.7)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodySmall?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final filter = _selectedFilter();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_busy_rounded,
              size: 56,
              color: theme.colorScheme.primary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            filter == 'All'
                ? 'No appointments yet'
                : 'No $filter appointments',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filter == 'All'
                ? 'Tap + to book the first appointment'
                : 'Nothing to show for this status',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppointmentController ctrl,
      AppointModel appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Appointment',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Remove appointment for ${appointment.name ?? "this patient"}?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ctrl.delete(appointment.id!);
              Navigator.pop(context);
            },
            child: Text('Delete',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
