import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/contact.dart';
import '../../constants/app_colors.dart';

class ContactsListSheet extends StatelessWidget {
  final List<Contact> contacts;
  final String? title;

  const ContactsListSheet({
    super.key,
    required this.contacts,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title ?? 'All Contacts',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${contacts.length} contacts',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: 24),
                
                ...contacts.map((contact) => _buildContactCard(context, contact)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard(BuildContext context, Contact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.grey200,
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.type.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contact.type.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
            
            if (contact.email != null || contact.phone != null) ...[
              const SizedBox(height: 12),
              if (contact.email != null)
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 14,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      contact.email!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              if (contact.phone != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14,
                      color: AppColors.grey500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      contact.phone!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
            
            if (contact.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: contact.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.grey700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
