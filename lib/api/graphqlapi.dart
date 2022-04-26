import 'package:flutter/foundation.dart';
import 'package:app/function/calculated.dart';

QueryInfo queryInfo = QueryInfo();

class QueryInfo {
  String pictureBase =
      "https://lab-108-bucket.s3-ap-southeast-1.amazonaws.com/";
  String host = "https://db.108.jobs/application/graphql";
  String baseHost = "db.108.jobs";
  String apiUpLoadImage = "https://db.108.jobs/application-api/upload-image";
  String apiUpLoadResume = "https://db.108.jobs/application-api/upload-resume";
  String positionAvailable = r"""
                 query(
  $options:String
)
  {
  countJobByLocat(options:$options){
    getprovice{
          _id
          name
          jobsCount
  }
     jobTotal
}
  }
                  """;

  String featuredJob = r"""
query(
  $page:Int!,
  $perPage:Int!
  $typeR:String!
  $verifyToken:String
){
  getFeatureJob(page:$page perPage:$perPage typeR:$typeR verifyToken:$verifyToken){
    id
    companyName
    logo 
    title
    location{
      name
    }
    openDate
    closeDate
    image
    isSaved
     jobTag
  }
}
  """;
  String applied = r"""
  
  mutation(
  $JobId:ID!
  $isCoverLetter:FileInput
){
  appliedJob(info:{JobId:$JobId isCoverLetter:$isCoverLetter})
}
              """;
  String jobDetail = r"""
                          query(
  $Jobid:ID!
  $verifyToken:String
){
  getJobByJobId(Jobid:$Jobid verifyToken:$verifyToken){
    findJ{
    jobId
    title
    description
    jobFunction
    jobLanguage
    jobEductionLevel
    jobExperience
    salaryRange
    workingLocation
    isClick
    isSaved
    isApplied
    isApplyUrl
    isApprovedCV
    isNotApply
    isURL
    isCoverLetter
    companyID
    logo
    companyName
    website
    applyEmail
    industry
    phone
    contactName
    address
    closingDate
    openingDate
    }
   findE{
   jobIds
    title
    workingLocation
     openingDate
     closingDate
  }
  }
  }
                  """;
  String company = r"""
                  query(
                    $employerId:ID!
                  ){
                  findEmployerId(employerId:$employerId){
                    getemp{
                      _id
                      logo{
                        src
                      }
                      companyName
                      industryId{
                        name
                      }
                      aboutCompany
                      website
                      facebook
                      appliedEmails
                      village
                      districtId{
                        name
                        provinceId{
                          name
                        }
                      }
                      
                    }
                      getJob{
                        _id
                        title
                        workingLocationId{
                          name
                        }
                        openingDate
                        closingDate
                      }
                    }
                  }
                    """;
  String allCompany = r"""
query(
  $companyName:String!
  $industryId:[ID]!
  $page: Int!
  $perPage: Int!
  $types: String!
){ searchEmployerAllFunction(companyName:$companyName industryId:$industryId page:$page perPage:$perPage types:$types ){
  employers { 
    _id
  companyName
    logo
    isFeature
    industryId
    jobsCount
  }
  count
}
}
                          """;
  String allJobs = r"""
query(
  $typeApp:String!,
  $page:Int!,
  $perPage:Int!,
  $verifyToken:String
){
  getJobAPP(typeApp:$typeApp page:$page perPage:$perPage  verifyToken:$verifyToken){
    allJobs{
      _id
      logo
      title
          jobTag
      isSaved
      companyName
      workingLocationId {
        name
      }
      openingDate
      closingDate

    }
    totals
  }
}
                          """;
  String topBanner = r"""
                                        query(
                                        $variables:String!
                                      )
                                      {
                                        bannerslide(variables:$variables){
                                          _id
                                          image{
                                            src
                                          }
                                          url
                                          BannerTypeId{
                                            _id
                                            name
                                          }
                                        }
                                      }
                        """;
  String getProvinceDistrict = r"""
                                  {
                                  getProvinces {
                                    _id
                                    name
                                    districts{
                                      _id
                                      name
                                    }
                                  }
                                }
                                """;
  String getReuse = r"""
                query(
  $types:String!
  $options: String
  $lanOption:String
){
  getReuseList(types:$types options:$options lanOption:$lanOption){
    _id
    name
  }
}
                    """;
  String register = r"""
                      mutation(
                      $professionalSummary: String!
                    $districtId:        ID!
                    $dateOfBirth:   Date!
                    $firstName:     String!
                    $lastName:      String!
                    $genderId:      ID!
                    $maritalStatusId:   ID!
                    $drivingLicenses: [String]
                      $logo:logoInput!
                      $auth: AuthInput!
                      $Educat:[InputEducation] !
                        $Lan:[InputLanguageSkill]!
                      $working:InputWorkingExperience
                      $Resumes: InputResume!
                    ){
                      addRegisterseekers(info:{
                        professionalSummary: $professionalSummary
                        districtId: $districtId
                    dateOfBirth: $dateOfBirth
                        firstName: $firstName
                        lastName: $lastName
                        genderId: $genderId
                        maritalStatusId: $maritalStatusId
                        drivingLicenses: $drivingLicenses
                        logo:$logo
                        auth:$auth
                        Educat:$Educat
                          Lan:$Lan
                        working:$working
                        Resumes:$Resumes
                      })
                    }
                      """;
  String resendOTP = r"""
                    mutation(
                              $verifyToken:String!
                            ){
                              reSendCode(verifyToken:$verifyToken)
                            }
                    """;
  String verifyOTP = r"""
                      mutation(
                                $verifyCode:String!
                                $verifyToken:String!
                              ){
                                verifyMobile(
                                  verifyToken:$verifyToken
                                  verifyCode:$verifyCode
                                )
                              }
                      """;

