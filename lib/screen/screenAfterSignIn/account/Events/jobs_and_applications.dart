// ignore_for_file: deprecated_member_use

import 'package:app/provider/eventAvailableProvider.dart';
import 'package:app/screen/screenAfterSignIn/account/Events/detailPosition.dart';
import 'package:flutter/material.dart';
import 'package:app/functions/colors.dart';
import 'package:app/functions/textSize.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class JobsApplicationsScreen extends StatefulWidget {
  const JobsApplicationsScreen({Key? key}) : super(key: key);

  @override
  State<JobsApplicationsScreen> createState() => _JobsApplicationsScreenState();
}

class _JobsApplicationsScreenState extends State<JobsApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventAvailableProvider = context.watch<EventAvailableProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        title: Text(
          'Jobs & Applications',
          style: bodyTextMedium(null, AppColors.fontDark, FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.fontDark),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.fontDark,
          unselectedLabelColor: AppColors.fontGreyOpacity,
          indicatorColor: AppColors.teal,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Text(
                "recommend_job".tr,
                style: bodyTextNormal(null, null, FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                "applied_job".tr,
                style: bodyTextNormal(null, null, FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          //eventAvailableProvider.companyLogoEventAvailable
          _screenAIMatchingJob(
              eventAvailableProvider.aiMatchingJobAndAppliedJobEvent,
              eventAvailableProvider.companyLogoEventAvailable),
          _screenAIMatchingJob(eventAvailableProvider.appliedJobEvent,
              eventAvailableProvider.companyLogoEventAvailable),
        ],
      ),
    );
  }

  Widget _screenAIMatchingJob(List list, String companyLogoEventAvailable) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final job = list[index];
              return Column(
                children: [
                  cardItemAIMatchingJobAndAppliedJob(
                    logo: job["logo"],
                    jobTitle: job["title"],
                    company: job["companyName"],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPositionComapny(
                            id: job["_id"],
                            logo: companyLogoEventAvailable,
                            title: job["title"],
                            salary: job["salary"] == null
                                ? ""
                                : job["salary"].toString(),
                            description: job["description"],
                            isNegotiable: job["isNegotiable"],
                            isAppliedEvenJobCompany: job["isApplied"],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _screenAppliedJob() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [],
    );
  }

  Widget cardItemAIMatchingJobAndAppliedJob(
      {required String logo,
      required String jobTitle,
      required String company,
      Function()? press}) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border(
            // top: BorderSide(color: AppColors.dark200, width: 0.5),
            bottom: BorderSide(color: AppColors.dark200, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Company logo circle
            Container(
              width: 50,
              height: 50,
              // padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                // color: AppColors.red,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderBG),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: logo == ""
                      ? Icon(
                          Icons.image_not_supported,
                          size: 20,
                          color: AppColors.fontGrey, // Grey icon for unchecked
                        )
                      : Image.network(
                          "https://storage.googleapis.com/108-bucket/$logo",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 20,
                              color:
                                  AppColors.fontGrey, // Grey icon for unchecked
                            ); // Display an error message
                          },
                        ),
                ),
              ),
            ),
            SizedBox(width: 15),
            // Job Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job title
                  Text(
                    jobTitle,
                    style: bodyTextNormal(
                        null, AppColors.fontDark, FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),

                  // Comapny name
                  Text(
                    company,
                    style: bodyTextSmall(null, AppColors.fontGrey, null),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.fontGrey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
