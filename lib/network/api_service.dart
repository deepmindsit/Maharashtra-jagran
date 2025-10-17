import 'package:injectable/injectable.dart';
import 'package:maharashtrajagran/network/all_url.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'api_service.g.dart';

@RestApi()
@injectable
abstract class ApiService {
  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  @POST(AllUrl.checkUser)
  Future<dynamic> checkUser(@Part(name: "email_or_phone") String emailOrPhone);

  @POST(AllUrl.verifyOtp)
  Future<dynamic> verifyOtp(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "otp") String otp,
  );

  @POST(AllUrl.register)
  Future<dynamic> register(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "password") String password,
    @Part(name: "confirm_password") String cPassword,
    @Part(name: "verification_token") String token,
  );

  @POST(AllUrl.login)
  Future<dynamic> loginUser(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "password") String password,
  );

  @POST(AllUrl.dashboard)
  @MultiPart()
  Future<dynamic> getDashboard(
    @Part(name: "session_token") String? token,
    @Part(name: "user_id") String? userId,
    @Part(name: "preferred_categories[]") List<String> prefer,
  );

  @POST(AllUrl.categories)
  Future<dynamic> getCategories();

  @POST(AllUrl.aboutUs)
  Future<dynamic> getAboutUs();

  @POST(AllUrl.newsDetails)
  Future<dynamic> newsDetails(
    @Part(name: "news_id") String newsId,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsByCategory)
  Future<dynamic> newsByCategory(
    @Part(name: "category_id") String categoryId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsByTag)
  Future<dynamic> newsByTag(
    @Part(name: "tag_id") String categoryId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.newsBySearch)
  Future<dynamic> newsBySearch(
    @Part(name: "keyword") String keyword,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "user_id") String? userId,
  );

  @POST(AllUrl.getProfile)
  Future<dynamic> getProfile(@Part(name: "user_id") String? userId);

  @POST(AllUrl.legalPage)
  Future<dynamic> legalPage(@Part(name: "page_slug") String? slug);

  @POST(AllUrl.deleteProfile)
  Future<dynamic> deleteProfile(@Part(name: "user_id") String? userId);

  @POST(AllUrl.getBookmarks)
  Future<dynamic> getBookmarks(
    @Part(name: "user_id") String? userId,
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
    @Part(name: "session_token") String token,
  );

  @POST(AllUrl.addBookmarks)
  Future<dynamic> addBookmarks(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
  );

  @POST(AllUrl.addBookmarks)
  Future<dynamic> removeBookmarks(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
    @Part(name: "action") String action,
  );

  @POST(AllUrl.addComment)
  Future<dynamic> addComment(
    @Part(name: "news_id") String? newsId,
    @Part(name: "session_token") String token,
    @Part(name: "content") String content,
  );

  @POST(AllUrl.editProfile)
  Future<dynamic> editProfile(
    @Part(name: "user_id") String? userId,
    @Part(name: "display_name") String name,
    @Part(name: "email") String email,
    @Part(name: "phone_number") String number,
  );

  @POST(AllUrl.updatePassword)
  Future<dynamic> updatePassword(
    @Part(name: "user_id") String? userId,
    @Part(name: "current_password") String currentPassword,
    @Part(name: "new_password") String newPassword,
    @Part(name: "confirm_password") String confirmPassword,
  );

  @POST(AllUrl.forgetPassword)
  Future<dynamic> forgetPassword(
    @Part(name: "email_or_phone") String emailOrPhone,
  );

  @POST(AllUrl.forgetVerifyOtp)
  Future<dynamic> forgetVerifyOtp(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "otp") String otp,
  );

  @POST(AllUrl.forgetPasswordReset)
  Future<dynamic> forgetPasswordReset(
    @Part(name: "email_or_phone") String emailOrPhone,
    @Part(name: "verification_token") String token,
    @Part(name: "new_password") String password,
  );

  @POST(AllUrl.updateFirebaseToken)
  Future<dynamic> updateFirebaseToken(
    @Part(name: "firebase_token") String token,
  );

  @POST(AllUrl.getNotification)
  Future<dynamic> getNotification(
    @Part(name: "page") String page,
    @Part(name: "per_page") String perPage,
  );

  // @POST(AllUrl.addFileComment)
  // @MultiPart()
  // Future<dynamic> addFileComment(
  //   @Part(name: "user_id") String userId,
  //   @Part(name: "file_id") String fileId,
  //   @Part(name: "status_id") String statusId,
  //   @Part(name: "description") String description, {
  //   @Part(name: 'attachments[]') List<MultipartFile>? attachment,
  // });
}

//
// @GET("/comments")
// @Headers(<String, dynamic>{ //Static header
//   "Content-Type" : "application/json",
//   "Custom-Header" : "Your header"
// })
// Future<List<Comment>> getAllComments();

// @Path- To update the URL dynamically replacement block surrounded by { } must be annotated with @Path using the same string.
// @Body- Sends dart object as the request body.
// @Query- used to append the URL.
// @Headers- to pass the headers dynamically.
