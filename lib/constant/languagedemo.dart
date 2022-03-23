int indexL = 0;
Languages l = Languages();
changLanguage() {
  l = Languages();
}

class Languages {
  /// title
  ///
  String featureCom = indexL == 0 ? 'FEATURED COMPANY' : 'ບໍລິສັດແນະນຳ';
  String positionAvai =
      indexL == 0 ? 'POSITION AVAILABLE' : 'ຕຳແໜ່ງທີ່ກຳລັງເປີດຮັບ';
  String hotjob = indexL == 0 ? 'HOT JOBS' : 'ວຽກທີ່ໜ້າສົນໃຈ';
  String featureJob = indexL == 0 ? 'FEATURED JOBS' : 'ວຽກແນະນຳ';
  String seeall = indexL == 0 ? 'see all' : 'ເບິ່ງທັງໝົດ';
  String morejob = indexL == 0 ? 'More Jobs' : 'ເບິ່ງເພີ່ມ';
  String to = indexL == 0 ? 'to' : 'ຫາ';
  String location = indexL == 0 ? 'Location' : 'ສະຖານທີ່';
  String jobOpening = indexL == 0 ? 'Job Opening' : 'ກຳລັງເປີດຮັບ';
  String allCompanies = indexL == 0 ? 'All Companies' : 'ບໍລິສັດທັງໝົດ';
  String hiring = indexL == 0 ? 'Hiring Now' : 'ກຳລັງເປີດຮັບ';
  String alljob = indexL == 0 ? 'All Jobs' : 'ວຽກທັງໝົດ';
  String newGrad = indexL == 0 ? 'New Grad' : 'ນັກສຶກສາຈົບໃໝ່';
  String endingSoon = indexL == 0 ? 'Ending Soon' : 'ກຳລັງຈະປິດ';
  String savedjob = indexL == 0 ? 'Saved Jobs' : 'ວຽກທີ່ບັນທຶກ';
  String appliedjob = indexL == 0 ? 'Applied Jobs' : 'ວຽກສະໝັກແລ້ວ';
  String myResume = indexL == 0 ? 'My Resume' : 'ຊີວະປະຫວັດ';
  String helpcenter = indexL == 0 ? 'Help center' : 'ສູນຊ່ວຍເຫຼືອ';
  String account = indexL == 0 ? 'Account' : 'ບັນຊີຂອງທ່ານ';
  String myaccount = indexL == 0 ? 'My account' : 'ບັນຊີຂອງຂ້ອຍ';
  String logout = indexL == 0 ? 'Log out' : 'ອອກຈາກລະບົບ';
  String home = indexL == 0 ? 'Home' : 'ໜ້າຫຼັກ';
  String companies = indexL == 0 ? 'Companies' : 'ບໍລິສັດ';
  String jobs = indexL == 0 ? 'Jobs' : 'ວຽກ';
  String myjob = indexL == 0 ? 'My job' : 'ວຽກຂອງຂ້ອຍ';
  String myprofile = indexL == 0 ? 'My profile' : 'ຂໍ້ມູນສ່ວນຕົວ';
  String nothing = indexL == 0 ? 'Nothing' : 'ວ່າງ';
  String younotSignin =
      indexL == 0 ? 'You\'re not sign in' : 'ຍັງບໍ່ທັນເຂົ້າໃຊ້ງານ';
  String gotoSignin = indexL == 0 ? 'Go to Sign in' : 'ໄປທີ່ໜ້າເຂົ້າໃຊ້ງານ';
  String loginWithyour = indexL == 0
      ? 'Login with your\nregistered mobile number'
      : 'ເຂົ້າໃຊ້ງານດ້ວຍເບີໂທ\nທີ່ທ່ານເຄີຍສະໝັກ';
  String jobdetail = indexL == 0 ? 'Job detail' : 'ລາຍລະອຽດວຽກ';
  String youareNotSignIn =
      indexL == 0 ? 'You must sign in' : 'ທ່ານຕ້ອງເຂົ້າສູ່ລະບົບກ່ອນ';
  String applyjob = indexL == 0 ? 'Apply job' : 'ສະໝັກວຽກ';
  String saved = indexL == 0 ? 'Saved' : 'ບັນທຶກແລ້ວ';
  String savejob = indexL == 0 ? 'Save job' : 'ບັນທຶກວຽກ';
  String doyouwanttoSignin =
      indexL == 0 ? 'Do you want to Sign in?' : 'ທ່ານຕ້ອງການເຂົ້າໃຊ້ງານຫຼືບໍ່?';
  String youalreadyApplied =
      indexL == 0 ? 'You already applied' : 'ທ່ານໄດ້ສະໝັກວຽກນີ້ແລ້ວ';
  String doyouApply = indexL == 0
      ? 'Do you want to apply this job?'
      : 'ທ່ານຕ້ອງການສະໝັກວຽກນີ້ແທ້ບໍ່?';
  String yourmobilehaschange = indexL == 0
      ? 'Your mobile number has changed'
      : 'ເບີໂທລະສັບຂອງທ່ານໄດ້ຖືກປ່ຽນແລ້ວ';
  String wrongmobile =
      indexL == 0 ? 'Wrong mobile number' : 'ເບີໂທລະສັບບໍ່ຖືກຕ້ອງ';
  String successful = indexL == 0 ? 'Successful' : 'ສຳເລັດ';
  String confirmpassword =
      indexL == 0 ? 'Confirm New Password' : 'ຢືນຢັນລະຫັດຜ່ານໃໝ່';
  String newpassword = indexL == 0 ? 'New Password' : 'ລະຫັດຜ່ານໃໝ່';
  String currentpassword =
      indexL == 0 ? 'Current Password' : 'ລະຫັດຜ່ານປະຈຸບັນ';
  String changepassword = indexL == 0 ? 'Change Password' : 'ປ່ຽນລະຫັດຜ່ານ';
  String changeEmail = indexL == 0 ? 'Change Email' : 'ປ່ຽນອີເມລ';
  String changphone = indexL == 0 ? 'Change Phone number' : 'ປ່ຽນເບີໂທລະສັບ';
  String jobDescript = indexL == 0 ? 'Job description' : 'ຄຳອະທິບາຍ';
  String eduLevel = indexL == 0 ? 'Education Level' : 'ລະດັບການສຶກສາ';
  String salary = indexL == 0 ? 'Salary' : 'ເງິນເດືອນ';
  String date = indexL == 0 ? 'Date' : 'ວັນທີ';
  String workinglocation = indexL == 0 ? 'Working Location' : 'ສະຖານທີ່ເຮັດວຽກ';
  String confirmation = indexL == 0 ? 'Confirmation' : 'ຢືນຢັນ';
  String mobileNumber = indexL == 0 ? 'Mobile Number' : 'ເບີໂທລະສັບ';
  String number = indexL == 0 ? 'Number' : 'ເບີໂທລະສັບ';
  String password = indexL == 0 ? 'Password' : 'ລະຫັດຜ່ານ';
  String login = indexL == 0 ? 'Login' : 'ເຂົ້າສູ່ລະບົບ';
  String forgotpassword = indexL == 0 ? 'Forgot Password' : 'ລືມລະຫັດຜ່ານ';
  String newUser = indexL == 0 ? 'New User?' : 'ຍັງບໍ່ທັນສະໝັກ?';
  String register = indexL == 0 ? 'Register' : 'ສະໝັກສະມາຊິກ';
  String loginConfidential =
      indexL == 0 ? 'LOGIN CONFIDENTIAL' : 'ການເຂົ້າສູ່ລະບົບ';
  String email = indexL == 0 ? 'Email' : 'ອີເມລ';
  String emailAdd = indexL == 0 ? 'Email address' : 'ທີ່ຢູ່ອີເມລ';
  String personalinfo =
      indexL == 0 ? 'PERSONAL INFOMATION' : 'ຂໍ້ມູນສ່ວນບຸກຄົນ';
  String fullname = indexL == 0 ? 'Full name' : 'ຊື່ ແລະ ນາມສະກຸນ';
  String dob = indexL == 0 ? 'Date of birth' : 'ວັນເດືອນປີເກີດ';
  String gender = indexL == 0 ? 'Gender' : 'ເພດ';
  String maritalstt = indexL == 0 ? 'Marital Status' : 'ສະຖານະ';
  String drivinglic = indexL == 0 ? 'Driving license' : 'ໃບຂັບຂີ່';
  String provincAndDistrict =
      indexL == 0 ? 'Province / State, District / City' : 'ແຂວງ ແລະ ເມືອງ';
  String district = indexL == 0 ? 'District / City' : 'ເມືອງ';
  String profesSum = indexL == 0 ? 'Professional Summary' : 'ທັກສະໂດຍລວມ';
  String uploadCv = indexL == 0 ? 'UPLOAD CV' : 'ອັບໂຫຼດ ຊີວະປະຫວັດ';
  String enterValidfulname =
      indexL == 0 ? 'Enter valid full name' : 'ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຖຶກຕ້ອງ';
  String selectfile = indexL == 0 ? 'Select file' : 'ເລຶອກໄຟລ໌';
  String moreCompanies = indexL == 0 ? 'More companies' : 'ເບິ່ງບໍລິສັດເພິ່ມ';
  String supportfileCV = indexL == 0
      ? 'Supported file type .docx .pdf\nMaximum 5 mb'
      : 'ສາມາດຮັບໄຟລນາມສະກຸນ .DOCX .PDF\nຂະໜາດໃຫຍ່ສຸດ 5 ເມກະໄບຄ໌';
  String workingexpe =
      indexL == 0 ? 'working experience' : 'ປະສົບການການເຮັດວຽກ';
  String workingexp = indexL == 0 ? 'WORKING EXPERIENCE' : 'ປະສົບການການເຮັດວຽກ';
  String addworkingEXP = indexL == 0
      ? 'Add you work experience'
      : 'ເພິ່ມປະສົບການການເຮັດວຽກຂອງທ່ານ';
  String yourEmailhasChanged =
      indexL == 0 ? 'Your email has changed0' : 'ອີເມລຂອງທ່ານຖືກປ່ຽນແປງແລ້ວ';
  String addEXP = indexL == 0 ? 'Add Experience' : 'ເພິ່ມປະສົບການ';
  String education = indexL == 0 ? 'EDUCATION' : 'ການສຶກສາ';
  String tellusEdu = indexL == 0
      ? 'Tell us about your education and skill'
      : 'ບອກພວກເຮົາກ່ຽວກັບຄວາມຮູ້ຂອງທ່ານ';
  String addedu = indexL == 0 ? 'Add Education' : 'ເພີ່ມການສຶກສາ';
  String save = indexL == 0 ? 'Save' : 'ບັນທຶກ';
  String idontworkingexp = indexL == 0
      ? 'I don\'t have working experience'
      : 'ຍັງບໍ່ມີປະສົບການເທື່ອ';
  String latestjob = indexL == 0 ? 'Latest Job Title' : 'ຕຳແໜ່ງລ່າສຸດ';
  String salaryRange = indexL == 0 ? 'Salary Range' : 'ຂອບເຂດເງິນເດືອນ';
  String previousJobTitle =
      indexL == 0 ? 'Previous Job Title' : 'ຕຳແໜ່ງວຽກກ່ອນໜ້ານີ້';
  String previousEmployer =
      indexL == 0 ? 'Previous Employer' : 'ຜູ້ວ່າຈ້າງກ່ອນໜ້ານີ້';
  String previousIndustry =
      indexL == 0 ? 'Previous Employer\'s Industry' : 'ປະເພດທຸລະກິດກ່ອນໜ້ານີ້';
  String totalWorkingExperience = indexL == 0
      ? 'Total Working Experience(Years)'
      : 'ລວມປະສົບການການເຮັດວຽກ(ເປັນປີ)';
  String enterLatest =
      indexL == 0 ? 'Enter latest job title' : 'ໃສ່ຕຳແໜ່ງລ່າສຸດ';
  String enterSalary =
      indexL == 0 ? 'Enter salary range' : 'ໃສ່ຂອບເຂດເງິນເດືອນ';
  String enterPreJob =
      indexL == 0 ? 'Enter previous job title' : 'ໃສ່ຕຳແໜ່ງວຽກກ່ອນໜ້ານີ້';
  String enterPreEmp =
      indexL == 0 ? 'Enter previous employer' : 'ໃສ່ຜູ້ວ່າຈ້າງກ່ອນໜ້ານີ້';
  String enterPreEmpInd = indexL == 0
      ? 'Enter Previous\nEmployer\'s Industry'
      : 'ໃສ່ປະເພດທຸລະກິດກ່ອນໜ້ານີ້';
  String firstname = indexL == 0 ? 'First Name' : 'ຊື່';
  String enterTotalEXP =
      indexL == 0 ? 'Enter Total Working Experience' : 'ໃສ່ປະສົບການການເຮັດວຽກ';
  String lastname = indexL == 0 ? 'Last Name' : 'ນາມສະກຸນ';
  String correctINfo = indexL == 0
      ? 'Please correct your information\ndo not let field empty'
      : 'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບຖ້ວນ';
  String tellusAboutU =
      indexL == 0 ? 'Tell us about yourself' : 'ອະທິບາຍທັກສະຂອງທ່ານ';
  String cannotSaveEmpty = indexL == 0
      ? 'Cannot save empty license'
      : 'ບໍ່ສາມາດບັນທຶກຄ່າວ່າງໄດ້\nກະລຸນາເລືອກໃບຂັບຂີ່';
  String addindustry = indexL == 0
      ? ' Add another employer industry'
      : ' ເພິ່ມປະເພດທຸລະກິດຂອງຜູ້ວ່າຈ້າງ';
  String addFieldStudy =
      indexL == 0 ? ' Add another field of study' : ' ເພິ່ມສາຂາວິຊາ';
  String addKeySkill = indexL == 0 ? ' Add another key skill' : ' ເພິ່ມທັກສະ';
  String addlanguage = indexL == 0 ? ' Add another language' : ' ເພິ່ມພາສາ';
  String selectLang = indexL == 0 ? 'Select Language' : 'ເລືອກລະດັບ';
  String selectlevel = indexL == 0 ? 'Selected Language' : 'ເລືອກລະດັບ';
  String addemployer =
      indexL == 0 ? ' Add another employer' : ' ເພິ່ມຜູ້ວ່າຈ້າງ';
  String addjobtitle = indexL == 0 ? ' Add another job title' : ' ເພິ່ມຕຳແໜ່ງ';
  String selectsalary =
      indexL == 0 ? 'Select Salary Range' : 'ເລືອກຂອບເຂດເງິນເດືອນ';
  String selectindus = indexL == 0
      ? 'Select previous employer industry'
      : 'ເລືອກປະເພດທຸລະກິດຂອງຜູ້ວ່າຈ້າງ';
  String selectDegree = indexL == 0 ? 'Select degree' : 'ເລືອກລະດັບ';
  String prosumDetail = indexL == 0
      ? 'Start with a catchy opening such as I’m a friendly person: who has always had a passion for cooking'
      : 'ເລີ່ມຈາກຄຳຊັບທີ່ໜ້າປະທັບໃຈ ຕົວຢ່າງເຊັ່ນ: ຂ້ອຍເປັນຄົນເຂົ້າກັບທີມງານໄດ້ງ່າຍ: ມີຄວາມພ້ອມຕໍ່ໜ້າທີ່ວຽກງານສູງ...';
  String selectLicense = indexL == 0 ? 'Select your license' : 'ເລືອກໃບຂັບຂີ່';

