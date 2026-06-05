import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/farequote.dart' as farequote;
import '../models/search_data.dart';
import '../utils/api_service.dart';
import 'TravelerDetails.dart';

class MultiAddTravelerPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  final String city;
  final String destination;
  final String airlineName;
  final String cityName;
  final String cityCode;
  final String? flightNumber;
  final String? depDate;
  final String? depTime;
  final String? refundable;
  final String? arrDate;
  final String? arrTime;
  final String? descityName;
  final String? descityCode;
  final String? airlineCode;
  final String? stop;
  final String? duration;
  final String? airportName;
  final String? desairportName;
  final double? basefare;
  final double? tax;
  final List<List<Segment>>? segments;
  final List<Map<String, dynamic>> selectedpassengers;
  final String? travelerType;
  final String? traceid;
  final String? resultindex;
  final bool isPassportRequiredAtTicket;
  final bool isPassportFullDetailRequiredAtBook;
  final int? adultCount;
  final int? childCount;
  final int? infantCount;
  final num? coupouncode;
  final List<Map<String, dynamic>>? segmentsJson;
  final bool? isLLC;
  final String? commonPublishedFare;
  final int? coupon;
  final String? tboOfferedFare;
  final double? tboCommission;
  final double? tboTds;
  final double? trvlusCommission;
  final double? trvlusTds;
  final int? trvlusNetFare;
  final String? outresultindex;
  final String? inresultindex;
  final Map<String, dynamic> outBoundData;
  final Map<String, dynamic> inBoundData;
  final Result? outboundFlight;
  final Result? inboundFlight;

  MultiAddTravelerPage({
    required this.flight,
    required this.city,
    required this.destination,
    required this.airlineName,
    required this.cityName,
    required this.cityCode,
    this.airlineCode,
    this.airportName,
    this.desairportName,
    this.flightNumber,
    this.depDate,
    this.depTime,
    this.refundable,
    this.arrDate,
    this.arrTime,
    this.descityName,
    this.descityCode,
    this.stop,
    this.isLLC,
    this.duration,
    this.basefare,
    this.tax,
    this.segments,
    required this.selectedpassengers,
    this.travelerType,
    this.adultCount,
    this.traceid,
    this.resultindex,
    this.coupouncode,
    this.segmentsJson,
    this.childCount,
    this.infantCount,
    this.commonPublishedFare,
    this.coupon,
    this.tboOfferedFare,
    this.tboCommission,
    this.tboTds,
    this.trvlusCommission,
    this.trvlusTds,
    this.trvlusNetFare,
    this.outresultindex,
    this.inresultindex,
    required this.outBoundData,
    required this.inBoundData,
    this.outboundFlight,
    this.inboundFlight,
    required this.isPassportRequiredAtTicket,
    required this.isPassportFullDetailRequiredAtBook,
  });

  @override
  _MultiAddTravelerPageState createState() => _MultiAddTravelerPageState();
}

class _MultiAddTravelerPageState extends State<MultiAddTravelerPage> {
  List<bool> _isExpanded = [];
  List<GlobalKey<_SingleTravelerFormState>> _formKeys = [];

  @override
  void initState() {
    super.initState();
    _isExpanded =
        List.generate(widget.selectedpassengers.length, (index) => false);
    _formKeys = List.generate(widget.selectedpassengers.length,
        (index) => GlobalKey<_SingleTravelerFormState>());
  }

