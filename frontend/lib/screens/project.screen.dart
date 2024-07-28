import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/models/project.model.dart';
import 'package:inventory/widgets/component.dart';
import 'package:inventory/widgets/description.dart';
import 'package:inventory/widgets/name.dart';
import 'package:inventory/widgets/resources.dart';
import 'package:inventory/widgets/responsive.device.dart';
import 'package:inventory/widgets/scaffold.dart';

class ProjectPage extends StatefulWidget {
  int? projectId;

  ProjectPage({super.key, this.projectId});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  ProjectModel project = projects[0];

  @override
  void initState() {
    debugPrint('ProjectScreen received projectId: ${widget.projectId}');
    if (widget.projectId != null) {
      project = projects
          .firstWhere((element) => element.projectId == widget.projectId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Project",
      body: ResponsiveDeviceLayout(
        mobile: buildMobile(),
        tablet: buildMobile(),
        desktop: buildDesktop(),
      ),
    );
  }

  buildMobile() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                items: [Image.asset('assets/placeholder/placeholder.png')],
                options: CarouselOptions(
                  aspectRatio: 1,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
            ),
            Name(name: project.name),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Created: ${DateFormat('yyyy-MM-dd HH:mm').format(project.created)}\nLast Updated: ${DateFormat('yyyy-MM-dd HH:mm').format(project.lastUpdated)}',
                  style: Theme.of(context).textTheme.labelSmall),
            ),
            const Divider(),
            Description(text: project.description),
            Component(components: project.parts),
            Resources(resources: project.urls),
          ],
        ),
      ),
    );
  }

  buildDesktop() {
    return Text('TEst');
  }
}
