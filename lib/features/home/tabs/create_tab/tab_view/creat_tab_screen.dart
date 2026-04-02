import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/create_tab/widgets/widgets.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/constances.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CreateTabScreen extends StatefulWidget {
  const CreateTabScreen({super.key});

  @override
  State<CreateTabScreen> createState() => _CreateTabScreenState();
}

class _CreateTabScreenState extends State<CreateTabScreen> {
  //controllers
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedUniversity;
  String? _selectedEventType;

  void _resetForm() {
    //снимает фокус с тикущего поля ввода
    FocusScope.of(context).unfocus();

    Talker().debug("""{ title = ${_adTitleController.text} 
    , desc = ${_descriptionController.text}
    , university = ${_selectedUniversity}
    , event = ${_selectedEventType} }""");

    setState(() {
      _adTitleController.clear();
      _descriptionController.clear();
      _selectedUniversity = null;
      _selectedEventType = null;
    });
  }

  @override
  void dispose() {
    _adTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Убираем дефолтные отступы, чтобы градиент был у самого края
      padding: EdgeInsets.zero,
      //physics: const BouncingScrollPhysics(), // Приятная анимация скролла
      children: [
        //header
        Header(),

        SizedBox(height: 32),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomTextField(
                title: "Ad title",
                hint:
                    "For example: Looking for a Frontend Developer for a Hackathon",
                controller: _adTitleController,
                // prefixIcon: Icons.abc,
              ),
              CustomTextField(
                title: "Description",
                hint:
                    "For example: Looking for a Frontend Developer for a Hackathon",
                controller: _descriptionController,
                // prefixIcon: Icons.abc,
                maxLength: 500,
                maxLines: 5,
              ),

              CustomDropDownMenu(
                title: "University",
                value: _selectedUniversity,
                onChanged: (value) {
                  setState(() {
                    _selectedUniversity = value;
                  });
                },
                dropDownMenuEntries: UNIVERSITIES_DROP_DOWN_MENU_ENTRIES,
              ),

              CustomDropDownMenu(
                title: "Event Type",
                value: _selectedEventType,
                onChanged: (value) {
                  setState(() {
                    _selectedEventType = value;
                  });
                },
                dropDownMenuEntries: EVENTS_DROP_DOWN_MENU_ENTRIES,
              ),

              SizedBox(height: 40),
              PrimaryButton(
                text: "Create Annocountment",
                icon: Icons.star_border,
                onPressed: _resetForm,
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ],
    );
  }
}