  @override
  Widget build(BuildContext context) {
    // Build type labels: Adult 1, Adult 2, Child 1, Infant 1, etc.
    Map<String, int> typeCounters = {};
    List<String> typeLabels = [];

    for (var p in widget.selectedpassengers) {
      String type = p['typeLable']?.toString() ?? 'Traveler';
      typeCounters[type] = (typeCounters[type] ?? 0) + 1;
      typeLabels.add('$type ${typeCounters[type]}');
    }

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Selected Travelers Details',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        foregroundColor: Colors.black,
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: () {
            Map<String, int> typeCounters = {};
            List<Widget> widgets = [];
            String? lastType;

            for (int index = 0;
                index < widget.selectedpassengers.length;
                index++) {
              var p = widget.selectedpassengers[index];
              String type = p['typeLable']?.toString() ?? 'Traveler';
              typeCounters[type] = (typeCounters[type] ?? 0) + 1;
              String typeLabel = '$type ${typeCounters[type]}';

              // Add section header + gap when type changes
              if (lastType != type) {
                if (lastType != null) {
                  widgets.add(SizedBox(height: 20.h)); // gap between groups
                }
                widgets.add(
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Color(0xFFF37023),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      type == 'Adult'
                          ? '👤 Adult Passengers'
                          : type == 'Child'
                              ? '🧒 Child Passengers'
                              : '👶 Infant Passengers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
                widgets.add(SizedBox(height: 10.h));
                lastType = type;
              }

              // Expansion panel replaced with Card + ExpansionTile
              widgets.add(
                Card(
                  margin: EdgeInsets.only(bottom: 10.h),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                    title: Text(
                      typeLabel, // Adult 1, Child 1, Infant 1...
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                    subtitle: Text(
                      '${p['Firstname'] ?? ''} ${p['lastname'] ?? ''}'
                              .trim()
                              .isEmpty
                          ? 'No name entered'
                          : '${p['Firstname'] ?? ''} ${p['lastname'] ?? ''}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    iconColor: Color(0xFFF37023),
                    collapsedIconColor: Colors.grey,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: SingleTravelerForm(
                          key: _formKeys[index],
                          passenger: p,
                          travelerType:
                              p['typeLable']?.toString().toLowerCase(),
                          isPassportRequiredAtTicket:
                              widget.isPassportRequiredAtTicket,
                          isPassportFullDetailRequiredAtBook:
                              widget.isPassportFullDetailRequiredAtBook,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return widgets;
          }(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            onPressed: () async {
              List<Map<String, dynamic>> allData = [];
              bool allValid = true;
              for (int i = 0; i < _formKeys.length; i++) {
                if (_formKeys[i].currentState == null) {
                  // Form not expanded — use pre-filled passenger data directly
                  allData.add(widget.selectedpassengers[i]);
                } else if (!_formKeys[i].currentState!.validateForm()) {
                  allValid = false;
                } else {
                  allData.add(_formKeys[i].currentState!.getData());
                }
              }
              if (!allValid) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fix the errors in the form')));
                return;
              }

              for (var data in allData) {
                final passengerId = data['id'];
                if (passengerId != null) {
                  String convertDate(String input) {
                    try {
                      final parsed = DateFormat("dd-MM-yyyy").parse(input);
                      return DateFormat("yyyy-MM-dd").format(parsed);
                    } catch (_) {
                      return input;
                    }
                  }

                  final updatePayload = {
                    'first_name': data['Firstname'],
                    'last_name': data['lastname'],
                    'mobile': data['mobile'],
                    'email': data['email'],
                    'passport_no': data['Passport No'],
                    'dob': convertDate(data['Date of Birth']),
                    'passport_expiry': data['Expiry'].isNotEmpty
                        ? convertDate(data['Expiry'])
                        : null,
                    'gender': data['gender'],
                    'wheel_chair': data['wheelchair'].toString(),
                    'nationality': data['Nationality'],
                    'issusing_country': data['IssusingCountry'],
                    'title': data['title'],
                  };
                  await ApiService()
                      .updatePassenger(passengerId, updatePayload);
                }
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TravelerDetailsPage(
                            flight: widget.flight,
                            city: widget.city,
                            destination: widget.destination,
                            airlineName: widget.airlineName,
                            cityName: widget.cityName,
                            cityCode: widget.cityCode,
                            airlineCode: widget.airlineCode,
                            airportName: widget.airportName,
                            desairportName: widget.desairportName,
                            flightNumber: widget.flightNumber,
                            depDate: widget.depDate,
                            depTime: widget.depTime,
                            refundable: widget.refundable,
                            arrDate: widget.arrDate,
                            arrTime: widget.arrTime,
                            descityName: widget.descityName,
                            descityCode: widget.descityCode,
                            stop: widget.stop,
                            duration: widget.duration,
                            basefare: widget.basefare,
                            tax: widget.tax,
                            segments: widget.segments,
                            segmentsJson: widget.segmentsJson,
                            traceid: widget.traceid,
                            resultindex: widget.resultindex,
                            adultCount: widget.adultCount,
                            childCount: widget.childCount,
                            infantCount: widget.infantCount,
                            coupouncode: widget.coupouncode,
                            isLLC: widget.isLLC,
                            commonPublishedFare: widget.commonPublishedFare,
                            tboOfferedFare: widget.tboOfferedFare,
                            tboCommission: widget.tboCommission,
                            tboTds: widget.tboTds,
                            trvlusCommission: widget.trvlusCommission,
                            trvlusTds: widget.trvlusTds,
                            trvlusNetFare: widget.trvlusNetFare,
                            outresultindex: widget.outresultindex,
                            inresultindex: widget.inresultindex,
                            outBoundData: widget.outBoundData,
                            inBoundData: widget.inBoundData,
                            outboundFlight: widget.outboundFlight,
                            inboundFlight: widget.inboundFlight,
                            selectedpassengers: allData,
                          )));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF37023),
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r)),
            ),
            child: Text("SAVE & CONTINUE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class SingleTravelerForm extends StatefulWidget {
  final Map<String, dynamic> passenger;
  final String? travelerType;
  final bool isPassportRequiredAtTicket;
  final bool isPassportFullDetailRequiredAtBook;

  SingleTravelerForm({
    Key? key,
    required this.passenger,
    this.travelerType,
    required this.isPassportRequiredAtTicket,
    required this.isPassportFullDetailRequiredAtBook,
  }) : super(key: key);

  @override
  _SingleTravelerFormState createState() => _SingleTravelerFormState();
}

class _SingleTravelerFormState extends State<SingleTravelerForm> {
  String selectedGender = "Mr";
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final passportNoController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final expiryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool requireWheelchair = false;
  bool _submitted = false;

  List<String> nationality = <String>['Indian', 'Saudi', 'Malayasian'];
  String selectedNationality = 'Indian';

  String selectedCountry = 'India';
  List<String> IssusingCountry = <String>['India', 'Saudi', 'Malaysian', 'USA'];
  DateTime? selectedDate;

  late List<String> genderOptions;

  final dateFocusNode = FocusNode();
  final expiryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadMobile();

    selectedGender = widget.passenger['gender'] ?? 'Mr';
    firstNameController.text = widget.passenger['Firstname'] ?? '';
    lastNameController.text = widget.passenger['lastname'] ?? '';
    passportNoController.text = widget.passenger['Passport No'] ?? '';
    mobileController.text = widget.passenger['mobile'] ?? '';
    dateController.text = widget.passenger['Date of Birth'] ?? '';
    expiryController.text = widget.passenger['Expiry'] ?? '';
    emailController.text = widget.passenger['email'] ?? '';

    if (widget.travelerType == 'child' || widget.travelerType == 'infant') {
      genderOptions = ['Mstr', 'Ms'];
    } else {
      genderOptions = ['Mr', 'Mrs', 'Ms'];
    }
  }

  void loadMobile() async {
    final prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString("mobile");
    if (mobile != null && mobile.isNotEmpty && mobileController.text.isEmpty) {
      mobileController.text = mobile;
    }
  }

  Future<void> _selectDate(BuildContext context, String travelerType) async {
    dateFocusNode.requestFocus();

    final now = DateTime.now();

    DateTime firstDate;
    DateTime lastDate;
    DateTime initialDate;

    if (travelerType == "adult") {
      firstDate = DateTime(1900);
      lastDate = DateTime(now.year - 12, 12, 31);
      initialDate = lastDate;
    } else if (travelerType == "child") {
      firstDate = DateTime(now.year - 12, 1, 1);
      lastDate = DateTime(now.year - 2, 12, 31);
      initialDate = DateTime(now.year - 6, now.month, now.day);
    } else if (travelerType == "infant") {
      firstDate = DateTime(now.year - 2, 1, 1);
      lastDate = DateTime(now.year, 12, 31);
      initialDate = DateTime(now.year - 1, now.month, now.day);
    } else {
      firstDate = DateTime(1900);
      lastDate = now;
      initialDate = now;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
    dateFocusNode.unfocus();
  }

  Future<void> _expiryDate(BuildContext context) async {
    expiryFocusNode.requestFocus();
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: now,
      lastDate: DateTime(2225),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        expiryController.text = DateFormat("dd-MM-yyyy").format(selectedDate!);
      });
    }
    expiryFocusNode.unfocus();
  }

  bool validateForm() {
    setState(() {
      _submitted = true;
    });
    return _formKey.currentState!.validate();
  }

  Map<String, dynamic> getData() {
    String typeLabel = '';
    if (widget.travelerType == 'adult') {
      typeLabel = 'Adult';
    } else if (widget.travelerType == 'child') {
      typeLabel = 'Child';
    } else if (widget.travelerType == 'infant') {
      typeLabel = 'Infant';
    } else {
      typeLabel = 'Traveler';
    }

    String genderValue;
    if (widget.travelerType == 'adult') {
      genderValue = selectedGender == "Mr" ? "Male" : "Female";
    } else {
      genderValue = selectedGender == "Mstr" ? "Male" : "Female";
    }

    return {
      'id': widget.passenger['id'],
      'gender': selectedGender,
      'Firstname': firstNameController.text.trim(),
      'lastname': lastNameController.text.trim(),
      'mobile': mobileController.text.trim(),
      'email': emailController.text.trim(),
      'Passport No': passportNoController.text.trim(),
      'Date of Birth': dateController.text.trim(),
      'Expiry': expiryController.text.trim(),
      'wheelchair': requireWheelchair,
      'Nationality': selectedNationality,
      'IssusingCountry': selectedCountry,
      'typeLable': typeLabel,
      'title': genderValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: _formKey,
      autovalidateMode: _submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          // SizedBox(height: 10.h),
          Row(
            children: genderOptions
                .map((gender) => Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: GenderStatus(
                        label: gender,
                        isSelected: selectedGender == gender,
                        onTap: () {
                          setState(() {
                            selectedGender = gender;
                          });
                        },
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 10.h),
          _buildTextField(
            label: 'First Name(Givenname)',
            hintText: 'Text here',
            controller: firstNameController,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            forceUpperCase: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'First Name is required';
              }
              if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$').hasMatch(value.trim())) {
                return 'Only letters and spaces are allowed';
              }
              return null;
            },
          ),
          _buildTextField(
            label: 'Last Name(Surname)',
            hintText: 'Text here',
            controller: lastNameController,
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            forceUpperCase: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Last Name is required';
              }
              return null;
            },
          ),
          _buildTextField(
            label: 'Date of Birth *',
            hintText: 'Select date',
            controller: dateController,
            readOnly: true,
            focusNode: dateFocusNode,
            onTap: () => _selectDate(context, widget.travelerType ?? ""),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Date of Birth is required';
              }
              return null;
            },
          ),
          if (widget.isPassportFullDetailRequiredAtBook == true) ...[
            _buildTextField(
              label: 'Passport No',
              hintText: '',
              controller: passportNoController,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              forceUpperCase: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Passport No is required';
                }
                return null;
              },
            ),
            _buildTextField(
              label: 'Expiry Date*',
              hintText: '',
              controller: expiryController,
              readOnly: true,
              focusNode: expiryFocusNode,
              onTap: () => _expiryDate(context),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Expiry Date is required';
                }
                return null;
              },
            ),
          ] else if (widget.isPassportRequiredAtTicket == true) ...[
            _buildTextField(
              label: 'Passport No',
              hintText: '',
              controller: passportNoController,
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              forceUpperCase: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Passport No is required';
                }
                return null;
              },
            ),
            _buildTextField(
              label: 'Expiry Date*',
              hintText: '',
              controller: expiryController,
              readOnly: true,
              focusNode: expiryFocusNode,
              onTap: () => _expiryDate(context),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Expiry Date is required';
                }
                return null;
              },
            ),
          ],
          Text(
            "Contact details",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          _buildTextField(
            label: 'Mobile Number',
            hintText: '',
            controller: mobileController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mobile Number is required';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Only numbers are allowed';
              }
              if (value.length != 10) {
                return 'Mobile number must be 10 digits';
              }
              return null;
            },
          ),
          _buildTextField(
            label: 'Email',
            hintText: '',
            controller: emailController,
            forceUpperCase: false,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value.trim())) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          CheckboxListTile(
            value: requireWheelchair,
            onChanged: (v) => setState(() => requireWheelchair = v!),
            title: Text('I require wheelchair (Optional)'),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Color(0xFFF37023),
          ),
        ],
      ),
    ));
  }

  _buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    bool readOnly = false,
    Function()? onTap,
    FocusNode? focusNode, // 👈 Add this parameter
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool forceUpperCase = false, // 👈 ADD THIS
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        focusNode: focusNode,
        // 👈 Pass it here
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: forceUpperCase
            ? TextCapitalization.characters
            : TextCapitalization.none,
        validator: validator,
        decoration: InputDecoration(
          suffixIcon: (label == "Date of Birth *" || label == "Expiry Date*")
              ? InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.date_range, color: Colors.grey.shade800),
                  ),
                )
              : null,
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700)),
          filled: true,
          fillColor: Colors.white,
          label: Text(label),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black, fontSize: 14.sp),
        ),
        style: TextStyle(fontSize: 16.sp, color: Colors.black),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue,
      List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class GenderStatus extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderStatus({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF37023) : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? Color(0xFFF37023) : Color(0xFFE6E6E6),
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
              color: isSelected ? Colors.white : Color(0xFF1C1E1D),
            ),
          ),
        ),
      ),
    );
  }
}

bool isInternationalFromFareQuote(farequote.FareQuotesData fareQuote) {
  final segments = fareQuote.response.results.segments;

  for (var trip in segments) {
    for (var segment in trip) {
      final originCountry = segment.origin.airport.countryCode;
      print("originCountryoriginCountry$originCountry");
      final destinationCountry = segment.destination.airport.countryCode;
      print("destinationCountrydestinationCountry$destinationCountry");

      if (originCountry != 'IN' || destinationCountry != 'IN') {
        return true;
      }
    }
  }
  return false;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
