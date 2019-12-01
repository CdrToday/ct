import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class ReportTile extends StatefulWidget {
  final BuildContext sContext;
  final String id;
  ReportTile({ this.sContext, this.id });
  
  createState() => _ReportTileState();
}


class _ReportTileState extends State<ReportTile> {
  String _value = '';

  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  report(BuildContext context) {
    alertInput(
      widget.sContext,
      title: '举报',
      content: Container(
        child: CupertinoTextField(
          autofocus: true,
          onChanged: changeValue,
          style: TextStyle(fontSize: 16.0),
          decoration: BoxDecoration(border: null),
          placeholder: "举报原因(选填)",
          placeholderStyle: TextStyle(
            fontSize: 14.0,
            height: 1.3,
            color: CtColors.gray2
          )
        ),
        color: CtColors.gray7,
        margin: EdgeInsets.only(top: 8.0),
      ),
      ok:Text("举报"),
      action: () async {
        Navigator.pop(context);

        load(widget.sContext, '请求中...');
        var r = await xReq.Requests.init();
        var res = await r.report(type: 'article', task: widget.id, content: _value);
        
        Navigator.pop(context);
        Navigator.pop(context);
        if (res.statusCode == 200) {
          info(widget.sContext, '感谢您的举报');
          return;
        }

        info(widget.sContext, '举报失败，请重试');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            Icons.report_problem, color: CtColors.primary, size: 22.0
          ),
          SizedBox(width: 10.0),
          Text('举报', style: TextStyle(color: CtColors.primary)),
        ],
      ),
      onTap: () => report(context),
    );
  }
}