  String verifyOTPforgot = r"""
                      mutation(
                                  $verifyCode: String!
                                  $verifyToken: String!
                                ){
                                  verifyCode(
                                    verifyCode:$verifyCode
                                    verifyToken:$verifyToken
                                  )
                                }
                      """;
  String changepass = r"""
                        mutation(
                        $changePassToken: String!
                        $newPassword: String!
                      ){
                        changePassword(
                          changePassToken:$changePassToken
                          newPassword:$newPassword
                        )
                      }
                      """;
  String login = r"""
                  mutation (
                  $email:String!,
                  $password:String!
                ){
                seekerLogin(
                  email:$email,
                  password:$password
                )
                }
""";
  String sendOTP = r"""
                    mutation(
                    $mobile: String!
                  )
                  {
                  sendVerificationCode(
                    mobile: $mobile
                  )
                  }
  """;
  String seekerUndoSaveAppl = r"""
  mutation(
  $type:String!
  $JobId: ID!
){
  deleteApplySaveJob(type:$type JobId:$JobId)
}
  """;
  String qeuryAppleSave = r"""
query(
  $type:String!
  $page:Int!
  $perPage:Int!
  $search:String
){
  getApplySaveJob(type:$type page:$page perPage:$perPage search:$search){
    job{
     id
      jobId
      title
      companyName
      logo
      workingLocation
      closingDate
      createAt
    }
    total
  }
}
""";
  String staticBanner = r"""
  {
                         getSingleBanner{
  _id
 image
  url
  bannerType
}
}
                         """;
  String updateProfileLogo = r"""
  mutation(
  $seekerId:ID
  $logo:updateFileInput
){
  updateLogo(info:{seekerId:$seekerId logo:$logo})
}
  
  """;
  String updateInformation = r"""
mutation(
   $registerSeekerId:ID!
  $seekerID:ID!
  $professionalSummary: String
$districtId:        ID
$dateOfBirth:   Date
$firstName:     String
$lastName:      String
$genderId:      ID
$maritalStatusId:   ID
$drivingLicenses: [String]
   $educatU: [EducationUpdate] 
    $lanU:[updateLanguageSkill]
    $workingU:updateWorkingExperience
   $keySkill:[InputupdateKeyskill]!
){
  updateInfo(info:{
    seekerID:$seekerID
    registerSeekerId:$registerSeekerId
    professionalSummary:$professionalSummary
    districtId:$districtId
    dateOfBirth:$dateOfBirth
    firstName:$firstName
    lastName:$lastName
    genderId:$genderId
    maritalStatusId:$maritalStatusId
    drivingLicenses:$drivingLicenses
    educatU:$educatU
    LanU:$lanU
    workingU:$workingU
    keySkill:$keySkill
  })
}
    """;
  String updateResumeFile = r"""
mutation(
  $resumeId:ID!
  $file: updateFileInput
 
){
  updateResumes(info:{resumeId:$resumeId file: $file })
}
  """;
  String seekerunSave = r"""
                          mutation(
                          $JobId:ID!
                        ){
                          unSaveJob(JobId:$JobId)
                          }
                          """;
  String seekerSavejob = r"""
                          mutation(
                          $JobId:ID!
                        ){
                          saveJobs(JobId:$JobId)
                          }
                          """;
  String seekerApplyjob = r"""
                          mutation(
                            $JobId:ID!
                          ){
                            appliedJob(
                              JobId:$JobId
                            )
                          }
                          """;
  String changEmailandNumber = r"""
 mutation(
  $email:String!
  $mobile:String!
){
  updateAuth( info:{ email:$email mobile:$mobile})
    {
    _id
    email
    mobile
  }
}

""";

