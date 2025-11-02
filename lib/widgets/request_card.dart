import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onViewProfile;
  final bool showActions;

  const RequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onViewProfile,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (showActions) ...[
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      color: const Color(0xFF87a492),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      color: const Color(0xFFd68a7a),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.tag,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    request.category.displayName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.locationDot,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${request.city}, ${request.state}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (request.isVoluntary) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF87a492),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        FontAwesomeIcons.heart,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'BUSCO VOLUNTÁRIOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!request.isVoluntary)
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.dollarSign,
                          size: 16,
                          color: const Color(0xFFc9a56f),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          request.budget != null
                              ? 'R\$ ${request.budget!.toStringAsFixed(2)}'
                              : 'A Combinar',
                          style: const TextStyle(
                            color: Color(0xFFc9a56f),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(request.urgency).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      request.urgency,
                      style: TextStyle(
                        color: _getUrgencyColor(request.urgency),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (onViewProfile != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: onViewProfile,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.user,
                        size: 14,
                        color: const Color(0xFF5a7a6a),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ver perfil do solicitante',
                        style: const TextStyle(
                          color: Color(0xFF5a7a6a),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: const Color(0xFF5a7a6a),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'urgente':
        return const Color(0xFFd68a7a); // Coral rosado
      case 'médio':
        return const Color(0xFFddb87a); // Amarelo mostarda suave
      case 'baixo':
        return const Color(0xFFa8c9a4); // Verde claro
      default:
        return Colors.grey;
    }
  }
}
