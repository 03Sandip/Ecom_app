import 'package:admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utility/constants.dart';

class DashBoardHeader extends StatelessWidget {
  const DashBoardHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Dashboard",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Spacer(flex: 1),
        Expanded(child: SearchField(
          onChange: (val) {
            context.dataProvider.filterProducts(val); // call filterProducts
          },
        )),
        ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: const Color.fromARGB(26, 156, 160, 228)),
      ),
      child: PopupMenuButton<String>(
        tooltip: '', // Removed "Show menu"
        offset: const Offset(0, 50),
        onSelected: (value) {
          if (value == 'logout') {
            // TODO: Handle logout
          } else if (value == 'switch') {
            // TODO: Handle switch account
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'logout', child: Text('Logout')),
          const PopupMenuItem(value: 'switch', child: Text('Switch Account')),
        ],
        child: Row(
          children: [
            Image.asset(
              "assets/images/profile_pic.png",
              height: 38,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Sandip Paul"),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function(String) onChange;

  const SearchField({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
