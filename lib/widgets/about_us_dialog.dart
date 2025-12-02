import 'package:flutter/material.dart';

void showCustomAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AboutUsDialog();
    },
  );
}

class AboutUsDialog extends StatelessWidget {
  const AboutUsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Row(
        children: [
          Icon(Icons.info_outline),
          SizedBox(width: 10),
          Text('About Spend Mate'),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Spend Mate is a mobile personal finance tracker developed as a Software Engineering coursework project.'),
            SizedBox(height: 10),
            Text(
                'It integrates modern development practices, utilizing a layered architecture, cloud integration, offline caching, and real-time data handling. The team collaboratively performed system analysis, requirement specification, and design modeling.'),
            SizedBox(height: 10),
            Text(
                'The implementation phase was led by Syed Bayazid Hossain, successfully transforming design specifications into a functional mobile system.'),
            const SizedBox(height: 15),
            const Text(
              'Supervised By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Professor Ibrahim Musa Ishag Musa, PhD.\n',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text:
                        'Full Stack AI/ML R&D Scientist\nIEEE Senior Member\nAssistant Professor, Dongshin University',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Developed By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Spend Mate Project Team\nDongshin University\nDepartment of Software Convergence',
            ),
            const SizedBox(height: 5),
            const Text(
              'Syed Bayazid Hossain (Development Lead)\nShofiqul Islam (Analysis & Design Support)\nMd Refat Islam Abir (Documentation Support)\nZahid Hasan (Testing & Review Support)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
