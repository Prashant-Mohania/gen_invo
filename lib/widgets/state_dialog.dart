import 'package:flutter/material.dart';

import '../constants/constants.dart';

class StateDialog extends StatelessWidget {
  const StateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: Constants.state.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(Constants.state[index]),
            onTap: () {
              Navigator.pop(context, Constants.state[index]);
            },
          );
        },
      ),
    );
  }
}