  String enterdob = indexL == 0 ? 'Enter date of birth' : 'ໃສ່ວັນເດືອນປີເກີດ';
  String enterGender = indexL == 0 ? 'Enter gender' : 'ໃສ່ເພດ';
  String enterMarital = indexL == 0 ? 'Enter marital status' : 'ໃສ່ສະຖານະ';
  String enterDriving = indexL == 0 ? 'Enter driving license' : 'ໃສ່ໃບຂັບຂີ່';
  String enterProvince = indexL == 0 ? 'Enter province / state' : 'ໃສ່ແຂວງ';
  String enterDistrict = indexL == 0 ? 'Enter district / city' : 'ໃສ່ເມືອງ';
  String enterProfesum =
      indexL == 0 ? 'Enter professional summary' : 'ໃສ່ທັກສະໂດຍລວມ';
  String fieldofStudy = indexL == 0 ? 'Field of study' : 'ສາຂາວິຊາຮຽນ';
  String enterfieldofStudy =
      indexL == 0 ? 'enter field of study' : 'ສາຂາວິຊາຮຽນ';
  String language = indexL == 0 ? 'Language' : 'ພາສາ';
  String enterLanguage = indexL == 0 ? 'Enter language' : 'ໃສ່ພາສາ';
  String keySkill = indexL == 0 ? 'Key Skill' : 'ທັກສະ';
  String enterkeySkill = indexL == 0 ? 'Enter key skill' : 'ໃສ່ທັກສະ';
  String cannotUpload = indexL == 0 ? 'Cannot upload' : 'ບໍ່ສາມາດອັບໂຫຼດ';
  String ok = indexL == 0 ? 'Okay' : 'ຕົກລົງ';
  String thisImageSizelarge = indexL == 0
      ? 'The image size is too large\nmaximum size 15mb'
      : 'ຮູບພາບມີຂະໜາດໃຫຍ່ເກີນໄປ\nຂະໜາດສູງສຸດແມ່ນ 15 ເມັກກະໄບທ໌';
  String thisFileSizeLarge = indexL == 0
      ? 'The file Size is too large\nmaximum is 5 mb'
      : 'ໄຟລ໌ມີຂະໜາດໃຫຍ່ເກີນໄປ\nຂະໜາດສູງສຸດແມ່ນ 5 ເມັກກະໄບທ໌';
  String cancel = indexL == 0 ? 'Cancel' : 'ຍົກເລີກ';
  String recoveryAlert = indexL == 0 ? 'Recovery Alert' : 'ພົບຂໍ້ມູນທີ່ເຄີຍໃສ່';
  String youalrealfilled = indexL == 0
      ? 'You already filled this form before\n Do you want to continue?'
      : 'ທ່ານເຄີຍໃສ່ຂໍ້ມູນໃນຟອມນີ້ແລ້ວ\nທ່ານຕ້ອງການກູ້ຄືນຂໍ້ມູນນັ້ນຫຼຶບໍ່';
  String continues = indexL == 0 ? 'Continue' : 'ຕົກລົງ';
  String uploadingInfo =
      indexL == 0 ? 'Uploading information' : 'ກຳລັງອັບໂຫຼດຂໍ້ມູນ';
  String enterProfile = indexL == 0 ? 'Enter profile' : 'ໃສ່ຮູບໂປຣ໌ໍໄຟລ໌';
  String entervalidEmail = indexL == 0
      ? 'Please enter valid email example: 108jobs@job.com'
      : 'ກະລຸນາໃສ່ອີເມລທີ່ຖືກຕ້ອງຕົວຢ່າງເຊັນ:108jobs@job.com';
  String yourpasswordhasChange = indexL == 0
      ? 'Your password has changed'
      : 'ລະຫັດຜ່ານຂອງທ່ານໄດ້ຖືກປ່ຽນແລ້ວ';
  String numberMust = indexL == 0
      ? 'Number must be 8 numberic'
      : 'ເບີໂທຕ້ອງແມ່ນຕົວເລກ 8 ຕົວເລກ';
  String notmatch =
      indexL == 0 ? 'Not match with new password' : 'ບໍ່ກົງກັບລະຫັດຜ່ານໃໝ່';
  String passwordMust = indexL == 0
      ? 'Password must be at least 8 characters'
      : 'ລະຫັດຜ່ານຕ້ອງມີ 8 ຕົວຂຶ້ນໄປແລະຄວນເປັນພາສາອັງກິດ';
  String choosepic = indexL == 0 ? 'Choose picture' : 'ເລືອກຮູບພາບ';
  String camera = indexL == 0 ? 'Camera' : 'ຈາກກ້ອງ';
  String gallery = indexL == 0 ? 'Gallery' : 'ຈາກໂທລະສັບ';
  String alert = indexL == 0 ? 'Alert' : 'ແຈ້ງເຕືອນ';
  String thisEmailAlready = indexL == 0
      ? 'This email already registed'
      : 'ອີເມລຂອງທ່ານໄດ້ຖືກລົງທະບຽນກ່ອນໜ້ານີ້ແລ້ວ';
  String thisNumberAlready = indexL == 0
      ? 'This mobile number already registed'
      : 'ເບີໂທຂອງທ່ານໄດ້ຖືກລົງທະບຽນກ່ອນໜ້ານີ້ແລ້ວ';
  String yourfromnotfinish =
      indexL == 0 ? 'Your form is not finished yet' : 'ຟອມຂອງທ່ານຍັງບໍ່ສົມບູນ';
  String saveOrnot = indexL == 0
      ? 'Do you want to save new\ninformation or not?'
      : 'ທ່ານຕ້ອງການບັນທຶກຂໍ້ມູນທີ່ມີການ\nປ່ຽນແປງນີ້ຫຼຶບໍ່';
  String infonotsave =
      indexL == 0 ? 'Infomation not save yet' : 'ຂໍ້ມູນຍັງບໍ່ທັນບັນທຶກ';
  String noEXP =
      indexL == 0 ? 'No working experience' : 'ບໍ່ມີປະສົບການການເຮັດວຽກ';
  String yes = indexL == 0 ? 'Yes' : 'ຕົກລົງ';
  String no = indexL == 0 ? 'No' : 'ບໍ່';
  String loading = indexL == 0 ? 'Loading' : 'ກຳລັງໂຫຼດ';
  String searchCV = indexL == 0 ? 'Resume Search' : 'ສະແດງຊີວະປະຫວັດ';
  String makeYourProfileSearch = indexL == 0
      ? 'Make your profile searchable to increase your visibility to employers'
      : 'ເຮັດໃຫ້ຂໍ້ມູນຂອງທ່ານສາມາດຄົ້ນຫາໄດ້ ເພິ່ມການເຂົ້າເຖິງໃຫ້ແກ່ບໍລິສັດ';
  String enterYourNumber = indexL == 0
      ? 'Enter your number which you forgot password'
      : 'ໃສ່ເບີໂທລະສັບທີ່ທ່ານນັ້ນລືມລະຫັດຜ່ານ';
  String confirmMATION = indexL == 0 ? 'Confirm' : 'ຢືນຢັນ';
  String verifyphone =
      indexL == 0 ? 'Verify phone number' : 'ຢັ້ງຢືນເບີໂທລະສັບ';
  String enterOTPCode =
      indexL == 0 ? 'Enter OTP Code sent to' : 'ໃສ່ລະຫັດ OTP ທີ່ສົ່ງເຂົ້າເບີ';
  String verifying = indexL == 0 ? 'Verifying' : 'ກຳລັງຢັ້ງຢືນ';
  String cannotverify =
      indexL == 0 ? 'Cannot verify number' : 'ບໍ່ສາມາດຢັ້ງຢືນເບີໂທໄດ້';
  String pleasecheckotp =
      indexL == 0 ? 'Please check your OTP' : 'ກະລຸນາກວດສອບລະຫັດ OTP ອີກຄັ້ງ';
  String hasVerify =
      indexL == 0 ? 'Your number has verified' : 'ເບີຂອງທ່ານໄດ້ຖືກຢັ້ງຢືນແລ້ວ';
  String pleaseEnterOTP = indexL == 0 ? 'Please enter OTP' : 'ກະລຸນາໃສ່ເລກ OTP';
  String dontReciv =
      indexL == 0 ? 'You don\'t reveive the code' : 'ເຈົ້າຍັງບໍ່ໄດ້ຮັບລະຫັດ';
  String recendCode = indexL == 0 ? 'Recend Code' : 'ສົ່ງລະຫັດຄືນໃໝ່';
  String wealreadysent = indexL == 0
      ? 'We already sent new otp waiting 60 seconds to sent it again'
      : 'ພວກເຮົາໄດ້ສົ່ງລະຫັດ OTP ໃໝ່ແລ້ວ ຖ້າ 60 ວິນາທີ ເພື່ອສົ່ງລະຫັດອີກ';
  String cannotResetThisPass = indexL == 0
      ? 'Cannot reset this password'
      : 'ບໍ່ສາມາດປ່ຽນລະຫັດຜ່ານນີ້ໄດ້';
  String newPassmust = indexL == 0
      ? 'New password must be at least 8 characters'
      : 'ລະຫັດໃໝ່ຈະຕ້ອງເປັນຕົວອັກສອນ 8 ຕົວຂຶ້ນໄປ';
  String searchCompany = indexL == 0 ? 'Search Company' : 'ຄົ້ນຫາບໍລິສັດ';
  String industryCAP = indexL == 0 ? 'INDUSTRY' : 'ປະເພດທຸລະກິດ';
  String sortbyindustry =
      indexL == 0 ? 'Sort by Company Industry' : 'ຄົ້ນຫາດ້ວຍປະເພດທຸລະກິດ';
  String jobfunction = indexL == 0 ? 'Job Function' : 'ປະເພດວຽກ';
  String locationCAP = indexL == 0 ? 'LOCATION' : 'ສະຖານທີ່';
  String searchjob = indexL == 0 ? 'Search Job' : 'ຄົ້ນຫາວຽກ';
  String jobFunctionCAP = indexL == 0 ? 'JOB FUNCTION' : 'ປະເພດວຽກ';
  String finish = indexL == 0 ? 'finish' : 'ຕົກລົງ';
  String selectedCAP = indexL == 0 ? 'SELECTED' : 'ເລືອກແລ້ວ';
  String clear = indexL == 0 ? 'Clear' : 'ລຶບທັງໝົດ';
  String recentSearch = indexL == 0 ? 'RECENT SEARCH' : 'ຄຳຄົ້ນຫາກ່ອນໜ້າ';
  String empty = indexL == 0 ? 'Empty' : 'ວ່າງ';

