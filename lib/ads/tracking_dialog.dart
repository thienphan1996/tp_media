import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTrackingDialog(BuildContext context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 16),
      const Text('Bạn thân mến', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Text(
        'Chúng tôi quan tâm đến quyền riêng tư và bảo mật dữ liệu của bạn. '
        'Ứng dụng có thể tiếp tục sử dụng dữ liệu của bạn để điều chỉnh quảng cáo cho phù hợp với bạn không? '
        'Bạn có thể thay đổi lựa chọn của mình bất cứ lúc nào trong cài đặt ứng dụng.'
        'Cảm ơn bạn.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Tiếp tục', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    ],
  ),
);

Future<void> showTrackingDialog(BuildContext context, Widget? dialogContent) async {
  await showCupertinoDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: dialogContent ?? buildTrackingDialog(context),
      );
    },
  );
}
