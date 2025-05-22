import 'package:flutter/material.dart';
import 'package:haiku/data/data_sources/remote/firebase/user/follow_service.dart';
import 'package:haiku/utilities/constants/app_colors.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/auth_utils.dart';

class FollowButton extends StatefulWidget {
  final String targetUserId;
  final bool initialFollowState;
  final Function(bool)? onFollowStateChanged;

  const FollowButton({
    Key? key,
    required this.targetUserId,
    this.initialFollowState = false,
    this.onFollowStateChanged,
  }) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  late bool _isFollowing;
  final _followService = FollowService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.initialFollowState;
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFollowing) {
        await _followService.unfollowUser(widget.targetUserId);
      } else {
        await _followService.followUser(widget.targetUserId);
      }

      setState(() {
        _isFollowing = !_isFollowing;
      });

      widget.onFollowStateChanged?.call(_isFollowing);
    } catch (e) {
      print('Error toggling follow state: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show follow button if user is viewing their own profile
    if (widget.targetUserId == AuthUtils().currentUserId) {
      return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: _isLoading ? null : _toggleFollow,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFollowing ? AppColors.grey : AppColors.purple,
        foregroundColor: _isFollowing ? AppColors.black : AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              ),
            )
          : Text(
              _isFollowing ? AppTexts.following : AppTexts.follow,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
} 