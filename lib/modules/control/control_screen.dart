import 'package:agre_lens_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../home/home_screen.dart';

class ControlScreen extends StatefulWidget {
   const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AppCubit.get(context).loadSavedControl();
    });
  }
  @override
  Widget build(BuildContext context) {
    const int infiniteScrollCount = 100000;
    const int middleIndex = infiniteScrollCount ~/ 2;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ControlResetState) {
          setState(() {}); 
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        String farmName = cubit.farmName ?? 'My Farm';

        return Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage('https://imgs.search.brave.com/XDXsj4-T6zC6JH_-R7szCwaAvL-QU25A2eewUNyvb1o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pNS53/YWxtYXJ0aW1hZ2Vz/LmNvbS9zZW8vUm9i/b3QtQ2FtZXJhLU9u/LVdoZWVscy1Eb3Vi/bGUtTGVucy1Nb3Zp/bmctUGV0LUNhbWVy/YS13LU5pZ2h0LVZp/c2lvbi0yLVdheS1U/YWxrLTEwODBQLVdp/RmktU21hbGwtUm9i/b3QtQ2FtLWZvci1D/YXRzLURvZ3NfZDgw/MjA0NzItNWE0YS00/YzUyLWE4MjItNmNh/Yzg3NTBiY2Q2LmE2/YTA2ZDk4NTg1NjQ2/NjQ5NGNlOWZmNzVj/OWZmZThiLmpwZWc_/b2RuSGVpZ2h0PTU4/MCZvZG5XaWR0aD01/ODAmb2RuQmc9RkZG/RkZG'), // استبدلها برابط صورتك أو الـ Stream
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.arrow_upward, () => print("Forward")),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(Icons.arrow_back, () => print("Left")),
                      const SizedBox(width: 15),
                      _buildControlButton(Icons.circle, () => print("Stop"), isCenter: true),
                      const SizedBox(width: 15),
                      _buildControlButton(Icons.arrow_forward, () => print("Right")),
                    ],
                  ),
                  SizedBox(height: 15,),
                
                  _buildControlButton(Icons.arrow_downward, () => print("Backward")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
;
        },
    );
  }
}

Widget _buildTimeItem(int value, int selectedValue) {
  return Center(
    child: Text(
      value.toString().padLeft(2, '0'),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: (value == selectedValue) ? Colors.black : Colors.grey,
      ),
    ),
  );
}

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {bool isCenter = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isCenter ? Colors.white : ColorManager.greenColor, // لون أخضر مشابه للصورة
          borderRadius: BorderRadius.circular(15),
          border: isCenter ? Border.all(color: ColorManager.greenColor, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 40,
          color: isCenter ? ColorManager.greenColor : Colors.white,
        ),
      ),
    );
  }






