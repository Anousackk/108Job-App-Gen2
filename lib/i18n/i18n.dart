import 'package:get/get.dart';

class LocalString extends Translations {
  final List<Map<String, String>> lang = [
    {"key": "updates", "en": "Updates", "la": "ອັບເດດ"},
    {"key": "edit", "en": "Edit", "la": "ແກ້ໄຂ"},
    {"key": "delete", "en": "Delete", "la": "ລົບ"},
    {"key": "laoLang", "en": "LA", "la": "ລາວ"},
    {"key": "enLang", "en": "EN", "la": "ອັງກິດ"},
    {"key": "home", "en": "Home", "la": "ໜ້າຫຼັກ"},
    {"key": "about 108", "en": "About 108.JOBS", "la": "ກ່ຽວກັບ 108.JOBS"},
    {"key": "about", "en": "About", "la": "ກ່ຽວກັບ"},
    {"key": "job search", "en": "Job search", "la": "ຄົ້ນຫາວຽກ"},
    {"key": "company search", "en": "Company search", "la": "ຄົ້ນຫາບໍລິສັດ"},
    {"key": "article", "en": "Articles", "la": "ບົດຄວາມ"},
    {"key": "contact us", "en": "Contact us", "la": "ຕິດຕໍ່ພວກເຮົາ"},
    {"key": "package", "en": "Price and Package", "la": "ລາຄາ ແລະ ແພັກເກັດ"},
    {"key": "post job", "en": "Post Job", "la": "ປະກາດວຽກ"},
    {"key": "cv search", "en": "Resume search", "la": "ຄົ້ນຫາ ຊີວະປະຫວັດ"},
    {"key": "login", "en": "Log in", "la": "ເຂົ້າສູ່ລະບົບ"},
    {"key": "logout", "en": "Log out", "la": "ອອກຈາກລະບົບ"},
    {"key": "register", "en": "Register", "la": "ລົງທະບຽນ"},

    {"key": "profile", "en": "Profile", "la": "ໂປຣໄຟສ"},
    {"key": "my job", "en": "My jobs", "la": "ວຽກຂອງຂ້ອຍ"},
    {"key": "notification", "en": "Notification", "la": "ແຈ້ງເຕືອນ"},
    {"key": "account", "en": "Account", "la": "ບັນຊີ"},
    {"key": "my job alert", "en": "My job alert", "la": "ແຈ້ງເຕືອນວຽກ"},
    {"key": "employerLink", "en": "For Employer", "la": "ສຳລັບບໍລິສັດ"},

    {"key": "work province", "en": "Work Province", "la": "ແຂວງເຮັດວຽກ"},
    {
      "key": "company hiring now",
      "en": "Companies actively hiring",
      "la": "ບໍລິສັດທີ່ປະກາດວຽກ"
    },
    {"key": "jobseeker", "en": "JobSeeker", "la": "ຜູ້ຫາງານ"},
    {
      "key": "job by industry",
      "en": "Job by industry",
      "la": "ແບ່ງວຽກຕາມອຸດສາຫະກຳ"
    },
    {"key": "job by province", "en": "Job by province", "la": "ແບ່ງວຽກຕາມແຂວງ"},
    {"key": "recommend job", "en": "Recommended job", "la": "ວຽກທີ່ແນະນຳ"},
    {
      "key": "find dream job",
      "en": "Find your dream job now",
      "la": "ວຽກທີ່ປະກາດຮັບສະໝັກຢູ່"
    },
    {"key": "explore more", "en": "Explore more", "la": "ເບີ່ງວຽກທັງໝົດ"},
    {"key": "jobs", "en": "Jobs", "la": "ຕຳແໜ່ງ"},
    {"key": "employer", "en": "Employer", "la": "ບໍລິສັດ"},
    {
      "key": "update your profile",
      "en": "! Update your profile to submit your CV",
      "la": "! ກະລຸນາອັບເດດຂໍ້ມູນໂປຣໄຟສຂອງທ່ານ"
    },
    {
      "key": "download app",
      "en": "Download the 108job app.",
      "la": "ດາວໂຫລດແອັບ 108job"
    },
    {"key": "download", "en": "Download", "la": "ດາວໂຫລດ"},
    {
      "key": "download description",
      "en":
          "Effortless applications! Create a profile, get instant job alerts, and apply with one click on the 108Jobs app.",
      "la":
          "ໃຊ້ງານງ່າຍ ພຽງແຕ່ສ້າງໂປຣໄຟລ, ຮັບການແຈ້ງເຕືອນ ແລະ ສະໝັກວຽກພຽງແຕ່ຄຣິກດຽວເທິງແອັບ 108Jobs"
    },
    {"key": "follow", "en": "Follow", "la": "ຕິດຕາມ"},
    {"key": "unfollow", "en": "Unfollow", "la": "ຍົກເລີກຕິດຕາມ"},
    {"key": "following", "en": "Following", "la": "ກຳລັງຕິດຕາມ"},
    {"key": "follower", "en": "Followers", "la": "ຄົນຕິດຕາມ"},
    {"key": "followed", "en": "Followed", "la": "ຕິດຕາມແລ້ວ"},
    {"key": "unfollowed", "en": "Unfollowed", "la": "ຍົກເລີກຕິດຕາມແລ້ວ"},
    {"key": "save job", "en": "Save Job", "la": "ບັນທຶກວຽກ"},
    {"key": "unsave job", "en": "Unsave Job", "la": "ຍົກເລີກບັນທຶກວຽກ"},
    {"key": "unsave", "en": "Unsave", "la": "ຍົກເລີກບັນທຶກ"},
    {"key": "saved", "en": "Saved", "la": "ບັນທຶກແລ້ວ"},
    {"key": "save", "en": "Save", "la": "ບັນທຶກ"},
    {"key": "hide job", "en": "Hide Job", "la": "ເຊື່ອງວຽກ"},
    {"key": "unhide job", "en": "Unhide this Job", "la": "ຍົກເລີກເຊື່ອງວຽກ"},
    {"key": "unhide", "en": "Unhide", "la": "ຍົກເລີກເຊື່ອງ"},
    {"key": "hide", "en": "Hide", "la": "ເຊື່ອງ"},
    {"key": "hidded", "en": "Hidded", "la": "ເຊື່ອງແລ້ວ"},
    {"key": "select", "en": "Select ", "la": "ເລືອກ"},
    {"key": "select by", "en": "Select by ", "la": "ເລືອກຕາມ"},
    {"key": "location", "en": "Location", "la": "ສະຖານທີ"},

    {"key": "education level", "en": "Education Level", "la": "ລະດັບການສຶກສາ"},

    {"key": "company", "en": "Company", "la": "ບໍລິສັດ"},
    {"key": "company size", "en": "Company Size", "la": "ຂະໜາດບໍລິສັດ"},
    {"key": "company name", "en": "Company name", "la": "ຊື່ບໍລິສັດ"},
    {"key": "all company", "en": "All Companies", "la": "ບໍລິສັດທັງໝົດ"},
    {
      "key": "clear all filter",
      "en": "Clear all filters",
      "la": "ລ້າງຕົວເລືອກທັງໝົດ"
    },
    {"key": "ok", "en": "OK", "la": "ຕົກລົງ"},
    {"key": "close", "en": "Close", "la": "ປິດ"},
    {"key": "search", "en": "Search ", "la": "ຄົ້ນຫາ"},
    {"key": "all article", "en": "All article", "la": "ບົດຄວາມທັງໝົດ"},
    {"key": "all categories", "en": "All categories", "la": "ໝວດໝູ່ທັງໝົດ"},
    {"key": "job available", "en": "Job Available", "la": "ວຽກທີ່ເປີດຮັບສະໝັກ"},
    {
      "key": "all job available",
      "en": "Job Available Total",
      "la": "ວຽກທີ່ເປີດຮັບສະໝັກທັງໝົດ"
    },

    {"key": "filter", "en": "Filters", "la": "ຕົວກອງ"},
    {"key": "all locaotion", "en": "All location", "la": "ສະຖານທີທັງໝົດ"},
    {
      "key": "all company size",
      "en": "All company size",
      "la": "ຂະໜາດບໍລິສັດທັງໝົດ"
    },
    {"key": "company type", "en": "Company type", "la": "ປະເພດບໍລິສັດ"},
    {"key": "hiring now", "en": "Hiring now", "la": "ປະກາດວຽກຕອນນີ້"},
    {"key": "clear all", "en": "Clear all", "la": "ລ້າງທັງໝົດ"},
    {"key": "view more", "en": "View more", "la": "ເບິ່ງເພີ່ມຕື່ມ"},
    {"key": "photo", "en": "Photos", "la": "ຮູບພາບ"},
    {"key": "photo gallery", "en": "Photo gallery", "la": "ຄັງຮູບພາບ"},
    {"key": "people", "en": "People", "la": "ບຸກຄະລາກອນ"},
    {"key": "address", "en": "Address", "la": "ທີ່ຢູ່"},
    {"key": "about company", "en": "About Company", "la": "ກ່ຽວກັບບໍລິສັດ"},

    {"key": "video", "en": "Video", "la": "ວິດີໂອ"},
    {"key": "job_opening", "en": "Job opening", "la": "ວຽກທີ່ເປີດຮັບສະໝັກ"},
    {"key": "opening date", "en": "Opening Date", "la": "ມື້ເປີດຮັບສະໝັກ"},
    {"key": "closing date", "en": "Closing Date", "la": "ມື້ປິດຮັບສະໝັກ"},
    {"key": "contact", "en": "Contact", "la": "ຕິດຕໍ່"},
    {"key": "submit cv", "en": "Express interest", "la": "ສົນໃຈສະໝັກວຽກ"},
    {
      "key": "already submit",
      "en": "Already Submit CV",
      "la": "ທ່ານໄດ້ສົ່ງ CV ແລ້ວ"
    },
    {"key": "cancel", "en": "Cancel", "la": "ຍົກເລີກ"},
    {"key": "submitted cv", "en": "Submitted CV", "la": "ສົ່ງ CV ແລ້ວ"},
    {
      "key": "you done submit cv",
      "en": "You are finished Submit CV",
      "la": "ທ່ານສົ່ງ CV ສຳເລັດແລ້ວ"
    },
    {
      "key": "product and service",
      "en": "Product and Service",
      "la": "ຜະລິດຕະພັນ ແລະ ການບໍລິການ"
    },
    {
      "key": "submit cv meaning",
      "en":
          "Clicking the \"Express Interest\" button will make your profile visible to hiring managers' emails. This increases your chances of being contacted directly by a potential employer",
      "la":
          "ການກົດປຸ່ມ ສະແດງຄວາມສົນໃຈສະໝັກວຽກກັບບໍລິສັດ ປະຫວັດໂດຍຫຍໍ້ຂອງທ່ານຈະຖືກສົ່ງຫາຝ່າຍບຸກຄະລາກອນຂອງບໍລິສັດດັງກ່າວແລະ ທ່ານອາດຈະໄດ້ຮັບການຕິດຕໍ່ກັບຈາກບໍລິສັດ."
    },
    {
      "key": "tips&tutorial",
      "en": "Tips & Tutorial",
      "la": "ຄຳແນະນຳ ແລະ ວິທີການ"
    },
    {
      "key": "have not login",
      "en": "You haven't login yet",
      "la": "ທ່ານຍັງບໍ່ໄດ້ເຂົ້າສູ່ລະບົບ"
    },
    {"key": "phone", "en": "Phone Number", "la": "ເບີໂທລະສັບ"},
    {"key": "email", "en": "Email", "la": "ອີເມວ"},
    {"key": "password", "en": "Password", "la": "ລະຫັດຜ່ານ"},
    {"key": "change password", "en": "Change Password", "la": "ປ່ຽນລະຫັດຜ່ານ"},
    {
      "key": "current password",
      "en": "Current Password",
      "la": "ລະຫັດຜ່ານປະຈຸບັນ"
    },
    {
      "key": "confirm password",
      "en": "Confirm Password",
      "la": "ຢືນຢັນລະຫັດຜ່ານ"
    },
    {"key": "forgot pass", "en": "Forgot password", "la": "ລືມລະຫັດຜ່ານ"},
    {"key": "login with", "en": "Login with ", "la": "ເຂົ້າສູ່ລະບົບດ້ວຍ"},
    {"key": "register with", "en": "Register ", "la": "ລົງທະບຽນດ້ວຍ"},
    {"key": "don't have ac", "en": "Don't have an account", "la": "ບໍ່ມີບັນຊີ"},
    {"key": "fullname", "en": "Fulll Name", "la": "ຊື່ເຕັມ"},
    {"key": "first name", "en": "First name", "la": "ຊື່"},
    {"key": "last name", "en": "Last name", "la": "ນາມສະກຸນ"},
    {"key": "enter your", "en": "Enter your ", "la": "ປ້ອນຂໍ້ມູນ"},
    {
      "key": "already have ac",
      "en": "Already have an account",
      "la": "ມີບັນຊີແລ້ວ"
    },
    {"key": "enter", "en": "Enter ", "la": "ປ້ອນ"},
    {"key": "or", "en": "or ", "la": "ຫຼື "},
    {"key": "create", "en": "Create", "la": "ສ້າງ"},
    {"key": "related job", "en": "Related Jobs", "la": "ວຽກທີ່ກ່ຽວຂ້ອງ"},
    {"key": "apply", "en": "Apply this job", "la": "ສະໝັກຕຳແໜ່ງນີ້"},
    {"key": "applied", "en": "Applied ", "la": "ສະໝັກແລ້ວ"},
    {
      "key": "preferred language",
      "en": "Preferred Language",
      "la": "ພາສາທີ່ຕ້ອງການ"
    },

    {"key": "experience", "en": "Experience", "la": "ປະສົບການ"},
    {"key": "reset pass", "en": "Reset Password", "la": "ກູ້ຄືນລະຫັດຜ່ານ"},
    {"key": "set pass", "en": "Set Password", "la": "ຕັ້ງລະຫັດຜ່ານ"},
    {"key": "new pass", "en": "New Password", "la": "ລະຫັດຜ່ານໃຫ່ມ"},
    {"key": "confirm", "en": "Confirm", "la": "ຢືນຢັນ"},
    {"key": "verify code", "en": "Verification Code", "la": "ລະຫັດຢືນຢັນ"},
    {"key": "otp code", "en": "OTP Code", "la": "ລະຫັດ OTP"},
    {
      "key": "phoneVerification",
      "en": "Phone Number Verification",
      "la": "ຢືນຢັນເບີໂທລະສັບ"
    },
    {
      "key": "emailVerification",
      "en": "Email Verification",
      "la": "ຢືນຢັນອີເມວ"
    },
    {
      "key": "send otp description",
      "en": "We sent a verification code to your registered address.",
      "la": "ພວກເຮົາໄດ້ສົ່ງລະຫັດຢືນຢັນໄປຫາບັນຊີທີ່ທ່ານລົງທະບຽນ"
    },
    {"key": "job description", "en": "Job Description", "la": "ລາຍລະອຽດວຽກ"},
    {
      "key": "don't receive code",
      "en": "Didn't receive code",
      "la": "ຍັງບໍ່ໄດ້ຮັບລະຫັດຢືນຢັນ"
    },
    {
      "key": "don't receive otp",
      "en": "Didn't receive OTP",
      "la": "ຍັງບໍ່ໄດ້ຮັບລະຫັດ OTP"
    },
    {"key": "resend", "en": "Resend New", "la": "ສົ່ງອີກຄັ້ງ"},
    {"key": "verify", "en": "Verify", "la": "ຢືນຢັນ"},
    {
      "key": "insert info",
      "en": "Please insert your information",
      "la": "ກະລຸນາປ້ອນຂໍ້ມູນ"
    },
    {
      "key": "reset via description",
      "en": "Select which is you need to reset via ?",
      "la": "ຕ້ອງການກູ້ຄືນລະຫັດຜ່ານຊ່ອງທາງໃດ"
    },
    {"key": "reset via", "en": "Reset via ", "la": "ກູ້ຄືນດ້ວຍ"},
    {"key": "next", "en": "Next", "la": "ຕໍ່ໄປ"},
    {
      "key": "link sent to mail",
      "en": "Link reset will be sent to your email address registered",
      "la": "ລະຫັດຢືນຢັນຈະສົ່ງໄປຫາອີເມວຂອງທ່ານ"
    },
    {
      "key": "link sent to phone",
      "en": "Link reset will be sent to your phone number registered",
      "la": "ລະຫັດຢືນຢັນຈະສົ່ງໄປຫາເບີໂທລະສັບຂອງທ່ານ"
    },
    {
      "key": "continue find job",
      "en": "Continue find job",
      "la": "ສືບຕໍ່ຄົ້ນຫາວຽກ"
    },
    {"key": "expired on", "en": "Expired on", "la": "ໝົດກຳນົດພາຍໃນ"},
    {"key": "share on", "en": "Share on", "la": "ແບ່ງປັນ"},
    {"key": "total view", "en": "Total views", "la": "ຍອດເຂົ້າຊົມ"},
    {"key": "job summary", "en": "Job summary", "la": "ລາຍລະອຽດວຽກໂດຍຫຍໍ້"},
    {"key": "minute", "en": "minute", "la": "ນາທີ"},
    {"key": "minute ago", "en": "minute ago", "la": "ນາທີຜ່ານມາ"},
    {"key": "minutes ago", "en": "minutes ago", "la": "ນາທີຜ່ານມາ"},
    {"key": "hour", "en": "hour(s)", "la": "ຊົ່ວໂມງ"},
    {"key": "hour ago", "en": "hour ago", "la": "ຊົ່ວໂມງຜ່ານມາ"},
    {"key": "hours ago", "en": "hours ago", "la": "ຊົ່ວໂມງຜ່ານມາ"},
    {"key": "day", "en": "day", "la": "ມື້"},
    {"key": "days", "en": "day(s)", "la": "ມື້"},
    {"key": "day ago", "en": "day ago", "la": "ມື້ຜ່ານມາ"},
    {"key": "days ago", "en": "days ago", "la": "ມື້ຜ່ານມາ"},
    {"key": "week", "en": "week", "la": "ອາທິດ"},
    {"key": "week ago", "en": "week ago", "la": "ອາທິດຜ່ານມາ"},
    {"key": "weeks ago", "en": "weeks ago", "la": "ອາທິດຜ່ານມາ"},
    {"key": "month", "en": "month", "la": "ເດືອນ"},
    {"key": "months", "en": "months", "la": "ເດືອນຜ່ານມາ"},
    {"key": "year", "en": "Year", "la": "ປີ"},
    {"key": "ago", "en": "ago", "la": "ຜ່ານມາ"},
    {"key": "view", "en": "View", "la": "ເບີ່ງ"},
    {"key": "finish", "en": "FInished", "la": "ສຳເລັດແລ້ວ"},
    {
      "key": "you are finish reset",
      "en": "You are finished reset password",
      "la": "ທ່ານປ່ຽນລະຫັດຜ່ານສຳເລັດແລ້ວ"
    },
    {"key": "accessibility", "en": "Accessibility", "la": "ການເຂົ້າເຖິງ"},
    {
      "key": "for disabled people",
      "en": "this job is open for disabled people",
      "la": "ຕຳແໜ່ງນີ້ຄົນພິການສາມາດສະໝັກໄດ້"
    },
    {
      "key": "you are apply",
      "en": "You're going to apply for a job",
      "la": "ທ່ານກຳລັງສະໝັກວຽກ"
    },
    {"key": "preview cv", "en": "Preview CV", "la": "ເບີ່ງຕົວຢ່າງ CV"},

    {
      "key": "cover letter is require",
      "en": "Cover letter is require",
      "la": "ຕ້ອງການ Cover Letter"
    },
    {
      "key": "plz upload cvL",
      "en": "Please upload Cover Letter",
      "la": "ກະລຸນາອັບໂຫລດ Cover Letter"
    },
    {
      "key": "plz select",
      "en": "Please select file to upload",
      "la": "ກະລຸນາເລືອກໄຟລ໌ເພື່ອອັບໂຫລດ"
    },
    {
      "key": "yes apply",
      "en": "Yes, Apply",
      "la": "ຕົກລົງ, ສະໝັກເລີຍ",
    },

    {"key": "upload cv", "en": "Upload CV", "la": "ອັບໂຫລດ CV"},
    {"key": "upload new CV", "en": "Upload a new CV", "la": "ອັບໂຫລດ CV ໃໝ່"},
    {"key": "uploaded", "en": "Uploaded", "la": "ອັບໂຫລດແລ້ວ"},
    {"key": "uploading", "en": "Uploading", "la": "ກຳລັງອັບໂຫລດ"},

    {
      "key": "or copy link",
      "en": "Or copy link",
      "la": "ຫຼື ກ໋ອບປີ້ Link ໜ້ານີ້"
    },
    {
      "key": "Share this page",
      "en": "Share this page",
      "la": "ແບ່ງປັນໜ້ານີ້",
    },
    {
      "key": "share via",
      "en": "Share via",
      "la": "ແບ່ງປັນດ້ວຍ",
    },
    {
      "key": "security verification",
      "en": "Security Verification",
      "la": "ຢືນຢັນຄວາມປອດໄພ",
    },
    {
      "key": "account protection",
      "en": "Account Protection",
      "la": "ປ້ອງກັນບັນຊີ",
    },
    {
      "key": "textSecurityVerify",
      "en":
          "To protect you account security,\n we need to verify your identity\n Please choose a way to verify",
      "la":
          "ເພື່ອປ້ອງກັນບັນຊີຂອງທ່ານ,\n ພວກເຮົາຈຳເປັນຕ້ອງຢືນຢັນຕົວຕົນຂອງທ່ານກ່ອນ\n ກະລຸນາເລືອກວິທີການກວດສອບ",
    },
    {
      "key": "incorrect",
      "en": "Incorrect",
      "la": "ບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "waiting",
      "en": "Please wait...",
      "la": "ກະລຸນາລໍຖ້າ...",
    },
    {
      "key": "warning",
      "en": "Warning",
      "la": "ແຈ້ງເຕືອນ",
    },
    {
      "key": "successful",
      "en": "Successful",
      "la": "ສຳເລັດ",
    },
    {
      "key": "add",
      "en": "Add",
      "la": "ເພີ່ມ",
    },
    {
      "key": "enter8number",
      "en": "Enter 8 number digits",
      "la": "ປ້ອນ 8 ຕົວເລກ",
    },
    {
      "key": "required",
      "en": "required",
      "la": "ຕ້ອງມີ",
    },
    {
      "key": "excludePhone",
      "en": "Phone number exclude 020",
      "la": "ເບີໂທລະສັບບໍ່ຕ້ອງໃສ່ 020",
    },
    {
      "key": "textAddEmail",
      "en": "Registering email lets you:",
      "la": "ລົງທະບຽນແລ້ວທ່ານຈະໄດ້:",
    },
    {
      "key": "firstTextAddEmail",
      "en": "Login to 108Jobs Application",
      "la": "ເຂົ້າສູ່ລະບົບແອັບ 108Jobs ໄດ້",
    },
    {
      "key": "secondTextAddEmail",
      "en": "Let employer contact you using this email",
      "la": "ບໍລິສັດຈະຕິດຕໍ່ຫາທ່ານດ້ວຍອີເມວນີ້",
    },
    {
      "key": "code sent to",
      "en": "Verification Code sent to",
      "la": "ລະຫັດຢືນຢັນຈະສົ່ງໄປຫາ",
    },
    {
      "key": "otp sent to",
      "en": "The OTP Code sent to",
      "la": "ລະຫັດ OTP ຈະສົ່ງໄປຫາ",
    },
    {
      "key": "verify your phone",
      "en": "Verify your Phone Number",
      "la": "ຢືນຢັນເບີໂທລະສັບຂອງທ່ານ",
    },
    {
      "key": "verify your email",
      "en": "Verify your Email Address",
      "la": "ຢືນຢັນອີເມວຂອງທ່ານ",
    },
    {
      "key": "enter8password",
      "en": "Password should be atleast 8 characters",
      "la": "ລະຫັດຕ້ອງບໍ່ນ້ອຍກວ່າ 8 ຕົວ",
    },
    {
      "key": "seemore",
      "en": "See more",
      "la": "ເບິ່ງເພີ່ມ",
    },
    {
      "key": "no have data",
      "en": "No have data",
      "la": "ບໍ່ມີຂໍ້ມູນ",
    },
    {
      "key": "clear all",
      "en": "Clear All",
      "la": "ລ້າງຂໍ້ມູນ",
    },
    {
      "key": "sort by",
      "en": "Sort By",
      "la": "ຈັດລຽງຕາມ",
    },
    {
      "key": "post date latest",
      "en": "Post Date (Latest)",
      "la": "ມື້ປະກາດວຽກ(ຫຼ້າສຸດ)",
    },
    {
      "key": "post date oldest",
      "en": "Post Date (Oldest)",
      "la": "ມື້ປະກາດວຽກ(ເກົ່າສຸດ)",
    },
    {
      "key": "show more",
      "en": "Show More",
      "la": "ສະແດງເພີ່ມ",
    },
    {
      "key": "do u want",
      "en": "Do you want to",
      "la": "ທ່ານຕ້ອງການ",
    },
    {
      "key": "job experience",
      "en": "Job Experience",
      "la": "ປະສົບການເຮັດວຽກ",
    },
    {
      "key": "have applied",
      "en": "you have applied",
      "la": "ທີ່ທ່ານສະໝັກໄວ້",
    },
    {
      "key": "have saved",
      "en": "you have saved",
      "la": "ທີ່ທ່ານບັນທຶກໄວ້",
    },
    {
      "key": "have alert",
      "en": "you have alert",
      "la": "ທີ່ແຈ້ງເຕືອນ",
    },
    {
      "key": "job",
      "en": "Job",
      "la": "ວຽກ",
    },
    {
      "key": "you have hidded",
      "en": "you have hidded",
      "la": "ທີ່ທ່ານເຊື່ອງ",
    },
    {
      "key": "just now",
      "en": "Just now",
      "la": "ດຽວນີ້",
    },

    {
      "key": "general info",
      "en": "General Information",
      "la": "ຂໍ້ມູນທົ່ວໄປ",
    },
    {
      "key": "connect platforms",
      "en": "Connect other Platforms",
      "la": "ເຊື່ອມຕໍ່ແພັດຟອມຕ່າງໆ",
    },
    {
      "key": "link",
      "en": "Link",
      "la": "ເຊື່ອມຕໍ່",
    },
    {
      "key": "are u sure logout",
      "en": "Are you sure to log out?",
      "la": "ທ່ານແນ່ໃຈບໍ່ທີ່ຈະອອກຈາກລະບົບ?",
    },
    {
      "key": "your profile is review",
      "en": "Your profile is being review",
      "la": "ໂປຣໄຟສຂອງທ່ານກຳລັງຖືກກວດສອບ",
    },
    {
      "key": "it takeup to process",
      "en": "it may take upto 48 Hrs in this process",
      "la": "ອາດຈະໃຊ້ເວລາຮອດ 48ຊົ່ວໂມງ ໃນການກວດສອບ",
    },
    {
      "key": "complete section your profile",
      "en": "Complete the sections below to take your profile",
      "la": "ຕື່ມຂໍ້ມູນຂ້າງລຸ່ມນີ້ເພື່ອໃຫ້ໂປຣໄຟສຂອງທ່ານ",
    },
    {
      "key": "to the next level",
      "en": "to the next level",
      "la": "ໄປອີກລະດັບ",
    },

    {
      "key": "let us know",
      "en": "Let us know more about you",
      "la": "ບອກໃຫ້ພວກເຮົາຮູ້ກ່ຽວກັບທ່ານ",
    },
    {
      "key": "birth",
      "en": "Birth",
      "la": "ວັນເກີດ",
    },
    {
      "key": "gender",
      "en": "Gender",
      "la": "ເພດ",
    },
    {
      "key": "marital status",
      "en": "Marital Status",
      "la": "ສະຖານະການແຕ່ງງານ",
    },

    //
    //
    //
    //
    //
    //Seeker Profile
    {
      "key": "personal_info",
      "en": "Personal Information",
      "la": "ຂໍ້ມູນສ່ວນໂຕ",
    },
    {
      "key": "work_preference",
      "en": "Work Preferences",
      "la": "ປະເພດວຽກທີ່ສົນໃຈ",
    },
    {
      "key": "cv_file",
      "en": "CV File",
      "la": "ຊີວະປະຫວັດ",
    },
    {
      "key": "work_history",
      "en": "Work History",
      "la": "ປະຫວັດການເຮັດວຽກ",
    },
    {
      "key": "education",
      "en": "Education",
      "la": "ການສຶກສາ",
    },
    {
      "key": "skills",
      "en": "Skills",
      "la": "ທັກສະຕ່າງໆ",
    },
    {
      "key": "language_skill",
      "en": "Language Skills",
      "la": "ທັກສະດ້ານພາສາ",
    },
    {
      "key": "curret_member_level",
      "en": "Current",
      "la": "ລະດັບປະຈຸບັນ",
    },
    {
      "key": "profile_inreview",
      "en": "Inreview",
      "la": "ກຳລັງກວດສອບ",
    },
    {
      "key": "avatar_image",
      "en": "Avatar Image",
      "la": "ຮູບອາວາຕາ",
    },
    {
      "key": "select_avatar_intro_text",
      "en": "Select an avatar image that reflects your job personality.",
      "la": "ກະລຸນາເລືອກຮູບທີ່ບົ່ງທີ່ໃກ້ຄຽງກັບບຸກຄະລິກຂອງທ່ານ.",
    },
    {
      "key": "upgrade_member_level_intro",
      "en":
          "To upgrade your membership, you'll need to provide the required information for each level.",
      "la": "ກະລຸນາຕື່ມຂໍ້ມູນດ້ານລຸ່ມ ເພື່ອອັບເກດລະດັບສະມາຊິກ.",
    },

    //
    //
    //
    //
    //
    //Seeker Profile - Profile setting
    {
      "key": "profile_setting",
      "en": "Profile Setting",
      "la": "ຕັ້ງຄ່າໂປຣໄຟສ",
    },
    {
      "key": "profile_status",
      "en": "Profile Status",
      "la": "ສະຖານະໂປຣໄຟສ",
    },
    {
      "key": "profile_searchable",
      "en": "Profile Searchable",
      "la": "ຄົ້ນຫາໂປຣໄຟສໄດ້",
    },

    {
      "key": "hide_from_companies",
      "en": "Hide from companies below",
      "la": "ເຊື່ອງຈາກບໍລິສັດທາງລຸ່ມນີ້",
    },
    {
      "key": "add_company",
      "en": "Add Company",
      "la": "ເພີ່ມບໍລິສັດ",
    },

    //
    //
    //
    //
    //
    //Seeker Profile - Upload CV
    {
      "key": "select_cv_file",
      "en": "Select CV file to upload",
      "la": "ເລືອກໄຟສ ຊີວີ ເພື່ອອັບໂຫລດ"
    },
    {
      "key": "cv_file_support",
      "en": "Supported file format PDF, Docx, Doc that has less than 5MB size.",
      "la": "ຮອງຮັບໄຟສ PDF, Docx, Doc ຂະໜາດໄຟສ ສູງສຸດ 5MB",
    },
    {
      "key": "uploaded_file",
      "en": "Uploaded File",
      "la": "ໄຟສທີ່ອັບເໂຫລດແລ້ວ",
    },
    {
      "key": "download_file_cv",
      "en": "Lownload File CV",
      "la": "ດາວໂຫລດໄຟສຊີວີ້",
    },
    {
      "key": "cv_tip_1",
      "en":
          "1. Please upload only your CV and avoid including other documents like certificates or transcripts.",
      "la":
          "1. ບໍ່ຄວນອັບໂຫລດເອກະສານເຊັ່ນ: ໃບຢັ້ງຢືນທີ່ຢູ່, ສຳມະໂນຄົວ ຫຼື ໃບປະກາດ, ອັບໂຫລດສະເພາະໄຟສ CV.",
    },
    {
      "key": "cv_tip_2",
      "en": "2. Uploading your CV as a PDF file is recommended.",
      "la": "2. ແນະນຳໃຫ້ອັບໂຫລດໄຟສ PDF ຈະເປັນການດີທີ່ສຸດ.",
    },
    {
      "key": "cv_file_permission_guide",
      "en":
          "It looks like you denied access to files. To use this feature, please enable access manually in your phone's settings.",
      "la":
          "ເພື່ອອັບໂຫລດຊີວີ ກະລຸນາອະເປີດອະນຸຍາດໃຫ້ແອັບພິເຄຊັ້ນສາມາດເຂົ້າເຖິງໄຟສ ໂດຍການເຂົ້າໄປຕັ້ງຄ່າຂອງແອັບ",
    },
    {
      "key": "cv_file_permission_audio",
      "en":
          "It looks like you denied access to files(Music and audio) To use this feature, please enable access manually in your phone's settings.",
      "la":
          "ເພື່ອອັບໂຫລດຊີວີ ກະລຸນາອະເປີດອະນຸຍາດໃຫ້ແອັບພິເຄຊັ້ນສາມາດເຂົ້າເຖິງໄຟສ(ເພງ ຫຼື ສຽງ) ໂດຍການເຂົ້າໄປຕັ້ງຄ່າຂອງແອັບ",
    },
    {
      "key": "i_have_cv",
      "en": "I Have CV",
      "la": "ຂ້ອຍມີຊີວີ້",
    },
    {
      "key": "vipo_gen_cv",
      "en": "VIPO Generate CV",
      "la": "ໃຫ້ VIPO ສ້າງຊີວີ້ໃຫ້",
    },

    //
    //
    //

    {
      "key": "details employment history",
      "en": "Input details of your employment history",
      "la": "ໃສ່ປະຫວັດການເຮັດວຽກຂອງທ່ານ",
    },
    {
      "key": "details education",
      "en": "Input details of your education",
      "la": "ໃສ່ປະຫວັດການສຶກສາຂອງທ່ານ",
    },
    {
      "key": "add all languages",
      "en":
          "Add all the languages you can speak to increase your job prospects",
      "la": "ເພີ່ມພາສາທັງໝົດທີ່ທ່ານສາມາດເວົ້າໄດ້ ເພື່ອເພີ່ມໂອກາດໃນການຊອກວຽກ",
    },

    {
      "key": "you should list skills",
      "en":
          "In this section, you should list skills that are relevant to the position or career area you are interested in",
      "la":
          "ໃນສ່ວນນີ້ ທ່ານສາມາດລະບຸທັກສະທີ່ກ່ຽວຂ້ອງກັບຕຳແໜ່ງ ຫຼື ອາຊີບທີ່ທ່ານສົນໃຈໄດ້",
    },
    {
      "key": "date of birth",
      "en": "Date of birth",
      "la": "ວັນ-ເດືອນ-ປີ ເກີດ",
    },
    {
      "key": "nationality",
      "en": "Nationality",
      "la": "ສັນຊາດ",
    },
    {
      "key": "country",
      "en": "Country",
      "la": "ປະເທດ",
    },
    {
      "key": "district",
      "en": "District",
      "la": "ເມືອງ",
    },
    {
      "key": "usd",
      "en": "USD",
      "la": "ໂດລາ",
    },
    {
      "key": "kip",
      "en": "KIP",
      "la": "ກີບ",
    },
    {
      "key": "tell about you",
      "en": "Tell us more about you",
      "la": "ບອກໃຫ້ເຮົາຮູ້ຕື່ມກ່ຽວກັບທ່ານ",
    },
    {
      "key": "tips",
      "en": "Tips",
      "la": "ເຄັດລັບ",
    },
    {
      "key": "upload_only_cv",
      "en": "Upload only CV file(exclude other document)",
      "la": "ອັບໂຫລດສະເພາະໄຟລ໌ CV(ຍົກເວັ້ນເອກະສານອື່ນໆ)",
    },
    {
      "key": "pdf_file_recommend",
      "en": "PDF file format is recommended",
      "la": "ແນະນຳໃຫ້ໃຊ້ຮູບແບບໄຟລ໌ PDF",
    },
    {
      "key": "question you my ask",
      "en": "Question you my ask",
      "la": "ຄຳຖາມຍອດຮິດ",
    },

    {
      "key": "from",
      "en": "From",
      "la": "ຈາກ",
    },
    {
      "key": "to",
      "en": "To",
      "la": "ຫາ",
    },
    {
      "key": "responsibility",
      "en": "Responsibility",
      "la": "ໜ້າທີ່ຮັບຜິດຊອບ",
    },

    //
    //
    //
    //
    //
    //Seeker Profile - Information
    {
      "key": "profile_image",
      "en": "Profile Image",
      "la": "ຮູບໂປຣໄຟສ",
    },

    //
    //
    //
    //
    //
    //Seeker Profile - Work Preference
    {"key": "position", "en": "Position", "la": "ຕຳແໜ່ງ"},
    {"key": "salary", "en": "Salary", "la": "ເງິນເດືອນ"},
    {"key": "job level", "en": "Job Level", "la": "ລະດັບການເຮັດວຽກ"},
    {"key": "job function", "en": "Job function", "la": "ປະເພດວຽກ"},
    {"key": "province", "en": "Province", "la": "ແຂວງ"},
    {"key": "industry", "en": "Industry", "la": "ອຸດສາຫະກຳ"},
    {"key": "benefit", "en": "Beneftis", "la": "ສະຫວັດດີການ"},
    {"key": "done", "en": "Done", "la": "ສຳເລັດ"},

    //
    //
    //
    //
    //
    //Seeker Profile - Work History
    {
      "key": "work_employer",
      "en": "Company",
      "la": "ບໍລິສັດ",
    },
    {
      "key": "work_position",
      "en": "Job Title",
      "la": "ຕຳແໜ່ງງານ",
    },
    {
      "key": "work_start_date",
      "en": "From Date",
      "la": "ຈາກວັນທີ",
    },
    {
      "key": "work_end_date",
      "en": "To Date",
      "la": "ເຖິງວັນທີ",
    },
    {
      "key": "work_current",
      "en": "I Presently work here",
      "la": "ບ່ອນເຮັດວຽກປະຈຸບັນ",
    },
    {
      "key": "work_responsibility",
      "en": "Responsibility",
      "la": "ໜ້າທີ່ຮັບຜິດຊອບ",
    },
    {
      "key": "work_responsibility_detail",
      "en": "Responsibility detail",
      "la": "ລາຍລະອຽດໜ້າທີ່ຮັບຜິດຊອບ",
    },

    {
      "key": "button_no_experience",
      "en": "Have no experience",
      "la": "ຍັງບໍ່ມີປະສົບການເຮັດວຽກ",
    },
    {
      "key": "button_have_experience",
      "en": "Have any experience",
      "la": "ມີປະສົບການເຮັດວຽກ",
    },

    //
    //
    //
    //
    //
    //Seeker Profile - Education
    {
      "key": "education_major",
      "en": "Major / Course name",
      "la": "ສາຂາຮຽນ",
    },
    {
      "key": "education_school",
      "en": "Institution",
      "la": "ຊື່ສະຖາບັນ",
    },
    {
      "key": "education_qualifications",
      "en": "Qualifications / Achievements",
      "la": "ວຸດທິການສຶກສາ / ຄວາມສຳເລັດ",
    },
    {
      "key": "education_from_date",
      "en": "From year",
      "la": "ຈາກປີ",
    },
    {
      "key": "education_to_date",
      "en": "To Year",
      "la": "ເຖິງປີ",
    },
    {
      "key": "study_current",
      "en": "I Presently study here",
      "la": "ບ່ອນຮຽນປະຈຸບັນ",
    },

    //
    //
    //
    //
    //
    //Seeker Account
    {
      "key": "profile_image_support",
      "en": "Supported file format PNG, JPG, JPEG",
      "la": "ຮອງຮັບໄຟສ PNG, JPG, JPEG",
    },
    {
      "key": "profile_image_size",
      "en": "File size must not exceed 10MB",
      "la": "ຂະໜາດໄຟສຕ້ອງບໍ່ເກີນ 10MB",
    },
    {
      "key": "status",
      "en": "Status",
      "la": "ລະດັບສະມາຊິກ",
    },
    {
      "key": "complete_your_profile",
      "en": "Complete your profile",
      "la": "ຄວາມສົມບູນຂອງໂປຣໄຟສ",
    },
    {
      "key": "completed",
      "en": "Completed",
      "la": "ສຳເລັດແລ້ວ",
    },
    {
      "key": "account setting",
      "en": "Account Setting",
      "la": "ຕັ້ງຄ່າບັນຊີ",
    },
    {
      "key": "activity",
      "en": "Activity",
      "la": "ກິດຈະກຳ",
    },
    {
      "key": "login_info",
      "en": "Login Information",
      "la": "ຂໍ້ມູນການເຂົ້າລະບົບ",
    },
    {
      "key": "my_profile",
      "en": "My profile",
      "la": "ໂປຣໄຟສ",
    },
    {
      "key": "job_alert",
      "en": "Job Alert",
      "la": "Job Alert",
    },
    {
      "key": "member_point",
      "en": "Member Point",
      "la": "ຄະແນນສະສົມ",
    },
    {
      "key": "company_view_profile",
      "en": "Company viewed your profile",
      "la": "ບໍລິສັດເບິ່ງໂປຣໄຟສ",
    },
    {
      "key": "submitted_cv",
      "en": "Submitted CV",
      "la": "ຢື່ນສະໝັກວຽກ",
    },
    {
      "key": "applied_job",
      "en": "Applied Job",
      "la": "ວຽກທີ່ສະໝັກ",
    },
    {
      "key": "saved_job",
      "en": "Saved Job",
      "la": "ວຽກທີ່ບັນທຶກໄວ້",
    },

    {
      "key": "want_access_photos",
      "en":
          "108 Jobs would like to access your photos(Photos and videos) is required to attach photos",
      "la":
          "108 Jobs ຕ້ອງການໄດ້ຮັບອະນຸຍາດເຂົ້າເຖິງຮູບພາບ(ຮູບພາບ ແລະ ວິດີໂອ) ກະລຸນາອະນຸຍາດໃນຕັ້ງຄ່າຂອງແອັບ",
    },
    {
      "key": "want_access_storage",
      "en":
          "108 Jobs would like to access your photos(Storage) is required to attach photos",
      "la":
          "108 Jobs ຕ້ອງການໄດ້ຮັບອະນຸຍາດເຂົ້າເຖິງຮູບພາບ(ພື້ນທີ່ຈັດເກັບ) ກະລຸນາອະນຸຍາດໃນຕັ້ງຄ່າຂອງແອັບ",
    },
    {
      "key": "registered_attend",
      "en": "You have successfully registered to attend the event.",
      "la": "ທ່ານໄດ້ລົງທະບຽນເຂົ້າຮ່ວມງານສຳເລັດ",
    },
    {
      "key": "already_registered_attend",
      "en": "You have already registered to attend the event.",
      "la": "ທ່ານໄດ້ລົງທະບຽນເຂົ້າຮ່ວມງານແລ້ວ",
    },
    {
      "key": "attend_event",
      "en": "Attend the event",
      "la": "ເຂົ້າຮ່ວມງານ",
    },
    {
      "key": "event_details",
      "en": "Event details",
      "la": "ລາຍລະອຽດງານ",
    },
    {
      "key": "image",
      "en": "Image",
      "la": "ຮູບພາບ",
    },
    {
      "key": "file",
      "en": "File",
      "la": "ເອກະສານ",
    },

    //
    //
    //
    //
    //
    //Seeker register event
    {
      "key": "back",
      "en": "Back",
      "la": "ກັບຄືນ",
    },
    {
      "key": "register_event",
      "en": "Register Event",
      "la": "ລົງທະບຽນເຂົ້າຮ່ວມງານ"
    },

    //
    //
    //
    //
    //
    //Seeker scan QR Code
    {
      "key": "scan_qr",
      "en": "Scan QR",
      "la": "ສະແກນ QR",
    },
    {
      "key": "applied_success",
      "en": "Successfully applied for this job",
      "la": "ສະໝັກວຽກສຳເລັດ",
    },
    {
      "key": "already_applied",
      "en": "You have already applied for this job.",
      "la": "ວຽກນີ້ໄດ້ສະໝັກແລ້ວ",
    },
    {
      "key": "incorrect_qr_code",
      "en": "Incorrect QR Code",
      "la": "QR Code ບໍ່ຖືກຕ້ອງ",
    },

    //
    //
    //
    //
    //
    //Seeker Events Tricket
    {
      "key": "event_name",
      "en": "Event",
      "la": "ງານທີ່ຈັດ",
    },
    {
      "key": "event_address",
      "en": "Address",
      "la": "ສະຖານທີ່",
    },
    {
      "key": "event_map",
      "en": "Map",
      "la": "ແຜນທີ່",
    },
    {
      "key": "event_click_map",
      "en": "Click to open the map",
      "la": "ກົດເບິ່ງແຜນທີ່",
    },
    {
      "key": "event_date_time",
      "en": "Date and time",
      "la": "ວັນທີ່ຈັດງານ",
    },
    {
      "key": "event_attendee_code",
      "en": "Attendee Code ",
      "la": "ລະຫັດຜູ້ເຂົ້າຮ່ວມງານ",
    },
    {
      "key": "create_qr_code",
      "en": "Create QR Code",
      "la": "ສ້າງ QR Code",
    },
    {
      "key": "photo_saved",
      "en": "Photo saved to this device",
      "la": "ບັນທຶກຮູບພາບສຳເລັດ",
    },
    {
      "key": "can_not_save_photo",
      "en": "Can't save this photo",
      "la": "ບໍ່ສາມາດບັນທຶກຮູບພາບໄດ້",
    },

    //
    //
    //
    //
    //
    //Seeker JobSearch - Job Card
    {
      "key": "job_card_new_job",
      "en": "New",
      "la": "ວຽກໃຫມ່",
    },

    //
    //
    //
    //
    //
    //Seeker JobSearch Detail
    {
      "key": "view_job_detail",
      "en": "View Job Detail",
      "la": "ເບິ່ງລາຍລະອຽດວຽກ",
    },
    {
      "key": "job_detail",
      "en": "Job Detail",
      "la": "ລາຍລະອຽດວຽກ",
    },
    //More from this company
    {
      "key": "more_from_company",
      "en": "More from this company",
      "la": "ວຽກທັງໝົດຂອງບໍລິສັດນີ້",
    },

    //
    //
    //
    //
    //
    //Home
    {
      "key": "open_whatsapp",
      "en": "Open WhatsApp",
      "la": "ເປີດ WhatsApp",
    },
    {
      "key": "contact_us_whatsapp",
      "en": "Contact us via WhatsApp",
      "la": "ຕິດຕໍ່ພະນັກງານເພື່ອສອບຖາມ ຫຼື ແກ້ໄຂບັນຫາ",
    },

    //
    //
    //
    //
    //
    //Bottom Navigator Bar
    {
      "key": "check_internet_again",
      "en": "Check your internet and try again",
      "la": "ກວດສອບອິນເຕີເນັດຂອງທ່ານແລ້ວລອງໃໝ່ອີກຄັ້ງ",
    },

    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //

    {
      "key": "proficiency",
      "en": "Proficiency",
      "la": "ຄວາມສາມາດ",
    },

    {
      "key": "how to set profile status",
      "en":
          "Get your profile approved or complete: Attached CV, Personal Information and Work Preferences to set the profile status",
      "la":
          "ໃຫ້ໂປຣໄຟສຂອງທ່ານຢືນຢັນຜ່ານແລ້ວ ຫຼື ໃສ່ຂໍ້ມູນໃຫ້ຄົບ: ອັບໂຫລດ CV, ຂໍ້ມູນສ່ວນບຸກຄົນ, ຂໍ້ມູນອ້າງອິງ ເພື່ອທີ່ຈະຕັ້ງຄ່າໂປຣໄຟສ",
    },
    {
      "key": "searchable profile",
      "en": "Searchable Profile",
      "la": "ສາມາດເຫັນໂປຣໄຟສໄດ້",
    },
    {
      "key": "on",
      "en": "ON",
      "la": "ເປີດ",
    },
    {
      "key": "off",
      "en": "OFF",
      "la": "ປິດ",
    },
    {
      "key": "message",
      "en": "Message",
      "la": "ຂໍ້ຄວາມ",
    },
    {
      "key": "date",
      "en": "Date",
      "la": "ວັນທີ",
    },
    {
      "key": "message detail",
      "en": "Message detail",
      "la": "ລາຍລະອຽດ ຂໍ້ຄວາມ",
    },
    {
      "key": "hide profile from companies",
      "en": "Hide your profile from these companies",
      "la": "ເຊື່ອງໂປຣໄຟສຂອງທ່ານຈາກບໍລິສັດເຫຼົ່ານີ້",
    },
    {
      "key": "delete account",
      "en": "Delete account",
      "la": "ລົບບັນຊີ",
    },
    {
      "key": "continue",
      "en": "Continue",
      "la": "ສືບຕໍ່",
    },
    {
      "key": "account_delete_title",
      "en":
          "We regret your decision to leave.  Please be aware that deleting your account will result in:",
      "la": "ພວກເຮົາເສຍໃຈທີ່ທ່ານຈະລົບບັນຊີຂອງທ່ານ, ການລົບບັນຊີຈະມີຜົນດັ່ງນີ້:",
    },
    {
      "key": "account_delete_1",
      "en":
          "Due to recent changes, employers are no longer able to access your applications and profile.",
      "la": "ບັນດາບໍລິສັດ ຈະບໍ່ສາມາດເຫັນໃບສະໝັກທ່ານຜ່ານມາຂອງທ່ານ.",
    },
    {
      "key": "account_delete_2",
      "en":
          "Your 108Jobs profile and curriculum vitaes (CVs) have been entirely deleted.",
      "la": "ໂປຣໄຟສ ແລະ ຊີວີ້ ຂອງທ່ານຈະຖືກລົບອອກຈາກລະບົບ.",
    },
    {
      "key": "account_delete_3",
      "en":
          "We will not be sending you any further emails, including those related to job alerts or recommendations.",
      "la": "ທ່ານຈະບໍ່ໄດ້ຮັບອີ່ເມວແຈ້ງເຕືອນວຽກ ຫຼື ວຽກແນະນຳຈາກພວກເຮົາອີກ.",
    },
    {
      "key": "account_delete_4",
      "en":
          "Your account will be permanently deleted in 7 days. This action is irreversible and includes all data.",
      "la":
          "ຂໍ້ມູນທຸກຢ່າງໃນບັນຊີຂອງທ່ານຈະຖືກລົບອອກຢ່າງຖາວອນຈາກລະບົບພາຍໃນ 7 ວັນ",
    },
    {
      "key": "account_delete_5",
      "en":
          "Accidentally deleted your account? Log back in within 7 days to recover it.",
      "la":
          "ພາຍໃນ 7 ວັນ, ທ່ານຍັງສາມາດກູ້ຄືນບັນຊີຂອງທ່ານດ້ວຍການເຂົ້າສູ່ລະບົບອີກຄັ້ງ. ",
    },
    {
      "key": "are u sure delete account",
      "en": "Are you sure to delete account?",
      "la": "ທ່ານແນ່ໃຈບໍ່ທີ່ຈະລົບບັນຊີອອກຈາກລະບົບ?",
    },
    {
      "key": "disconnect",
      "en": "Disconnect",
      "la": "ຍົກເລີກການເຊື່ອມຕໍ່",
    },
    {
      "key": "are u sure disconnect",
      "en": "Are you sure to delete disconnect?",
      "la": "ທ່ານແນ່ໃຈບໍ່ທີ່ຈະຍົກເລີກການເຊື່ອມຕໍ່?",
    },
    {
      "key": "valid_until",
      "en": "Valid until",
      "la": "ປິດຮັບສະໝັກ",
    },
    {
      "key": "hide_job_post",
      "en": "Hide this Job",
      "la": "ເຊື່ອງປະກາດວຽກ",
    },
    {
      "key": "system_error",
      "en": "Verify system error",
      "la": "ລະບົບຢືນຢັນມີບັນຫາ",
    },
    {
      "key": "phone_register_already",
      "en": "This phone number has register already",
      "la": "ເບີໂທລະສັບ ຫຼື ອີເມວ ໄດ້ລົງທະບຽນແລ້ວ",
    },
    {
      "key": "phone_not_register",
      "en": "This phone number has not register yet",
      "la": "ເບີໂທລະສັບ ຫຼື ອີເມວ ຍັງບໍ່ໄດ້ລົງທະບຽນ",
    },
    {
      "key": "phone_used",
      "en": "This phone number is used",
      "la": "ເບີໂທລະສັບ ຫຼື ອີເມວ ໄດ້ຖືກໃຊ້ແລ້ວ",
    },
    {
      "key": "otp_code_incorrect",
      "en": "OTP code is incorrect",
      "la": "ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "hide_job_explain",
      "en": "Once you hide this job, it will disappear from this page.",
      "la": "ຫຼັງຈາກເຊື່ອງວຽກ ວຽກດັ່ງກ່າວຈະບໍ່ສະແດງຢູ່ໜ້ານີ້ອີກ",
    },
    {
      "key": "unhide_job_explain",
      "en": "Unhiding this job will make it visible again.",
      "la": "ຖ້າກົດຢືນຢັນ ວຽກນີ້ຈະກັບໄປສະແດງຢູ່ໜ້າຄົ້ນຫາວຽກ",
    },
    {
      "key": "apply_job_modal_title",
      "en": "You are about to apply for this job.",
      "la": "ທ່ານກຳລັງຈະສະໝັກວຽກນີ້",
    },
    {
      "key": "delete_this_info",
      "en": "Delete This Information?",
      "la": "ຕ້ອງລົບຂໍ້ມູນນີ້ແທ້ບໍ່?",
    },
    {
      "key": "delete_success",
      "en": "Delete Successful",
      "la": "ລົບຂໍ້ມູນສຳເລັດ",
    },
    {
      "key": "delete_cv_success",
      "en": "Delete CV Successfull",
      "la": "ລົບ CV ສຳເລັດ",
    },
    {
      "key": "add_company_success",
      "en": "Add Company Successful",
      "la": "ເພີ່ມບໍລິສັດສຳເລັດ",
    },
    {
      "key": "change_information_success",
      "en": "Change Information Successful",
      "la": "ປ່ຽນຂໍ້ມູນສຳເລັດ",
    },
    {
      "key": "express_interest_explain",
      "en": "The company will notice your profile and may contact you.",
      "la": "ບໍລິສັດຈະເຫັນໂປຮໄຟສຂອງທ່ານ ແລະ ອາດຈະຕິດຕໍ່ກັບຫາທ່ານ",
    },
    {
      "key": "Current password doesn't match in database",
      "en": "Current password doesn't match.",
      "la": "ລະຫັດປະຈຸບັນບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "Password does not match",
      "en": "Password mismatch.",
      "la": "ລະຫັດບໍ່ກົງກັນ",
    },
    {
      "key": "Password has changed",
      "en": "Password has been changed.",
      "la": "ປ່ຽນລະຫັດແລ້ວ",
    },
    {
      "key": "Invalid code",
      "en": "Invalid code.",
      "la": "ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "Your verify succeed",
      "en": "Verification successful.",
      "la": "ການຢືນຢັນສຳເລັດ",
    },
    {
      "key": "Mobile does not match",
      "en": "Current password doesn't match.",
      "la": "ເບີໂທບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "Mobile does not exist",
      "en": "Mobile number not found.",
      "la": "ບໍ່ພົບເບີໂທນີ້",
    },
    {
      "key": "Email does not exist",
      "en": "Email not found.",
      "la": "ບໍ່ພົບອີເມວນີ້",
    },
    {
      "key": "You are not a Seeker",
      "en": "This account is not registered as a job seeker.",
      "la": "ບັນຊີນີ້ບໍ່ແມ່ນຜູ້ຊອກວຽກ",
    },
    {
      "key": "Incorrect email or mobile",
      "en": "Incorrect email or mobile number.",
      "la": "ອີເມວ ຫຼື ເບີໂທ ບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "Incorrect password",
      "en": "Incorrect password.",
      "la": "ລະຫັດບໍ່ຖືກຕ້ອງ",
    },
    {
      "key": "This email has register already...!",
      "en": "This email is already registered.",
      "la": "ອີເມວນີ້ໄດ້ລົງທະບຽນແລ້ວ",
    },
    {
      "key": "This mobile has register already...!",
      "en": "Mobile number already registered.",
      "la": "ເບີໂທນີ້ໄດ້ລົງທະບຽນແລ້ວ",
    },
    {
      "key": "This email already synced another account",
      "en": "This email is already synced with another account.",
      "la": "ອີເມວນີ້ເຊື່ອມຕໍ່ກັບບັນຊີອື່ນແລ້ວ",
    },
    {
      "key": "Sync successfully",
      "en": "Sync Successfully.",
      "la": "ເຊື່ອມຕໍ່ສຳເລັດ",
    },
    {
      "key": "Can not disConnect",
      "en": "Cannot disconnect.",
      "la": "ບໍ່ສາມາດຍົກເລີກການເຊື່ອມຕໍ່ໄດ້",
    },
    {
      "key": "User does not exist",
      "en": "User not found.",
      "la": "ບໍ່ພົບຜູ້ໃຊ້ງານນີ້",
    },
    {
      "key": "disConnected",
      "en": "Successfully disconnected.",
      "la": "ຍົກເລີກການເຊື່ອມຕໍ່ສຳເລັດແລ້ວ.",
    },
    {
      "key": "Changed",
      "en": "Your password has changed.",
      "la": "ປ່ຽນລະຫັດສຳເລັດແລ້ວ.",
    },

    {
      "key": "try_again",
      "en": "Please try again",
      "la": "ກະລຸນາລອງໃໝ່ອີກຄັ້ງ",
    },
    {
      "key": "are_u_delete_cv",
      "en": "Curriculum vitaes (CVs) have been entirely deleted.",
      "la": "CV ຂອງທ່ານຈະຖືກລົບອອກຈາກລະບົບ.",
    },

    //
    //
    //
    {
      "key": "catch_duck_success",
      "en": "Catch Duck done.",
      "la": "ທ່ານໄດ້ຮັບ 1 ຄະແນນ",
    },
    {
      "key": "catch_duck_already",
      "en": "You have already done this task.",
      "la": "ພາລະກິດນີ້ທ່ານໄດ້ເຮັດແລ້ວ",
    },
    {
      "key": "level_does_not_match",
      "en":
          "Your membership level does not match. At least a Basic Job Seeker is required.",
      "la":
          "ທ່ານຕ້ອງມີລະດັບສະມາຊິກເປັນ Basic Job Seeker ຫຼື Expoert Job Seeker ຈຶ່ງສາມາດຮ່ວມກິດຈະກຳໄດ້.",
    },
    {
      "key": "button_update_profile",
      "en": "Update Profile",
      "la": "ອັບເດດໂປຮໄຟສ",
    },
    {
      "key": "click_mee_get_it",
      "en": "Click me and get it now",
      "la": "ກົດຂ້ອຍແລ້ວຮັບເງິນໄປເລີຍ",
    },
  ];
  @override
  Map<String, Map<String, String>> get keys {
    Map<String, Map<String, String>> localizedStrings = {
      'en_US': {},
      'lo_LA': {},
    };

    for (var item in lang) {
      localizedStrings['en_US']![item['key']!] = item['en']!;
      localizedStrings['lo_LA']![item['key']!] = item['la']!;
    }

    return localizedStrings;
  }

  // @override
  // Map<String, Map<String, String>> get keys => {
  //       'en_US': {
  //         "language": "Eng",
  //         "waiting": "Please wait...",
  //         "createAccount": "Create an Account",
  //         "alreadyHaveAccount": "I already have an account"
  //       },
  //       'lo_LA': {
  //         "language": "Lao",
  //         "waiting": "ກະລຸນາລໍຖ້າ...",
  //         "createAccount": "ສ້າງບັນຊີ",
  //         "alreadyHaveAccount": "ຂ້ອຍມີບັນຊີແລ້ວ"
  //       }
  //     };
}
