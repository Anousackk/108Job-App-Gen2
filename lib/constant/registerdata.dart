import 'dart:io';
import 'package:app/function/pluginfunction.dart';

Register myResume = Register();

class Register {
  bool havedata = false;

  Register(
      {this.email,
      this.number,
      this.firstname,
      this.lastname,
      this.gender,
      this.genderID,
      this.maritalStatus,
      this.maritalStatusID,
      this.provinceOrState,
      this.provinceOrStateID,
      this.districtOrCity,
      this.districtOrCityID,
      this.profSummary,
      this.latestJobTitle,
      this.totalWorkEXP,
      this.provincesRepositories,
      this.districtRepoindex,
      this.dob,
      this.cv,
      this.previousJobTitle,
      this.previousEmployer,
      this.previousIndustry,
      this.fieldstudyName,
      this.fieldstudyDegree,
      this.langName,
      this.langLevel,
      this.keySkill});
  String? email,
      number,
      firstname,
      lastname,
      gender,
      genderID,
      maritalStatus,
      maritalStatusID,
      provinceOrState,
      provinceOrStateID,
      districtOrCity,
      districtOrCityID,
      profSummary,
      latestJobTitle,
      password,
      totalWorkEXP,
      myResumeDOB,
      salary,
      salaryID;
  int? districtRepoindex;
  List<dynamic>? drivingLicense;

  List? provincesRepositories;

  DateTime? dob;
  File? cv;

  List? language;
  List<dynamic>? previousJobTitle,
      previousEmployer,
      previousIndustry,
      previousIndID,
      fieldstudyName,
      degreeID,
      fieldstudyDegree,
      langName,
      langNameID,
      langLevel,
      langLevelID,
      keySkill;

  Future getAll() async {
    await getEmail();
    await getNumber();
    await getFirstName();
    await getLastName();
    await getGender();
    await getGenderID();
    await getMaritalStatus();
    await getMaritalStatusID();
    await getProvinceOrState();
    await getProvinceOrStateID();
    await getDistrictOrCity();
    await getDistrictRepoindex();
    await getDistrictOrCityID();
    await getProfSummary();
    await getLatestJobTitle();
    await getDrivingLicense();
    await getTotalWorkEXP();
    await getDOB();
    await getSalary();
    await getSalaryID();
    await getPreviousEmployer();
    await getPreviousIndustry();
    await getPreviousIndID();
    await getPreviousJobTitle();
    await getFieldstudyDegree();
    await getdegreeID();
    await getFieldstudyName();
    await getLangLevel();
    await getLangLevelID();
    await getLangName();
    await getLangNameID();
    await getkeySkill();

    return 'finish';
  }

  Future removeAll() async {
    reEmail();
    reNumber();
    reFirstName();
    reSalary();
    reSalaryID();
    reLastName();
    reGender();
    reGenderID();
    reMaritalStatus();
    reMaritalStatusID();
    reProvinceOrState();
    reProvinceOrStateID();
    reDistrictOrCity();
    reDistrictRepoindex();
    reDistrictOrCityID();
    reProfSummary();
    reDrivingLicense();
    reLatestJobTitle();
    reTotalWorkEXP();
    reDOB();
    reCV();
    rePreviousEmployer();
    rePreviousIndustry();
    rePreviousIndID();
    rePreviousJobTitle();
    reFieldstudyDegree();
    reDegreeID();
    reFieldstudyName();
    reLangLevel();
    reLangLevelID();
    reLangName();
    reLangNameID();
    rekeySkill();
  }

  getEmail() async {
    var reading = await SharedPref().read('email');
    if (reading != null) {
      havedata = true;
    } else {}
    email = reading;
  }

  Future getSalary() async {
    var reading = await SharedPref().read('salary');
    if (reading != null) {
      havedata = true;
    } else {}
    salary = reading;
  }

  Future getSalaryID() async {
    var reading = await SharedPref().read('salaryID');
    if (reading != null) {
      havedata = true;
    } else {}
    salaryID = reading;
  }

  Future getNumber() async {
    var reading = await SharedPref().read('number');
    if (reading != null) {
      havedata = true;
    } else {}
    number = reading;
  }

  Future getFirstName() async {
    var reading = await SharedPref().read('firstname');
    if (reading != null) {
      havedata = true;
    } else {}
    firstname = reading;
  }

  Future getLastName() async {
    var reading = await SharedPref().read('lastname');
    if (reading != null) {
      havedata = true;
    } else {}
    lastname = reading;
  }

  getGender() async {
    var reading = await SharedPref().read('gender');
    if (reading != null) {
      havedata = true;
    } else {}
    gender = reading;
  }

  getGenderID() async {
    var reading = await SharedPref().read('genderID');
    if (reading != null) {
      havedata = true;
    } else {}
    genderID = reading;
  }

  getMaritalStatus() async {
    var reading = await SharedPref().read('maritalStatus');
    if (reading != null) {
      havedata = true;
    } else {}
    maritalStatus = reading;
  }

  getMaritalStatusID() async {
    var reading = await SharedPref().read('maritalStatusID');
    if (reading != null) {
      havedata = true;
    } else {}
    maritalStatusID = reading;
  }

