import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedTitle = "Mr.";
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController billingAddressController =
      TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String SelectButton = "Mr.";

  final dateController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    print("psicked date$picked");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat("dd-MM-yyyy").format(selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 15.sp),
        ),
        backgroundColor: Color(0xFFF5F5F5),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.0.w), // Adjust as needed
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/Arrow_back.png",
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                "Personal details",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                MaritalStatus1(
                  label: "Mr.",
                  isSelected: SelectButton == "Mr.",
                  onTap: () {
                    setState(() {
                      SelectButton = "Mr.";
                    });
                  },
                ),
                SizedBox(width: 4.w),
                MaritalStatus1(
                  label: "Mrs.",
                  isSelected: SelectButton == "Mrs.",
                  onTap: () {
                    setState(() {
                      SelectButton = "Mrs.";
                    });
                  },
                ),
                SizedBox(width: 4.w),
                MaritalStatus1(
                  label: "Ms.",
                  isSelected: SelectButton == "Ms.",
                  onTap: () {
                    setState(() {
                      SelectButton = "Ms.";
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildTextField1(label: 'First name *', hintText: 'Text here'),
            _buildTextField1(label: 'Last name *', hintText: 'Text here'),
            _buildTextField1(
                label: 'Date of birth *',
                hintText: 'Text here',
                controller: dateController),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                'Contact details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            _buildTextField1(label: 'Mobile *', hintText: 'Text here'),
            _buildTextField1(label: 'Email *', hintText: 'Text here'),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                'Billing Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            _buildTextField1(label: 'Billing Address ', hintText: 'Text here'),
            _buildTextField1(label: 'Pincode', hintText: 'Text here'),
            _buildTextField1(label: 'State', hintText: 'Text here'),
            // SizedBox(height: 10.h),
            // Text(
            //   "Contact details",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: mobileController,
            //   decoration: InputDecoration(labelText: "Mobile"),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: emailController,
            //   decoration: InputDecoration(labelText: "Email"),
            // ),
            // SizedBox(height: 20),
            //
            // // Billing Details
            // Text(
            //   "Billing Details",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: billingAddressController,
            //   decoration: InputDecoration(labelText: "Billing Address"),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: pincodeController,
            //   decoration: InputDecoration(labelText: "Pincode"),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: stateController,
            //   decoration: InputDecoration(labelText: "State"),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: cityController,
            //   decoration: InputDecoration(labelText: "City"),
            // ),
            // SizedBox(height: 10),
            // TextField(
            //   controller: countryController,
            //   decoration: InputDecoration(labelText: "Country"),
            // ),
            // SizedBox(height: 30),

            // // Save Button
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       print("Saving details...");
            //       print("Title: $selectedTitle");
            //       print("First Name: ${firstNameController.text}");
            //       print("Last Name: ${lastNameController.text}");
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.orange,
            //       padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     child: Text(
            //       "Save details",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 10.w, bottom: 15.h, right: 10.w),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 40.h),
            backgroundColor: Color(0xFFF37023),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text("Save Details"),
        ),
      ),
    );
  }

  Widget _buildTextField1(
      {required String label,
      required String hintText,
      TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: label == "Date of birth *"
                  ? GestureDetector(
                      onTap: () {
                        _selectedDate(context);
                      },
                      child: Icon(
                        Icons.date_range,
                        color: Colors.grey.shade800,
                      ),
                    )
                  : label == "Expiry Date*"
                      ? GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.date_range,
                            color: Colors.grey.shade800,
                          ),
                        )
                      : const SizedBox.shrink(),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700)),
              fillColor: Colors.white,
              filled: true,
              label: Text(label),
              focusColor: Colors.orange,
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class MaritalStatus1 extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MaritalStatus1({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 8.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFFFE7DA) : Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isSelected ? Colors.orange : Color(0xFFE6E6E6),
              width: 1.w,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xFFF37023) : Color(0xFF1C1E1D),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