  String queryMyProfile = r"""
      {
                              findSeeker {
                                status
                                reason
                                registerSeeker {
                                  fileId{
                                    src
                                  }
                                  _id
                                  firstName
                                  lastName    
                                  professionalSummary
                                  dateOfBirth
                                  genderId{
                                  name
                                  }
                                  maritalStatusId{
                                    name
                                  }
            }
                                resume {
                                   _id
                                  isSearchable
                                  workingExperience{
                                    LatestJobTitle
                                  }
                              }
                                   authId{
                          _id
                          email
                          mobile
                        }
                              }
                          }
                          """;
  String featureJobRecommend = r"""

query(
  $page:Int!,
  $perPage:Int!
  $typeR:String!
  $verifyToken:String
){
  getFeatureJob(page:$page perPage:$perPage typeR:$typeR verifyToken:$verifyToken){
    id
    companyName
    logo 
    title
    location{
      name
    }
    openDate
    closeDate
    image
    jobTag
    isSaved
  }
}
                                """;
  String qeuryResume = r"""
           {
                          findSeeker {
                            _id
                            registerSeeker {
                              _id
                              fileId{
                                link
                                src
                                size
                              }
                              _id
                              firstName
                              lastName
                              professionalSummary
                              dateOfBirth
                              genderId{
                              _id
                              name
                              }
                              maritalStatusId{
                                 _id
                                name
                              }
                            districtId{
                              _id
                              name
                              provinceId{
                                _id
                                name
                              }
                            }
                              drivingLicenses
                            }
                            resume {
                              _id
                              types
                              view
                              viewDaily
                              viewMonthly
                              isSearchable
                              point
                              fileId{
                                link
                                src
                                
                            }
                              keySkillIds{
                                name
                              }
                              education{
                                _id
                                department
                                degreeId{
                                  _id
                                  name
                                }
                              }
                              languageSkill {
                                _id
                                LanguageId{
                                  	_id
                                  name
                                }
                                LanguageLevelId{
                                  	_id
                                  name
                                }
                              }
                              workingExperience{
                                _id
                                LatestJobTitle
                                SalayRangeId{
                                  _id
                                  name
                                }
                                previousJobTitlesId{
                                  name
                                }
                                previousEmployersId{
                                  name
                                }
                                previousEmployerIndustryId{
                                   _id
                                  name
                                }
                                 totalWorkingExperience
                              }
                          }
                        authId{
                          _id
                          email
                          mobile
                        }
                          }
                      }
                        """;
  String mutaSearchable = r"""
                          mutation(
                          $resumeId:ID!
                        ){
                          isSearchable(resumeId:$resumeId){
                          _id
                                types
                                view
                                viewDaily
                                viewMonthly
                                isSearchable    
                          }
                        }
                           """;
  String mutationResume = r"""
                    mutation(
  $registerSeekerId:ID!
  $seekerId:ID!
  $professionalSummary: String!
$districtId:        ID!
$dateOfBirth:   Date!
$firstName:     String!
$lastName:      String!
$genderId:      ID!
$maritalStatusId:   ID!
$drivingLicenses: [String]
  $logo:logoupdate
   $educatU: [EducationUpdate] !
    $lanU:[updateLanguageSkill]!
    $workingU:updateWorkingExperience
  $resumeU: updateResume!
){
  updateRegisterSeeker(info:{
    registerSeekerId:$registerSeekerId
    seekerId:$seekerId    
     professionalSummary: $professionalSummary
    districtId: $districtId
dateOfBirth: $dateOfBirth
    firstName: $firstName
    lastName: $lastName
    genderId: $genderId
    maritalStatusId: $maritalStatusId
    drivingLicenses: $drivingLicenses
    logo:$logo
     educatU:$educatU
     LanU:$lanU
     workingU:$workingU
     resumeU:$resumeU
  })}
                        """;
  String updateOldUser = r"""
  mutation(
  $registerSeekerId:ID
  $seekerId:ID
  $mobile:String
  $professionalSummary: String!
$districtId: 		ID!
$dateOfBirth:	Date!
$firstName:		String!
$lastName:		String!
$genderId:		ID!
$maritalStatusId:	ID!
$drivingLicenses: [String]
  $logo:logoupdate
   $educatU: [EducationUpdate] !
    $lanU:[updateLanguageSkill]!
    $workingU:updateWorkingExperience
  $resumeU: updateResume
){
  updateRegisterSeeker(info:{
    registerSeekerId:$registerSeekerId
    seekerId:$seekerId    
    mobile:$mobile
     professionalSummary: $professionalSummary
    districtId: $districtId
dateOfBirth: $dateOfBirth
    firstName: $firstName
    lastName: $lastName
    genderId: $genderId
    maritalStatusId: $maritalStatusId
    drivingLicenses: $drivingLicenses
    logo:$logo
     educatU:$educatU
       LanU:$lanU
     workingU:$workingU
     resumeU:$resumeU
  })

  }
  
  
  """;
  String getjobfunction = r"""
  {
  getJobFunction{
    _id
    name
  }
}""";
  String featuredCompanyDetail = r"""
query(
  $employerId: ID!
){
  findEmployerId(employerId:$employerId){
   getemp{
   empId
    logo
    companyName
   address
    appliedEmails
    industry
    website
    aboutCompany  
    facebook
    phone
    isLink
    profile
    companyColor
    Gallerys
    Peoples{
      img
      name
      position
      duty
    }
    Benefits{
      imgs
      details
    }
    isFeature
   
  }
    getJob{
      jobId
    title
    workingLocation
    openingDate
    closingDate
    }
     countJob
  }
}
  """;
  String getProvince = r"""
  
query(
  $options:String
){
  getFilter(options:$options){
    _id
    name
  }
}
              """;
  // String getAuth = r"""
  //          {
  //                             findSeeker {

