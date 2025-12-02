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
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'SpendMate is a mobile-based personal finance tracking application developed as part of the Software Engineering coursework.\n\nThe project reflects modern software development practices including cloud integration, offline caching, UI/UX design, layered architecture, and real-time data handling.\n\nThis work was completed as a group effort, where the team collaboratively contributed to system analysis, documentation, requirement specification, and design modeling.\n\nThe application implementation and development phase was led by Syed Bayazid Hossain, ensuring that the design specifications were transformed into a functional mobile system.'),
            SizedBox(height: 20),
            Text(
              'Developed By',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
                'SpendMate Project Team\nDongshin University\nDepartment of Software Convergence'),
            SizedBox(height: 10),
            Text(
              'Syed Bayazid Hossain (Development Lead)\nShofiqul Islam (Design & Documentation Support)\nMd Refat Islam Abir (Analysis & Review Support)\nZahid Hasan (Testing & Documentation Support)',
              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
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