  // change() {
  //   featureCom = indexL == 0 ? 'FEATURED COMPANY' : 'ບໍລິສັດແນະນຳ';
  //   positionAvai = indexL == 0 ? 'POSITION AVAILABLE' : 'ຕຳແໜ່ງທີ່ກຳລັງເປີດຮັບ';
  //   hotjob = indexL == 0 ? 'HOT JOBS' : 'ວຽກທີ່ໜ້າສົນໃຈ';
  //   featureJob = indexL == 0 ? 'FEATURED JOBS' : 'ວຽກແນະນຳ';
  //   seeall = indexL == 0 ? 'see all' : 'ເບິ່ງທັງໝົດ';
  //   morejob = indexL == 0 ? 'More Jobs' : 'ເບິ່ງເພີ່ມ';
  //   to = indexL == 0 ? 'to' : 'ຫາ';
  //   location = indexL == 0 ? 'Location' : 'ສະຖານທີ່';
  //   jobOpening = indexL == 0 ? 'Job Opening' : 'ກຳລັງເປີດຮັບ';
  //   allCompanies = indexL == 0 ? 'All Companies' : 'ບໍລິສັດທັງໝົດ';
  //   hiring = indexL == 0 ? 'Hiring Now' : 'ກຳລັງເປີດຮັບ';
  //   alljob = indexL == 0 ? 'All Jobs' : 'ວຽກທັງໝົດ';
  //   newGrad = indexL == 0 ? 'New Grad' : 'ນັກສຶກສາຈົບໃໝ່';
  //   endingSoon = indexL == 0 ? 'Ending Soon' : 'ກຳລັງຈະປິດ';
  //   savedjob = indexL == 0 ? 'Saved Jobs' : 'ວຽກທີ່ບັນທຶກ';
  //   appliedjob = indexL == 0 ? 'Applied Jobs' : 'ວຽກສະໝັກແລ້ວ';
  //   myResume = indexL == 0 ? 'My Resume' : 'ຊີວະປະຫວັດ';
  //   helpcenter = indexL == 0 ? 'Help center' : 'ສູນຊ່ວຍເຫຼືອ';
  //   account = indexL == 0 ? 'Account' : 'ບັນຊີຂອງທ່ານ';
  //   myaccount = indexL == 0 ? 'My account' : 'ບັນຊີຂອງຂ້ອຍ';
  //   logout = indexL == 0 ? 'Log out' : 'ອອກຈາກລະບົບ';
  //   home = indexL == 0 ? 'Home' : 'ໜ້າຫຼັກ';
  //   companies = indexL == 0 ? 'Companies' : 'ບໍລິສັດ';
  //   jobs = indexL == 0 ? 'Jobs' : 'ວຽກ';
  //   myjob = indexL == 0 ? 'My job' : 'ວຽກຂອງຂ້ອຍ';
  //   myprofile = indexL == 0 ? 'My profile' : 'ຂໍ້ມູນສ່ວນຕົວ';
  //   nothing = indexL == 0 ? 'Nothing' : 'ວ່າງ';
  //   younotSignin = indexL == 0 ? 'You\'re not sign in' : 'ຍັງບໍ່ທັນເຂົ້າໃຊ້ງານ';
  //   gotoSignin = indexL == 0 ? 'Go to Sign in' : 'ໄປທີ່ໜ້າເຂົ້າໃຊ້ງານ';
  //   loginWithyour = indexL == 0
  //       ? 'Login with your\nregistered mobile number'
  //       : 'ເຂົ້າໃຊ້ງານດ້ວຍເບີໂທ\nທີ່ທ່ານເຄີຍສະໝັກ';
  //   jobdetail = indexL == 0 ? 'Job detail' : 'ຂໍ້ມູນວຽກ';
  //   youareNotSignIn =
  //       indexL == 0 ? 'You must sign in' : 'ທ່ານຕ້ອງເຂົ້າສູ່ລະບົບກ່ອນ';
  //   applyjob = indexL == 0 ? 'Apply job' : 'ສະໝັກວຽກ';
  //   saved = indexL == 0 ? 'Saved' : 'ບັນທຶກແລ້ວ';
  //   savejob = indexL == 0 ? 'Save job' : 'ບັນທຶກວຽກ';
  //   doyouwanttoSignin = indexL == 0
  //       ? 'Do you want to Sign in?'
  //       : 'ທ່ານຕ້ອງການເຂົ້າໃຊ້ງານຫຼືບໍ່?';
  //   youalreadyApplied =
  //       indexL == 0 ? 'You already applied' : 'ທ່ານໄດ້ສະໝັກວຽກນີ້ແລ້ວ';
  //   doyouApply = indexL == 0
  //       ? 'Do you want to apply this job?'
  //       : 'ທ່ານຕ້ອງການສະໝັກວຽກນີ້ແທ້ບໍ່?';
  //   yourmobilehaschange = indexL == 0
  //       ? 'Your mobile number has changed'
  //       : 'ເບີໂທລະສັບຂອງທ່ານໄດ້ຖືກປ່ຽນແລ້ວ';
  //   wrongmobile = indexL == 0 ? 'Wrong mobile number' : 'ເບີໂທລະສັບບໍ່ຖືກຕ້ອງ';
  //   successful = indexL == 0 ? 'Successful' : 'ສຳເລັດ';
  //   confirmpassword =
  //       indexL == 0 ? 'Confirm New Password' : 'ຢືນຢັນລະຫັດຜ່ານໃໝ່';
  //   newpassword = indexL == 0 ? 'New Password' : 'ລະຫັດຜ່ານໃໝ່';
  //   currentpassword = indexL == 0 ? 'Current Password' : 'ລະຫັດຜ່ານປະຈຸບັນ';
  //   changepassword = indexL == 0 ? 'Change Password' : 'ປ່ຽນລະຫັດຜ່ານ';
  //   changeEmail = indexL == 0 ? 'Change Email' : 'ປ່ຽນອີເມລ';
  //   changphone = indexL == 0 ? 'Change Phone number' : 'ປ່ຽນເບີໂທລະສັບ';
  //   jobDescript = indexL == 0 ? 'Job description' : 'ຄຳອະທິບາຍ';
  //   eduLevel = indexL == 0 ? 'Education Level' : 'ລະດັບການສຶກສາ';
  //   salary = indexL == 0 ? 'Salary' : 'ເງິນເດືອນ';
  //   date = indexL == 0 ? 'Date' : 'ວັນທີ';
  //   workinglocation = indexL == 0 ? 'Working Location' : 'ສະຖານທີ່ເຮັດວຽກ';
  //   confirmation = indexL == 0 ? 'Confirmation' : 'ຢືນຢັນ';
  //   mobileNumber = indexL == 0 ? 'Mobile Number' : 'ເບີໂທລະສັບ';
  //   number = indexL == 0 ? 'Number' : 'ເບີໂທລະສັບ';
  //   password = indexL == 0 ? 'Password' : 'ລະຫັດຜ່ານ';
  //   login = indexL == 0 ? 'Login' : 'ເຂົ້າສູ່ລະບົບ';
  //   forgotpassword = indexL == 0 ? 'Forgot Password' : 'ລືມລະຫັດຜ່ານ';
  //   newUser = indexL == 0 ? 'New User?' : 'ຍັງບໍ່ທັນສະໝັກ?';
  //   register = indexL == 0 ? 'Register' : 'ສະໝັກສະມາຊິກ';
  //   loginConfidential = indexL == 0 ? 'LOGIN CONFIDENTIAL' : 'ການເຂົ້າສູ່ລະບົບ';
  //   email = indexL == 0 ? 'Email' : 'ອີເມລ';
  //   emailAdd = indexL == 0 ? 'Email address' : 'ທີ່ຢູ່ອີເມລ';
  //   personalinfo = indexL == 0 ? 'PERSONAL INFOMATION' : 'ຂໍ້ມູນສ່ວນບຸກຄົນ';
  //   fullname = indexL == 0 ? 'Full name' : 'ຊື່ ແລະ ນາມສະກຸນ';
  //   dob = indexL == 0 ? 'Date of birth' : 'ວັນເດືອນປີເກີດ';
  //   gender = indexL == 0 ? 'Gender' : 'ເພດ';
  //   maritalstt = indexL == 0 ? 'Marital Status' : 'ສະຖານະ';
  //   drivinglic = indexL == 0 ? 'Driving license' : 'ໃບຂັບຂີ່';
  //   province = indexL == 0 ? 'Province / State' : 'ແຂວງ';
  //   district = indexL == 0 ? 'District / City' : 'ເມືອງ';
  //   profesSum = indexL == 0 ? 'Professional Summary' : 'ທັກສະໂດຍລວມ';
  //   uploadCv = indexL == 0 ? 'UPLOAD CV' : 'ອັບໂຫຼດ ຊີວະປະຫວັດ';
  //   enterValidfulname =
  //       indexL == 0 ? 'Enter valid full name' : 'ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຖຶກຕ້ອງ';
  //   selectfile = indexL == 0 ? 'Select file' : 'ເລຶອກໄຟລ໌';
  //   moreCompanies = indexL == 0 ? 'More companies' : 'ເບິ່ງບໍລິສັດເພິ່ມ';
  //   supportfileCV = indexL == 0
  //       ? 'Supported file type .docx .pdf\nMaximum 5 mb'
  //       : 'ສາມາດຮັບໄຟລນາມສະກຸນ .DOCX .PDF\nຂະໜາດໃຫຍ່ສຸດ 5 ເມກະໄບຄ໌';
  //   workingexpe = indexL == 0 ? 'working experience' : 'ປະສົບການການເຮັດວຽກ';
  //   workingexp = indexL == 0 ? 'WORKING EXPERIENCE' : 'ປະສົບການການເຮັດວຽກ';
  //   addworkingEXP = indexL == 0
  //       ? 'Add you work experience'
  //       : 'ເພິ່ມປະສົບການການເຮັດວຽກຂອງທ່ານ';
  //   yourEmailhasChanged =
  //       indexL == 0 ? 'Your email has changed0' : 'ອີເມລຂອງທ່ານຖືກປ່ຽນແປງແລ້ວ';
  //   addEXP = indexL == 0 ? 'Add Experience' : 'ເພິ່ມປະສົບການ';
  //   education = indexL == 0 ? 'EDUCATION' : 'ການສຶກສາ';
  //   tellusEdu = indexL == 0
  //       ? 'Tell us about your education and skill'
  //       : 'ບອກພວກເຮົາກ່ຽວກັບຄວາມຮູ້ຂອງທ່ານ';
  //   addedu = indexL == 0 ? 'Add Education' : 'ເພີ່ມການສຶກສາ';
  //   save = indexL == 0 ? 'Save' : 'ບັນທຶກ';
  //   idontworkingexp = indexL == 0
  //       ? 'I don\'t have working experience'
  //       : 'ຍັງບໍ່ມີປະສົບການເທື່ອ';
  //   latestjob = indexL == 0 ? 'Latest Job Title' : 'ຕຳແໜ່ງລ່າສຸດ';
  //   salaryRange = indexL == 0 ? 'Salary Range' : 'ຂອບເຂດເງິນເດືອນ';
  //   previousJobTitle =
  //       indexL == 0 ? 'Previous Job Title' : 'ຕຳແໜ່ງວຽກກ່ອນໜ້ານີ້';
  //   previousEmployer =
  //       indexL == 0 ? 'Previous Employer' : 'ຜູ້ວ່າຈ້າງກ່ອນໜ້ານີ້';
  //   previousIndustry = indexL == 0
  //       ? 'Previous Employer\'s Industry'
  //       : 'ປະເພດທຸລະກິດກ່ອນໜ້ານີ້';
  //   totalWorkingExperience = indexL == 0
  //       ? 'Total Working Experience(Years)'
  //       : 'ລວມປະສົບການການເຮັດວຽກ(ເປັນປີ)';
  //   enterLatest = indexL == 0 ? 'Enter latest job title' : 'ໃສ່ຕຳແໜ່ງລ່າສຸດ';
  //   enterSalary = indexL == 0 ? 'Enter salary range' : 'ໃສ່ຂອບເຂດເງິນເດືອນ';
  //   enterPreJob =
  //       indexL == 0 ? 'Enter previous job title' : 'ໃສ່ຕຳແໜ່ງວຽກກ່ອນໜ້ານີ້';
  //   enterPreEmp =
  //       indexL == 0 ? 'Enter previous employer' : 'ໃສ່ຜູ້ວ່າຈ້າງກ່ອນໜ້ານີ້';
  //   enterPreEmpInd = indexL == 0
  //       ? 'Enter Previous\nEmployer\'s Industry'
  //       : 'ໃສ່ປະເພດທຸລະກິດກ່ອນໜ້ານີ້';
  //   firstname = indexL == 0 ? 'First Name' : 'ຊື່';
  //   enterTotalEXP = indexL == 0
  //       ? 'Enter Total Working Experience'
  //       : 'ໃສ່ປະສົບການການເຮັດວຽກ';
  //   lastname = indexL == 0 ? 'Last Name' : 'ນາມສະກຸນ';
  //   correctINfo = indexL == 0
  //       ? 'Please correct your information\ndo not let field empty'
  //       : 'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບຖ້ວນ';
  //   tellusAboutU =
  //       indexL == 0 ? 'Tell us about yourself' : 'ອະທິບາຍທັກສະຂອງທ່ານ';
  //   cannotSaveEmpty = indexL == 0
  //       ? 'Cannot save empty license'
  //       : 'ບໍ່ສາມາດບັນທຶກຄ່າວ່າງໄດ້\nກະລຸນາເລືອກໃບຂັບຂີ່';
  //   addindustry = indexL == 0
  //       ? ' Add another employer industry'
  //       : ' ເພິ່ມປະເພດທຸລະກິດຂອງຜູ້ວ່າຈ້າງ';
  //   addFieldStudy =
  //       indexL == 0 ? ' Add another field of study' : ' ເພິ່ມສາຂາວິຊາ';
  //   addKeySkill = indexL == 0 ? ' Add another key skill' : ' ເພິ່ມທັກສະ';
  //   addlanguage = indexL == 0 ? ' Add another language' : ' ເພິ່ມພາສາ';
  //   selectLang = indexL == 0 ? 'Select Language' : 'ເລືອກລະດັບ';
  //   selectlevel = indexL == 0 ? 'Selected Language' : 'ເລືອກລະດັບ';
  //   addemployer = indexL == 0 ? ' Add another employer' : ' ເພິ່ມຜູ້ວ່າຈ້າງ';
  //   addjobtitle = indexL == 0 ? ' Add another job title' : ' ເພິ່ມຕຳແໜ່ງ';
  //   selectsalary = indexL == 0 ? 'Select Salary Range' : 'ເລືອກຂອບເຂດເງິນເດືອນ';
  //   selectindus = indexL == 0
  //       ? 'Select previous employer industry'
  //       : 'ເລືອກປະເພດທຸລະກິດຂອງຜູ້ວ່າຈ້າງ';
  //   selectDegree = indexL == 0 ? 'Select degree' : 'ເລືອກລະດັບ';
  //   prosumDetail = indexL == 0
  //       ? 'Start with a catchy opening such as I’m a friendly person: who has always had a passion for cooking'
  //       : 'ເລີ່ມຈາກຄຳຊັບທີ່ໜ້າປະທັບໃຈ ຕົວຢ່າງເຊັ່ນ: ຂ້ອຍເປັນຄົນເຂົ້າກັບທີມງານໄດ້ງ່າຍ: ມີຄວາມພ້ອມຕໍ່ໜ້າທີ່ວຽກງານສູງ...';
  //   selectLicense = indexL == 0 ? 'Select your license' : 'ເລືອກໃບຂັບຂີ່';

