// ==================== RICH TEXT EDITOR ====================
import 'package:flutter/material.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_controller/create_recipes_controller.dart';


class RichTextEditor extends StatefulWidget {
  final int index;
  final String hint;
  final InstructionStep instruction;
  final Function(String) onChanged;

  const RichTextEditor({
    Key? key,
    required this.index,
    required this.hint,
    required this.instruction,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showToolbar = false;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showToolbar = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
  }

  void _changeTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
      color: _textColor,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _focusNode.hasFocus ? const Color(0xFF2D5016) : const Color(0xFFE0E0E0),
              width: _focusNode.hasFocus ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 3,
            style: _getTextStyle(),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
        if (_showToolbar) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildToolbarButton(
                  icon: Icons.format_bold,
                  isActive: _isBold,
                  onTap: _toggleBold,
                  tooltip: 'Bold',
                ),
                const SizedBox(width: 4),
                _buildToolbarButton(
                  icon: Icons.format_italic,
                  isActive: _isItalic,
                  onTap: _toggleItalic,
                  tooltip: 'Italic',
                ),
                const SizedBox(width: 4),
                _buildToolbarButton(
                  icon: Icons.format_underline,
                  isActive: _isUnderline,
                  onTap: _toggleUnderline,
                  tooltip: 'Underline',
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 8),
                _buildColorButton(Colors.black),
                const SizedBox(width: 4),
                _buildColorButton(Colors.red),
                const SizedBox(width: 4),
                _buildColorButton(Colors.blue),
                const SizedBox(width: 4),
                _buildColorButton(Colors.green),
                const SizedBox(width: 4),
                _buildColorButton(Colors.orange),
                const SizedBox(width: 4),
                _buildColorButton(Colors.purple),
                const Spacer(),
                _buildToolbarButton(
                  icon: Icons.format_align_left,
                  isActive: false,
                  onTap: () {},
                  tooltip: 'Align Left',
                ),
                const SizedBox(width: 4),
                _buildToolbarButton(
                  icon: Icons.format_align_center,
                  isActive: false,
                  onTap: () {},
                  tooltip: 'Align Center',
                ),
                const SizedBox(width: 4),
                _buildToolbarButton(
                  icon: Icons.format_list_bulleted,
                  isActive: false,
                  onTap: () {},
                  tooltip: 'Bullet List',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE8F5E9) : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? const Color(0xFF2D5016) : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isActive = _textColor == color;
    return InkWell(
      onTap: () => _changeTextColor(color),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? const Color(0xFF2D5016) : Colors.grey[300]!,
            width: isActive ? 2 : 1,
          ),
        ),
        child: isActive
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}