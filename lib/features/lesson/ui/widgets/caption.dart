import 'package:flutter/material.dart';

class CaptionView extends StatelessWidget {
  final List<String> captions;

  const CaptionView({
    Key? key,
    required this.captions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 10),
      itemCount: captions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ImageIcon(
                AssetImage("assets/images/f7_hand-point-right.png"),
                color: Color(0xff02457A),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  captions[index],
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff02457A),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}