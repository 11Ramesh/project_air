import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/widgets/textShow.dart';

class NoData extends StatefulWidget {
  const NoData({super.key});

  @override
  State<NoData> createState() => _NoDataState();
}

class _NoDataState extends State<NoData> {
  late BackendBloc backendBloc;
  void initState() {
    iniitialize();
    super.initState();
  }

  iniitialize() async {
    backendBloc = BlocProvider.of<BackendBloc>(context);
  }

  void dispose() {
    backendBloc.add(emptyEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Textshow(
            text: "No Data Found", fontSize: 35, fontWeight: FontWeight.bold));
  }
}
