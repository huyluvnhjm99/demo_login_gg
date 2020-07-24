class ApiUrl {
  static final String BASE_URL = "https://pto.azurewebsites.net/api/v1/";
  static final String SORT = "?isSort=";

  static final String PERSONALITYTEST_URL = BASE_URL + "personality-test";

  static final String USER_URL = BASE_URL + "users";
  static final String USER_FINDBYGMAIL_URL = USER_URL + "/gmail?gmail=";

  static final String QUESTION_URL = BASE_URL + "questions";
  static final String QUESTION_FINDBYTESTID_URL = QUESTION_URL + "/test-id/";

  static final String ANSWER_URL = BASE_URL + "answers";
  static final String ANSWER_FINDBYQUESTIONID_URL = ANSWER_URL + "/question-id/";

  static final String PERSONALITY_URL = BASE_URL + "personalities";
  static final String PERSONALITY_FINDBYID_URL = PERSONALITY_URL + "/";

  static final String TESTRESULT_URL = BASE_URL + "test-result";
  static final String TESTRESULT_FINDBYGMAIL_URL = TESTRESULT_URL + "/gmail?gmail=";

  static final String TOKEN_URL = BASE_URL + "token";
}