  //   enterdob = indexL == 0 ? 'Enter date of birth' : 'ໃສ່ວັນເດືອນປີເກີດ';
  //   enterGender = indexL == 0 ? 'Enter gender' : 'ໃສ່ເພດ';
  //   enterMarital = indexL == 0 ? 'Enter marital status' : 'ໃສ່ສະຖານະ';
  //   enterDriving = indexL == 0 ? 'Enter driving license' : 'ໃສ່ໃບຂັບຂີ່';
  //   enterProvince = indexL == 0 ? 'Enter province / state' : 'ໃສ່ແຂວງ';
  //   enterDistrict = indexL == 0 ? 'Enter district / city' : 'ໃສ່ເມືອງ';
  //   enterProfesum =
  //       indexL == 0 ? 'Enter professional summary' : 'ໃສ່ທັກສະໂດຍລວມ';
  //   fieldofStudy = indexL == 0 ? 'Field of study' : 'ສາຂາວິຊາຮຽນ';
  //   enterfieldofStudy = indexL == 0 ? 'enter field of study' : 'ສາຂາວິຊາຮຽນ';
  //   language = indexL == 0 ? 'Language' : 'ພາສາ';
  //   enterLanguage = indexL == 0 ? 'Enter language' : 'ໃສ່ພາສາ';
  //   keySkill = indexL == 0 ? 'Key Skill' : 'ທັກສະ';
  //   enterkeySkill = indexL == 0 ? 'Enter key skill' : 'ໃສ່ທັກສະ';
  //   cannotUpload = indexL == 0 ? 'Cannot upload' : 'ບໍ່ສາມາດອັບໂຫຼດ';
  //   ok = indexL == 0 ? 'Okay' : 'ຕົກລົງ';
  //   thisImageSizelarge = indexL == 0
  //       ? 'The image size is too large\nmaximum size 2mb'
  //       : 'ຮູບພາບມີຂະໜາດໃຫຍ່ເກີນໄປ\nຂະໜາດສູງສຸດແມ່ນ 2 ເມັກກະໄບທ໌';
  //   thisFileSizeLarge = indexL == 0
  //       ? 'The file Size is too large\nmaximum is 5 mb'
  //       : 'ໄຟລ໌ມີຂະໜາດໃຫຍ່ເກີນໄປ\nຂະໜາດສູງສຸດແມ່ນ 5 ເມັກກະໄບທ໌';
  //   cancel = indexL == 0 ? 'Cancel' : 'ຍົກເລີກ';
  //   recoveryAlert = indexL == 0 ? 'Recovery Alert' : 'ພົບຂໍ້ມູນທີ່ເຄີຍໃສ່';
  //   youalrealfilled = indexL == 0
  //       ? 'You already filled this form before\n Do you want to continue?'
  //       : 'ທ່ານເຄີຍໃສ່ຂໍ້ມູນໃນຟອມນີ້ແລ້ວ\nທ່ານຕ້ອງການກູ້ຄືນຂໍ້ມູນນັ້ນຫຼຶບໍ່';
  //   continues = indexL == 0 ? 'Continue' : 'ຕົກລົງ';
  //   uploadingInfo =
  //       indexL == 0 ? 'Uploading information' : 'ກຳລັງອັບໂຫຼດຂໍ້ມູນ';
  //   enterProfile = indexL == 0 ? 'Enter profile' : 'ໃສ່ຮູບໂປຣ໌ໍໄຟລ໌';
  //   entervalidEmail = indexL == 0
  //       ? 'Please enter valid email example: 108jobs@job.com'
  //       : 'ກະລຸນາໃສ່ອີເມລທີ່ຖືກຕ້ອງຕົວຢ່າງເຊັນ:108jobs@job.com';
  //   yourpasswordhasChange = indexL == 0
  //       ? 'Your password has changed'
  //       : 'ລະຫັດຜ່ານຂອງທ່ານໄດ້ຖືກປ່ຽນແລ້ວ';
  //   numberMust = indexL == 0
  //       ? 'Number must be 8 numberic'
  //       : 'ເບີໂທຕ້ອງແມ່ນຕົວເລກ 8 ຕົວເລກ';
  //   notmatch =
  //       indexL == 0 ? 'Not match with new password' : 'ບໍ່ກົງກັບລະຫັດຜ່ານໃໝ່';
  //   passwordMust = indexL == 0
  //       ? 'Password must be at least 8 characters'
  //       : 'ລະຫັດຜ່ານຕ້ອງມີ 8 ຕົວຂຶ້ນໄປແລະຄວນເປັນພາສາອັງກິດ';
  //   choosepic = indexL == 0 ? 'Choose picture' : 'ເລືອກຮູບພາບ';
  //   camera = indexL == 0 ? 'Camera' : 'ຈາກກ້ອງ';
  //   gallery = indexL == 0 ? 'Gallery' : 'ຈາກໂທລະສັບ';
  //   alert = indexL == 0 ? 'Alert' : 'ແຈ້ງເຕືອນ';
  //   thisEmailAlready = indexL == 0
  //       ? 'This email already registered'
  //       : 'ອີເມລຂອງທ່ານໄດ້ຖືກລົງທະບຽນກ່ອນໜ້ານີ້ແລ້ວ';
  //   thisNumberAlready = indexL == 0
  //       ? 'This mobile number already registed'
  //       : 'ເບີໂທຂອງທ່ານໄດ້ຖືກລົງທະບຽນກ່ອນໜ້ານີ້ແລ້ວ';
  //   yourfromnotfinish = indexL == 0
  //       ? 'Your form is not finished yet'
  //       : 'ຟອມຂອງທ່ານຍັງບໍ່ສົມບູນ';
  //   saveOrnot = indexL == 0
  //       ? 'Do you want to save new\ninformation or not?'
  //       : 'ທ່ານຕ້ອງການບັນທຶກຂໍ້ມູນທີ່ມີການ\nປ່ຽນແປງນີ້ຫຼຶບໍ່';
  //   infonotsave =
  //       indexL == 0 ? 'Infomation not save yet' : 'ຂໍ້ມູນຍັງບໍ່ທັນບັນທຶກ';
  //   noEXP = indexL == 0 ? 'No working experience' : 'ບໍ່ມີປະສົບການການເຮັດວຽກ';
  //   yes = indexL == 0 ? 'Yes' : 'ຕົກລົງ';
  //   no = indexL == 0 ? 'No' : 'ບໍ່';
  //   loading = indexL == 0 ? 'Loading' : 'ກຳລັງໂຫຼດ';
  //   searchCV = indexL == 0 ? 'Resume Search' : 'ສະແດງຊີວະປະຫວັດ';
  //   makeYourProfileSearch = indexL == 0
  //       ? 'Make your profile searchable to increase your visibility to employers'
  //       : 'ເຮັດໃຫ້ຂໍ້ມູນຂອງທ່ານສາມາດຄົ້ນຫາໄດ້ ເພິ່ມການເຂົ້າເຖິງໃຫ້ແກ່ບໍລິສັດ';
  //   enterYourNumber = indexL == 0
  //       ? 'Enter your number which you forgot password'
  //       : 'ໃສ່ເບີໂທລະສັບທີ່ທ່ານນັ້ນລືມລະຫັດຜ່ານ';
  //   confirmMATION = indexL == 0 ? 'Confirm' : 'ຢືນຢັນ';
  //   verifyphone = indexL == 0 ? 'Verify phone number' : 'ຢັ້ງຢືນເບີໂທລະສັບ';
  //   enterOTPCode =
  //       indexL == 0 ? 'Enter OTP Code sent to' : 'ໃສ່ລະຫັດ OTP ທີ່ສົ່ງເຂົ້າເບີ';
  //   verifying = indexL == 0 ? 'Verifying' : 'ກຳລັງຢັ້ງຢືນ';
  //   cannotverify =
  //       indexL == 0 ? 'Cannot verify number' : 'ບໍ່ສາມາດຢັ້ງຢືນເບີໂທໄດ້';
  //   pleasecheckotp =
  //       indexL == 0 ? 'Please check your OTP' : 'ກະລຸນາກວດສອບລະຫັດ OTP ອີກຄັ້ງ';
  //   hasVerify = indexL == 0
  //       ? 'Your number has verified'
  //       : 'ເບີຂອງທ່ານໄດ້ຖືກຢັ້ງຢືນແລ້ວ';
  //   pleaseEnterOTP = indexL == 0 ? 'Please enter OTP' : 'ກະລຸນາໃສ່ເລກ OTP';
  //   dontReciv =
  //       indexL == 0 ? 'You don\'t reveive the code' : 'ເຈົ້າຍັງບໍ່ໄດ້ຮັບລະຫັດ';
  //   recendCode = indexL == 0 ? 'Recend Code' : 'ສົ່ງລະຫັດຄືນໃໝ່';
  //   wealreadysent = indexL == 0
  //       ? 'We already sent new otp waiting 60 seconds to sent it again'
  //       : 'ພວກເຮົາໄດ້ສົ່ງລະຫັດ OTP ໃໝ່ແລ້ວ ຖ້າ 60 ວິນາທີ ເພື່ອສົ່ງລະຫັດອີກ';
  //   cannotResetThisPass = indexL == 0
  //       ? 'Cannot reset this password'
  //       : 'ບໍ່ສາມາດປ່ຽນລະຫັດຜ່ານນີ້ໄດ້';
  //   newPassmust = indexL == 0
  //       ? 'New password must be at least 8 characters'
  //       : 'ລະຫັດໃໝ່ຈະຕ້ອງເປັນຕົວອັກສອນ 8 ຕົວຂຶ້ນໄປ';
  //   searchCompany = indexL == 0 ? 'Search Company' : 'ຄົ້ນຫາບໍລິສັດ';
  //   industryCAP = indexL == 0 ? 'INDUSTRY' : 'ປະເພດທຸລະກິດ';
  //   sortbyindustry =
  //       indexL == 0 ? 'Sort by Company Industry' : 'ຄົ້ນຫາດ້ວຍປະເພດທຸລະກິດ';
  //   jobfunction = indexL == 0 ? 'Job Function' : 'ປະເພດວຽກ';
  //   locationCAP = indexL == 0 ? 'LOCATION' : 'ສະຖານທີ່';
  //   searchjob = indexL == 0 ? 'Search Job' : 'ຄົ້ນຫາວຽກ';
  //   jobFunctionCAP = indexL == 0 ? 'JOB FUNCTION' : 'ປະເພດວຽກ';
  //   finish = indexL == 0 ? 'finish' : 'ຕົກລົງ';
  //   selectedCAP = indexL == 0 ? 'SELECTED' : 'ເລືອກແລ້ວ';
  //   clear = indexL == 0 ? 'Clear' : 'ລຶບທັງໝົດ';
  // }
}

