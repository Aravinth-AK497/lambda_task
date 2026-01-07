import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers(int page);
  Future<UserModel> createUser(String name, String job);
  Future<UserModel> updateUser(int id, String name, String job);
  Future<void> deleteUser(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers(int page) async {
    try {
      final response = await dio.get('https://reqres.in/api/users?page=$page');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Failed to load users');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> createUser(String name, String job) async {
    try {
      final response = await dio.post(
        'https://reqres.in/api/users',
        data: {'name': name, 'job': job},
      );

      if (response.statusCode == 201) {
        // ReqRes returns created object but sometimes incomplete for strict model parsing if we reused UserModel. 
        // Ideally we map it back. For this dummy API, let's assuming it returns mostly what we need or correct fields.
        // NOTE: ReqRes create response might NOT have all fields like 'avatar' or 'email'. 
        // We might need a separate CreateUserResponse or be lenient.
        // For simplicity, we will mock the return or handle partial data if needed.
        // However, the requirement asks to return the User. 
        // Let's manually construct a UserModel with placeholder data if API doesn't return everything, 
        // or strictly follow API response.
        // ReqRes response: { "name": "morpheus", "job": "leader", "id": "794", "createdAt": "202..." }
        // It DOES NOT return email/avatar. 
        // So we cannot really return a full UserModel from Create/Update in this specific API scenario seamlessly without fake data.
        
        return UserModel(
          id: int.parse(response.data['id'].toString()),
          email: 'newuser@example.com', // Dummy data as API doesn't return it
          firstName: name,
          lastName: '',
          avatar: 'https://reqres.in/img/faces/1-image.jpg', // Dummy avatar
        );
      } else {
        throw const ServerFailure('Failed to create user');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(int id, String name, String job) async {
    try {
      final response = await dio.put(
        'https://reqres.in/api/users/$id',
        data: {'name': name, 'job': job},
      );

      if (response.statusCode == 200) {
         return UserModel(
          id: id,
          email: 'updated@example.com',
          firstName: name,
          lastName: '',
          avatar: 'https://reqres.in/img/faces/1-image.jpg',
        );
      } else {
        throw const ServerFailure('Failed to update user');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      final response = await dio.delete('https://reqres.in/api/users/$id');
      
      if (response.statusCode != 204) {
         throw const ServerFailure('Failed to delete user');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
