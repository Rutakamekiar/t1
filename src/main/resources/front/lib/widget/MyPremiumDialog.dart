import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/bloc/premium_bloc.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/utils/dialog_helper.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';

class MyPremiumDialog extends StatefulWidget {
  final VoidCallback onSuccess;

  MyPremiumDialog({
    this.onSuccess,
  });

  @override
  _MyPremiumDialogState createState() => _MyPremiumDialogState();
}

class _MyPremiumDialogState extends State<MyPremiumDialog> {
  final TextEditingController _premiumController = TextEditingController();
  final PremiumBloc _premiumBloc = PremiumBloc();

  bool _isLoading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _premiumBloc.premium.listen((event) {
      _setLoading(false);
      if (event.result == 1) {
        widget.onSuccess();
      } else {
        setState(() {
          _isError = true;
        });
      }
    }, onError: (e) {
      _setLoading(false);
      DialogHelper.showInformDialog(
          context, tr("error_occurred", args: [e.toString()]),
          button: tr("ok"), onPositive: () => Navigator.pop(context));
    });
  }

  @override
  void dispose() {
    _premiumBloc.dispose();
    _premiumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: SizedBox(
            height: 300,
            width: 505,
            child: Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
              child: dialogContent(context),
            ))));
  }

  dialogContent(BuildContext context) {
    return Column(
      children: <Widget>[
        AutoSizeText(tr("enter_code"),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        Expanded(
            child: Center(
              child: BaseTextField(
                  textEditingController: _premiumController,
                  enable: !_isLoading,
                  isError: _isError,
                  onSubmitted: (value) {
                    if (_premiumController.text.isNotEmpty) {
                      _setLoading(true);
                      _premiumBloc.getPremium(_premiumController.text);
                    }
                  },
                  label: "",
                  errorText: tr("code_error")),
            )),
        Row(
          children: [
            Visibility(
              visible: !_isLoading,
              child: Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: BaseButton(
                      onPressed: () => Navigator.pop(context),
                      title: tr("cancel"),
                      height: 37,
                      color: MyColors.grey,
                    ),
                  ),
              ),
            ),
            Expanded(
              child: BaseButton(
                isLoading: _isLoading,
                height: 37,
                title: tr("become_premium"),
                onPressed: () {
                  if (_premiumController.text.isNotEmpty) {
                    _setLoading(true);
                    _premiumBloc.getPremium(_premiumController.text);
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}