class TranslateQuery {
  static translateMonthByFullDateString(String date) {
    String numBerMonth = date.substring(3, 5);
    switch (numBerMonth) {
      case '01':
        return date.replaceRange(3, 5, indexL == 0 ? 'Jan' : 'ມັງກອນ');

      case '02':
        return date.replaceRange(3, 5, indexL == 0 ? 'Feb' : 'ກຸມພາ');

      case '03':
        return date.replaceRange(3, 5, indexL == 0 ? 'Mar' : 'ມີນາ.');

      case '04':
        return date.replaceRange(3, 5, indexL == 0 ? 'Apr' : 'ເມສາ');

      case '05':
        return date.replaceRange(3, 5, indexL == 0 ? 'May' : 'ພຶກສະພາ');

      case '06':
        return date.replaceRange(3, 5, indexL == 0 ? 'Jun' : 'ມິຖຸນາ');

      case '07':
        return date.replaceRange(3, 5, indexL == 0 ? 'Jul' : 'ກໍລະກົດ');

      case '08':
        return date.replaceRange(3, 5, indexL == 0 ? 'Aug' : 'ສິງຫາ');

      case '09':
        return date.replaceRange(3, 5, indexL == 0 ? 'Sep' : 'ກັນຍາ');

      case '10':
        return date.replaceRange(3, 5, indexL == 0 ? 'Oct' : 'ຕຸລາ');

      case '11':
        return date.replaceRange(3, 5, indexL == 0 ? 'Nov' : 'ພະຈິກ');

      case '12':
        return date.replaceRange(3, 5, indexL == 0 ? 'Dec' : 'ທັນວາ');
    }
  }

