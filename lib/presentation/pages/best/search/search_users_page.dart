import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haiku/data/data_sources/remote/firebase/auth/register/username_service.dart';
import 'package:haiku/utilities/helpers/go.dart';

import '../../../../data/models/user_info_model.dart';
import '../../../../utilities/constants/app_texts.dart';
import '../../../../utilities/helpers/input_debouncer.dart';
import '../../../widgets/global/global_divider.dart';
import '../widgets/best_user_list_item.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  State<SearchUsersPage> createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot<Object?>> _searchStream;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _searchStream = const Stream.empty();

    // Listen for text changes to update the search stream
    _searchController.addListener(() {
      final searchText = _searchController.text.trim();
      _debouncer.run(() {
        setState(() {
          _searchStream = UsernameService.searchUserName(searchText);
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 56, left: 20, right: 20),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppTexts.searchUsername,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    // Loop icon at the start
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {}); // Update UI to remove "Close"
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(Icons.close, color: Colors.grey),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Go.back(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 56, right: 20),
                child: Text(
                  AppTexts.cancel,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Object?>>(
              stream: _searchStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text(AppTexts.noUsersFound));
                }

                final usersList = snapshot.data!.docs
                    .map((doc) => UserInfoModel.fromDocumentSnapshot(doc))
                    .toList();

                return ListView.separated(
                  itemCount: usersList.length,
                  separatorBuilder: (context, index) =>
                      const GlobalDivider.horizontal(left: 70),
                  itemBuilder: (context, index) {
                    final user = usersList[index];
                    return BestUserListItem(userInfo: user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