  //                                  authId{
  //                         _id
  //                         email
  //                         mobile
  //                       }
  //                             }
  //                         }
  //               """;
  String changepassword = r"""
  
  mutation(
  $oldPassword:String!
  $newPassword:String!
  $confirmPasswords:String!
){
  changepasswordWhenLogin( 
  oldPassword:$oldPassword
  newPasswords:$newPassword
  confirmPasswords:$confirmPasswords
  )
}
                            """;
  String featureCompany = r"""
  {
  getCompanyFeature{
    profile
    empId
    logo
    companyName
    industry
    address
  }
} 
""";

  String searchjob = r"""query(
    $title: String!
  $jobFunctionIds:[ID]!
   $provinceIds:[ID]!
  $page:Int!
  $perPage:Int!
 $verifyToken:String
){
  searchJobAllFunctions(title:$title  jobFunctionIds:$jobFunctionIds 
    provinceIds:$provinceIds
    page:$page perPage:$perPage
 verifyToken:$verifyToken
  ){
    allJob{
    _id
     jobTag
      title
    employerId
      isSaved
     
      companyName
      logo
    
     workingLocationId{
      name
    }
    openingDate
    closingDate
  }
    totals
  }
}""";
  Map<String, dynamic> updateResumeMutationOldUser(
      {String? profsum,
      String? districtID,
      String? dob,
      String? firstname,
      String? lastname,
      String? genderID,
      String? maritalID,
      String? number,
      String? userID,
      List<dynamic>? drivinglicense,
      logo,
      file,
      List<dynamic>? keySkill,
      List<dynamic>? fieldstudyname,
      List<dynamic>? degreeID,
      List<dynamic>? langID,
      List<dynamic>? langLevelID,
      String? latestjob,
      String? salaryRangID,
      String? totalWorkingExp,
      List<dynamic>? previousJob,
      List<dynamic>? previousEmp,
      List<dynamic>? previousIndID}) {
    List keySkillInput = [];
    keySkill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldstudyname?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    langID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });
    List<Map<String, dynamic>> previousJobInput = [];
    previousJob?.forEach((element) {
      previousJobInput.add({"name": element});
    });
    List<Map<String, dynamic>> previousEmInput = [];
    previousEmp?.forEach((element) {
      previousEmInput.add({"name": element});
    });
    Map<String, dynamic> update;

    update = {
      "registerSeekerId": "",
      "seekerId": userID,
      "professionalSummary": profsum,
      "districtId": districtID,
      "dateOfBirth": CutDateString().rePositionYMD(dob),
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalID,
      "drivingLicenses": drivinglicense,
      "logo": logo,
      "mobile": number,
      "resumeU": {
        "resumeId": "",
        "file": file,
        "keySkill": keySkillInput,
      },
      "educatU": educat,
      "lanU": language,
      "workingU": {
        "LatestJobTitle": latestjob,
        "SalayRangeId": salaryRangID,
        "pre": previousJobInput,
        "previousE": previousEmInput,
        "previousEmployerIndustryId": previousIndID,
        "totalWorkingExperience": int.parse(totalWorkingExp!)
      }
    };

    // debugPrint(eiei);
    return update;
  }

  Map<String, dynamic> updateNoExpResumeMutationOldUser({
    String? userID,
    String? profsum,
    String? districtID,
    String? dob,
    String? firstname,
    String? lastname,
    String? genderID,
    String? maritalID,
    String? number,
    List<dynamic>? drivinglicense,
    logo,
    file,
    List<dynamic>? keySkill,
    List<dynamic>? fieldstudyname,
    List<dynamic>? degreeID,
    List<dynamic>? langID,
    List<dynamic>? langLevelID,
  }) {
    List keySkillInput = [];
    keySkill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldstudyname?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    langID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });

    Map<String, dynamic> update;
    //  debugPrint(file);
    update = {
      "registerSeekerId": "",
      "seekerId": userID,
      "professionalSummary": profsum,
      "districtId": districtID,
      "mobile": number,
      "dateOfBirth": CutDateString().rePositionYMD(dob),
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalID,
      "drivingLicenses": drivinglicense,
      "logo": logo,
      "resumeU": {
        "resumeId": "",
        "file": file,
        "keySkill": keySkillInput,
      },
      "educatU": educat,
      "lanU": language,
      "workingU": null,
    };
    debugPrint('update' + update.toString());
    return update;
  }

  Map<String, dynamic> updateResumeMutation(
      {String? registerseekerID,
      String? seekerID,
      String? profsum,
      String? districtID,
      String? dob,
      String? firstname,
      String? lastname,
      String? genderID,
      String? maritalID,
      List<dynamic>? drivinglicense,
      String? resumeID,
      List<dynamic>? keySkill,
      List<dynamic>? fieldstudyname,
      List<dynamic>? degreeID,
      List<dynamic>? langID,
      List<dynamic>? langLevelID,
      String? latestjob,
      String? salaryRangID,
      String? totalWorkingExp,
      List<dynamic>? previousJob,
      List<dynamic>? previousEmp,
      List<dynamic>? previousIndID}) {
    List keySkillInput = [];
    keySkill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldstudyname?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    langID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });
    List<Map<String, dynamic>> previousJobInput = [];
    previousJob?.forEach((element) {
      previousJobInput.add({"name": element});
    });
    List<Map<String, dynamic>> previousEmInput = [];
    previousEmp?.forEach((element) {
      previousEmInput.add({"name": element});
    });
    Map<String, dynamic> update;

    update = {
      "registerSeekerId": registerseekerID,
      "seekerID": seekerID,
      "professionalSummary": profsum,
      "districtId": districtID,
      "dateOfBirth": CutDateString().rePositionYMD(dob),
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalID,
      "drivingLicenses": drivinglicense,
      "keySkill": keySkillInput,
      "educatU": educat,
      "lanU": language,
      "workingU": {
        "LatestJobTitle": latestjob,
        "SalayRangeId": salaryRangID,
        "pre": previousJobInput,
        "previousE": previousEmInput,
        "previousEmployerIndustryId": previousIndID,
        "totalWorkingExperience": int.parse(totalWorkingExp!)
      }
    };
    // debugPrint(seekerID);
    // debugPrint(update);
    return update;
  }

  Map<String, dynamic> updateNoExpResumeMutation({
    String? registerseekerID,
    String? seekerID,
    String? profsum,
    String? districtID,
    String? dob,
    String? firstname,
    String? lastname,
    String? genderID,
    String? maritalID,
    List<dynamic>? drivinglicense,
    String? resumeID,
    List<dynamic>? keySkill,
    List<dynamic>? fieldstudyname,
    List<dynamic>? degreeID,
    List<dynamic>? langID,
    List<dynamic>? langLevelID,
  }) {
    List keySkillInput = [];
    keySkill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldstudyname?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    langID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });

    Map<String, dynamic> update;

    update = {
      "registerSeekerId": registerseekerID,
      "seekerID": seekerID,
      "professionalSummary": profsum,
      "districtId": districtID,
      "dateOfBirth": CutDateString().rePositionYMD(dob),
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalID,
      "drivingLicenses": drivinglicense,
      "keySkill": keySkillInput,
      "educatU": educat,
      "lanU": language,
      "workingU": null,
    };
    debugPrint(seekerID);
    debugPrint(update.toString());
    return update;
  }

  Map<String, dynamic> registerMutationRun(
      {picture,
      email,
      mobile,
      password,
      firstname,
      lastname,
      dob,
      genderID,
      maritalstatusID,
      drivinglicense,
      districtcityID,
      salaryID,
      profsum,
      cv,
      latestjob,
      List<dynamic>? previousjob,
      List<dynamic>? previousEmp,
      List<dynamic>? previousIndusID,
      totalWorkExp,
      List<dynamic>? fieldofstudy,
      List<dynamic>? degreeID,
      List<dynamic>? languageID,
      List<dynamic>? langLevelID,
      List<dynamic>? keyskill}) {
    List keySkillInput = [];
    keyskill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldofstudy?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    languageID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });
    List<Map<String, dynamic>> previousJobInput = [];
    previousjob?.forEach((element) {
      previousJobInput.add({"name": element});
    });
    List<Map<String, dynamic>> previousEmInput = [];
    previousEmp?.forEach((element) {
      previousEmInput.add({"name": element});
    });

    Map<String, dynamic> registerMutation = {
      "professionalSummary": profsum,
      "districtId": districtcityID,
      "dateOfBirth": dob,
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalstatusID,
      "drivingLicenses": drivinglicense,
      "logo": picture,
      "auth": {"email": email, "password": password, "mobile": mobile},
      "Resumes": {"file": cv, "keySkill": keySkillInput},
      "Educat": educat,
      "Lan": language,
      "working": {
        "LatestJobTitle": latestjob,
        "SalayRangeId": salaryID,
        "pre": previousJobInput,
        "previousE": previousEmInput,
        "previousEmployerIndustryId": previousIndusID,
        "totalWorkingExperience": int.parse(totalWorkExp)
      }
    };

    return registerMutation;
  }

  registerNoExpMutationRun(
      {picture,
      email,
      mobile,
      password,
      firstname,
      lastname,
      dob,
      genderID,
      maritalstatusID,
      drivinglicense,
      provincestate,
      districtcityID,
      profsum,
      cv,
      List<dynamic>? fieldofstudy,
      List<dynamic>? degreeID,
      List<dynamic>? languageID,
      List<dynamic>? langLevelID,
      List<dynamic>? keyskill}) {
    List keySkillInput = [];

    keyskill?.forEach((element) {
      keySkillInput.add({"name": element});
    });
    List<Map<String, dynamic>> educat = [];
    int degreeforeach = 0;
    degreeID?.forEach((element) {
      educat.add(
          {"department": fieldofstudy?[degreeforeach], "degreeId": element});
      degreeforeach = degreeforeach + 1;
    });
    List<Map<String, dynamic>> language = [];
    int languageforEach = 0;
    languageID?.forEach((element) {
      language.add({
        "LanguageId": element,
        "LanguageLevelId": langLevelID?[languageforEach]
      });
      languageforEach = languageforEach + 1;
    });

    Map<String, dynamic> registerMutationNoExp = {
      "professionalSummary": profsum,
      "districtId": districtcityID,
      "dateOfBirth": dob,
      "firstName": firstname,
      "lastName": lastname,
      "genderId": genderID,
      "maritalStatusId": maritalstatusID,
      "drivingLicenses": drivinglicense,
      "logo": picture,
      "auth": {"email": email, "password": password, "mobile": mobile},
      "Resumes": {"file": cv, "keySkill": keySkillInput},
      "Educat": educat,
      "Lan": language,
    };

    return registerMutationNoExp;
  }
}
