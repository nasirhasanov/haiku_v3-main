import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/contracts/post_contract.dart';
import '../../../data/models/user_info_model.dart';
import '../../../data/data_sources/remote/firebase/feed/following_post_service.dart';
import '../../../locator.dart';
import '../../../utilities/extensions/scroll_controller_extensions.dart';

mixin FollowingPostMixin {
  final FollowingPostService _followingService = locator<FollowingPostService>();

  late final ScrollController followedUsersScrollController = ScrollController();
  
  late final BehaviorSubject<List<UserInfoModel>> _followedUsersSubject = BehaviorSubject<List<UserInfoModel>>.seeded([]);

  ValueStream<List<UserInfoModel>> get followedUsersStream => _followedUsersSubject.stream;

  bool _isLoading = false;
  bool _hasMoreUsers = true;
  
  void listenToFollowedUsersScroll() {
    followedUsersScrollController.addListener(_loadMoreFollowedUsers);
  }
  
  void _loadMoreFollowedUsers() {
    if (followedUsersScrollController.isLastItem && !_isLoading && _hasMoreUsers) {
      getFollowedUsers();
    }
  }

  Future<void> getFollowedUsers({bool isRefresh = false}) async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      
      final users = await _followingService.getFollowedUsers(isRefresh: isRefresh);
      
      if (isRefresh) {
        // Clear previous data on refresh
        _followedUsersSubject.add(users ?? []);
        _hasMoreUsers = users?.isNotEmpty ?? false;
      } else {
        // Add to existing data
        final currentList = _followedUsersSubject.value;
        
        if (users == null || users.isEmpty) {
          _hasMoreUsers = false;
        } else {
          final updatedList = [...currentList];
          
          // Only add users not already in the list to avoid duplicates
          for (final user in users) {
            if (!updatedList.any((u) => u.userId == user.userId)) {
              updatedList.add(user);
            }
          }
          
          _followedUsersSubject.add(updatedList);
        }
      }
    } catch (e) {
      _followedUsersSubject.addError('Error getting followed users');
    } finally {
      _isLoading = false;
    }
  }

  void followingUsersClose() {
    followedUsersScrollController.removeListener(_loadMoreFollowedUsers);
    followedUsersScrollController.dispose();
    _followedUsersSubject.close();
  }
} 