import 'package:bg4102_software/Utilities/customAppbar.dart';
import 'package:bg4102_software/Utilities/learnpages.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/view/learn_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnListScreen extends StatelessWidget {
  const LearnListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Learn More About AUD',
        fontSize: 25,
        actions: null,
        leading: null,
      ),
      body: ListView.builder(
        itemCount: learnList.length,
        itemBuilder: (context, index) {
          Learn learn = learnList[index];
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeVertical * 0.8),
            child: Container(
              height: SizeConfig.blockSizeVertical * 12,
              child: Card(
                borderOnForeground: true,
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: ListTile(
                    title: Text(
                      learn.title,
                      style: GoogleFonts.bebasNeue(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    subtitle: Text(
                      learn.author,
                      style: GoogleFonts.bebasNeue(
                          color: Colors.blueGrey[700],
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    leading: Image.network(
                      learn.imageUrl,
                      height: 90,
                      width: 90,
                    ),
                    trailing: const Icon(Icons.arrow_forward_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearnDetailsScreen(learn),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