  static translateProvince(String province) {
    switch (province) {
      case 'Vientiane Capital':
        return 'ນະຄອນຫຼວງວຽງຈັນ';

      case 'Phongsaly':
        return 'ຜົ້ງສາລີ';

      case 'Luang Namtha':
        return 'ຫຼວງນ້ຳທາ';

      case 'Oudomxay':
        return 'ອຸດົມໄຊ';

      case 'Luang Prabang':
        return 'ຫຼວງພະບາງ';

      case 'Houaphanh':
        return 'ຫົວພັນ';

      case 'Xaignabouli':
        return 'ໄຊຍະບູລີ';

      case 'Xiangkhouang':
        return 'ຊຽງຂວາງ';

      case 'Vientiane':
        return 'ວຽງຈັນ';

      case 'Bolikhamxai':
        return 'ບໍລິຄຳໄຊ';

      case 'Khammouane':
        return 'ຄຳມ่ວນ';

      case 'Savannakhet':
        return 'ສະຫວັນນະເຂດ';

      case 'Salavan':
        return 'ສາລະວັນ';

      case 'Sekong':
        return 'ເຊກອງ';

      case 'Champasak':
        return 'ຈຳປາສັກ';

      case 'Attapeu':
        return 'ອັດຕະປື';

      case 'Xaisomboun':
        return 'ໄຊສົມບູນ';

      default:
        return province;
    }
  }

