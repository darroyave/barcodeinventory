import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeuButton extends StatefulWidget {
  final Widget child;
  final Function() onPressed;
  const NeuButton({super.key, required this.child, required this.onPressed});

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 100,
      child: NeumorphicButton(
        onPressed: widget.onPressed,
        duration: const Duration(milliseconds: 300),
        style: NeumorphicStyle(
          color: secondary,
          shape: NeumorphicShape.flat,
          intensity: isPressed ? 0.7 : 0.9,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(10),
          ),
          depth: isPressed ? -8 : 8,
          lightSource: LightSource.topLeft,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                height: 70, child: Image.asset('assets/images/barcode.png')),
            widget.child,
          ],
        ),
      ),
    );
  }
}