  Future getDrivingLicense() async {
    var reading = await SharedPref().read('drivingLicense');
    if (reading != null) {
      havedata = true;
    } else {}

    drivingLicense = reading;
  }

  Future getProvinceOrState() async {
    var reading = await SharedPref().read('POS');
    if (reading != null) {
      havedata = true;
    } else {}
    provinceOrState = reading;
  }

  Future getProvinceOrStateID() async {
    var reading = await SharedPref().read('POSID');
    if (reading != null) {
      havedata = true;
    } else {}
    provinceOrStateID = reading;
  }

  getDistrictOrCity() async {
    var reading = await SharedPref().read('DOC');
    if (reading != null) {
      havedata = true;
    } else {}
    districtOrCity = reading;
  }

  Future getDistrictOrCityID() async {
    var reading = await SharedPref().read('DOCID');
    if (reading != null) {
      havedata = true;
    } else {}
    districtOrCityID = reading;
  }

  getDistrictRepoindex() async {
    var reading = await SharedPref().read('districtRepoindex');
    if (reading != null) {
      havedata = true;
    } else {}
    districtRepoindex = reading;
  }

  Future getProfSummary() async {
    var reading = await SharedPref().read('profSummary');
    if (reading != null) {
      havedata = true;
    } else {}
    profSummary = reading;
  }

  Future getLatestJobTitle() async {
    var reading = await SharedPref().read('latestJobTitle');
    if (reading != null) {
      havedata = true;
    } else {}
    latestJobTitle = reading;
  }

  Future getTotalWorkEXP() async {
    var reading = await SharedPref().read('totalWorkEXP');
    if (reading != null) {
      havedata = true;
    } else {}
    totalWorkEXP = reading;
  }

  getDOB() async {
    DateTime? reading = await SharedPref().readDateTime('dob');
    if (reading != null) {
      havedata = true;
    } else {}
    dob = reading;
  }

  getCV() async {
    var reading = await SharedPref().read('cv');
    if (reading != null) {
      havedata = true;
    } else {}
    cv = reading;
  }

  Future getPreviousJobTitle() async {
    var reading = await SharedPref().read('previousJobTitle');
    if (reading != null) {
      havedata = true;
    } else {}
    previousJobTitle = reading;
  }

  Future getPreviousEmployer() async {
    var reading = await SharedPref().read('previousEmployer');
    if (reading != null) {
      havedata = true;
    } else {}
    previousEmployer = reading;
  }

  Future getPreviousIndustry() async {
    var reading = await SharedPref().read('previousIndustry');
    if (reading != null) {
      havedata = true;
    } else {}
    previousIndustry = reading;
  }

  Future getPreviousIndID() async {
    var reading = await SharedPref().read('previousIndID');
    if (reading != null) {
      havedata = true;
    } else {}
    previousIndID = reading;
  }

  Future getFieldstudyName() async {
    var reading = await SharedPref().read('fieldstudyName');
    if (reading != null) {
      havedata = true;
    } else {}
    fieldstudyName = reading;
  }

  Future getFieldstudyDegree() async {
    var reading = await SharedPref().read('fieldstudyDegree');
    if (reading != null) {
      havedata = true;
    } else {}
    fieldstudyDegree = reading;
  }

  Future getdegreeID() async {
    var reading = await SharedPref().read('degreeID');
    if (reading != null) {
      havedata = true;
    } else {}
    degreeID = reading;
  }

  Future getLangName() async {
    var reading = await SharedPref().read('langName');
    if (reading != null) {
      havedata = true;
    } else {}
    langName = reading;
  }

  Future getLangNameID() async {
    var reading = await SharedPref().read('langNameID');
    if (reading != null) {
      havedata = true;
    } else {}
    langNameID = reading;
  }

  Future getLangLevel() async {
    var reading = await SharedPref().read('langLevel');
    if (reading != null) {
      havedata = true;
    } else {}
    langLevel = reading;
  }

  Future getLangLevelID() async {
    var reading = await SharedPref().read('langLevelID');
    if (reading != null) {
      havedata = true;
    } else {}
    langLevelID = reading;
  }

