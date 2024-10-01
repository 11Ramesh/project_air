import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_air/function/backend/backend_bloc.dart';
import 'package:project_air/widgets/textShow.dart';

class OrderDataShow extends StatefulWidget {
  const OrderDataShow({super.key});

  @override
  State<OrderDataShow> createState() => _OrderDataShowState();
}

class _OrderDataShowState extends State<OrderDataShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<BackendBloc, BackendState>(
        builder: (context, state) {
          if (state is OrderFlightState) {
            String orderFlightID = state.orderFlightID;
            Map<String, dynamic> data = state.orderFlightData;
            return Center(
              child: Column(
                children: [
                  Textshow(
                    text: 'Order ID: $orderFlightID',
                    fontSize: 20,
                  ),
                  Textshow(
                    text: 'Email: ${data['contact']['emailAddress']}',
                    fontSize: 20,
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
