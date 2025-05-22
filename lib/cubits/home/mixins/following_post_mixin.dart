import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/user_info_model.dart';
import '../../../data/data_sources/remote/firebase/feed/following_post_service.dart';
import '../../../locator.dart';

mixin FollowingPostMixin {
  final FollowingPostService _followingService = locator<FollowingPostService>();

  late final BehaviorSubject<List<UserInfoModel>?> _followedUsersSubject = BehaviorSubject<List<UserInfoModel>?>();

  ValueStream<List<UserInfoModel>?> get followedUsersStream => _followedUsersSubject.stream;

  bool _isLoading = false;

  Future<void> getFollowedUsers({bool isRefresh = false}) async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      
      if (isRefresh) {
        _followingService.resetCache();
      }
      
      final users = await _followingService.getFollowedUsers();
      
      if (isRefresh) {
        // Clear previous data on refresh
        _followedUsersSubject.add(users);
      } else {
        // Add to existing data
        final currentList = _followedUsersSubject.valueOrNull ?? [];
        final updatedList = [...currentList];
        
        // Only add users not already in the list to avoid duplicates
        for (final user in users ?? []) {
          if (!updatedList.any((u) => u.userId == user.userId)) {
            updatedList.add(user);
          }
        }
        
        _followedUsersSubject.add(updatedList);
      }
    } catch (e) {
      _followedUsersSubject.addError('Error getting followed users');
    } finally {
      _isLoading = false;
    }
  }

  void followingUsersClose() {
    _followedUsersSubject.close();
  }
} 