  Future getkeySkill() async {
    var reading = await SharedPref().read('keySkill');
    if (reading != null) {
      havedata = true;
    }
    keySkill = reading;
  }

////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  setData(String data, String key) async {
    await SharedPref().save(data, key);
  }

  setEmail() async {
    await SharedPref().save('email', email);
  }

  setNumber() async {
    await SharedPref().save('number', number);
  }

  setSalary() async {
    await SharedPref().save('salary', salary);
  }

  setSalaryID() async {
    await SharedPref().save('salaryID', salaryID);
  }

  setFirstName() async {
    await SharedPref().save('firstname', firstname);
  }

  setLastname() async {
    await SharedPref().save('lastname', lastname);
  }

  setGender() async {
    await SharedPref().save('gender', gender);
  }

  setGenderID() async {
    await SharedPref().save('genderID', genderID);
  }

  setMaritalStatus() async {
    await SharedPref().save('maritalStatus', maritalStatus);
  }

  setMaritalStatusID() async {
    await SharedPref().save('maritalStatusID', maritalStatusID);
  }

  setDrivingLicense() async {
    await SharedPref().save('drivingLicense', drivingLicense);
  }

  setProvinceOrState() async {
    await SharedPref().save('POS', provinceOrState);
  }

  setprovinceOrStateID() async {
    await SharedPref().save('POSID', provinceOrStateID);
  }

  setDistrictOrCity() async {
    await SharedPref().save('DOC', districtOrCity);
  }

  setDistrictRepoindex() async {
    await SharedPref().save('districtRepoindex', districtRepoindex);
  }

  setDistrictOrCityID() async {
    await SharedPref().save('DOCID', districtOrCityID);
  }

  setProfSummary() async {
    await SharedPref().save('profSummary', profSummary);
  }

  setLatestJobTitle() async {
    await SharedPref().save('latestJobTitle', latestJobTitle);
  }

  setTotalWorkEXP() async {
    await SharedPref().save('totalWorkEXP', totalWorkEXP);
  }

  setDOB() async {
    await SharedPref().saveDateTime('dob', dob!);
  }

  // setCV() async {
  //   await SharedPref().save('cv', cv);
  // }

  setPreviousJobTitle() async {
    await SharedPref().save('previousJobTitle', previousJobTitle);
  }

  setPreviousEmployer() async {
    await SharedPref().save('previousEmployer', previousEmployer);
  }

  setPreviousIndustry() async {
    await SharedPref().save('previousIndustry', previousIndustry);
  }

  setPreviousIndID() async {
    await SharedPref().save('previousIndID', previousIndID);
  }

  setFieldstudyName() async {
    await SharedPref().save('fieldstudyName', fieldstudyName);
  }

  setFieldstudyDegree() async {
    await SharedPref().save('fieldstudyDegree', fieldstudyDegree);
  }

  setDegreeID() async {
    await SharedPref().save('degreeID', degreeID);
  }

  setLangName() async {
    await SharedPref().save('langName', langName);
  }

  setLangNameID() async {
    await SharedPref().save('langNameID', langNameID);
  }

  setLangLevel() async {
    await SharedPref().save('langLevel', langLevel);
  }

  setLangLevelID() async {
    await SharedPref().save('langLevelID', langLevelID);
  }

  setKeySkill() async {
    await SharedPref().save('keySkill', keySkill);
  }

  ///
  ///
  /////
  ///
  ///
  ///
  ///
  ///
  ///
  reEmail() async {
    await SharedPref().remove('email');
  }

  reSalary() async {
    await SharedPref().remove('salary');
  }

  reSalaryID() async {
    await SharedPref().remove('salaryID');
  }

  reNumber() async {
    await SharedPref().remove('number');
  }

  reFirstName() async {
    await SharedPref().remove('firstname');
  }

  reLastName() async {
    await SharedPref().remove('lastname');
  }

  reGender() async {
    await SharedPref().remove('gender');
  }

  reGenderID() async {
    await SharedPref().remove('genderID');
  }

  reMaritalStatus() async {
    await SharedPref().remove('maritalStatus');
  }

  reMaritalStatusID() async {
    await SharedPref().remove('maritalStatusID');
  }

  reProvinceOrState() async {
    await SharedPref().remove('POS');
  }

  reProvinceOrStateID() async {
    await SharedPref().remove('POSID');
  }

  reDistrictOrCity() async {
    await SharedPref().remove('DOC');
  }

  reDistrictOrCityID() async {
    await SharedPref().remove('DOCID');
  }

  reProfSummary() async {
    await SharedPref().remove('profSummary');
  }

  reLatestJobTitle() async {
    await SharedPref().remove('latestJobTitle');
  }

  reTotalWorkEXP() async {
    await SharedPref().remove('totalWorkEXP');
  }

  reDOB() async {
    await SharedPref().remove('dob');
  }

  reCV() async {
    await SharedPref().remove('cv');
  }

  rePreviousJobTitle() async {
    await SharedPref().remove('previousJobTitle');
  }

  rePreviousEmployer() async {
    await SharedPref().remove('previousEmployer');
  }

  reDrivingLicense() async {
    await SharedPref().remove('drivingLicense');
  }

  rePreviousIndustry() async {
    await SharedPref().remove('previousIndustry');
  }

  rePreviousIndID() async {
    await SharedPref().remove('previousIndID');
  }

  reFieldstudyName() async {
    await SharedPref().remove('fieldstudyName');
  }

  reFieldstudyDegree() async {
    await SharedPref().remove('fieldstudyDegree');
  }

  reDistrictRepoindex() async {
    await SharedPref().remove('districtRepoindex');
  }

  reDegreeID() async {
    await SharedPref().remove('degreeID');
  }

  reLangName() async {
    await SharedPref().remove('langName');
  }

  reLangNameID() async {
    await SharedPref().remove('langNameID');
  }

  reLangLevel() async {
    await SharedPref().remove('langLevel');
  }

  reLangLevelID() async {
    await SharedPref().remove('langLevelID');
  }

  rekeySkill() async {
    await SharedPref().remove('keySkill');
  }
}
