import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final TextEditingController _commentController = TextEditingController();

  List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب تعليقك...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: _commentController.text.isEmpty
                    ? null
                    : () {
                        // إضافة التعليق إلى قائمة التعليقات
                        setState(() {
                          comments.add(_commentController.text);
                          _commentController.clear();
                        });
                      },
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    this.fontsize = 12,
    required this.iconSize,
    required this.borderRadius,
    required this.icon,
    this.isSpacer = false,
  }) : super(key: key);

  final String text;
  final Color color;
  final double fontsize, borderRadius;
  final double iconSize;
  final IconData icon;
  final VoidCallback press;
  final bool isSpacer;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: press,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: const Color(0xFF5C2D91),
          ),
          isSpacer
              ? const Spacer()
              : SizedBox(
                  width: 4.w,
                ),
          Text(
            text,
            style: TextStyle(fontSize: fontsize, color: const Color(0xFF5C2D91)),
          ),
        ],
      ),
    );
  }
}
