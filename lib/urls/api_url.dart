class ApiUrl {
  static final String BASE_URL = "https://pto.azurewebsites.net/api/v1/";

  static final String PERSONALITYTEST_URL = BASE_URL + "personalitytest";

  static final String USER_URL = BASE_URL + "users";
  static final String USER_FINDBYGMAIL_URL = USER_URL + "/get-by-gmail?gmail=";

  static final String QUESTION_URL = BASE_URL + "questions";
  static final String QUESTION_FINDBYTESTID_URL = QUESTION_URL + "/get-by-testid/";
}