  static translateGender(String gender) {
    switch (gender) {
      case 'Vientiane Capital':
        return 'ນະຄອນຫຼວງວຽງຈັນ';

      case 'Phongsaly':
        return 'ຜົ້ງສາລີ';

      case 'Luang Namtha':
        return 'ຫຼວງນ້ຳທາ';

      case 'Oudomxay':
        return 'ອຸດົມໄຊ';

      case 'Luang Prabang':
        return 'ຫຼວງພະບາງ';

      case 'Houaphanh':
        return 'ຫົວພັນ';

      case 'Xaignabouli':
        return 'ໄຊຍະບູລີ';

      case 'Xiangkhouang':
        return 'ຊຽງຂວາງ';

      case 'Vientiane':
        return 'ວຽງຈັນ';

      case 'Bolikhamxai':
        return 'ບໍລິຄຳໄຊ';

      case 'Khammouane':
        return 'ຄຳມ่ວນ';

      case 'Savannakhet':
        return 'ສະຫວັນນະເຂດ';

      case 'Salavan':
        return 'ສາລະວັນ';

      case 'Sekong':
        return 'ເຊກອງ';

      case 'Champasak':
        return 'ຈຳປາສັກ';

      case 'Attapeu':
        return 'ອັດຕະປື';

      case 'Xaisomboun':
        return 'ໄຊສົມບູນ';

      default:
        return gender;
    }
  }

  static translateMaritalStatus(String gender) {
    switch (gender) {
      case 'Vientiane Capital':
        return 'ນະຄອນຫຼວງວຽງຈັນ';

      case 'Phongsaly':
        return 'ຜົ້ງສາລີ';

      case 'Luang Namtha':
        return 'ຫຼວງນ້ຳທາ';

      case 'Oudomxay':
        return 'ອຸດົມໄຊ';

      case 'Luang Prabang':
        return 'ຫຼວງພະບາງ';

      case 'Houaphanh':
        return 'ຫົວພັນ';

      case 'Xaignabouli':
        return 'ໄຊຍະບູລີ';

      case 'Xiangkhouang':
        return 'ຊຽງຂວາງ';

      case 'Vientiane':
        return 'ວຽງຈັນ';

      case 'Bolikhamxai':
        return 'ບໍລິຄຳໄຊ';

      case 'Khammouane':
        return 'ຄຳມ่ວນ';

      case 'Savannakhet':
        return 'ສະຫວັນນະເຂດ';

      case 'Salavan':
        return 'ສາລະວັນ';

      case 'Sekong':
        return 'ເຊກອງ';

      case 'Champasak':
        return 'ຈຳປາສັກ';

      case 'Attapeu':
        return 'ອັດຕະປື';

      case 'Xaisomboun':
        return 'ໄຊສົມບູນ';

      default:
        return gender;
    }
  }
}
