import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const KPrimayColor = Color(0xff0041c0);
const String usersCollection = 'UsersAndTheirDevices';
const String allProductsCollection = 'AllProducts';
const String ocs = 'Office Communication Systems';
const Set<String> allCategories = {
  'Air Conditioning',
  'Automation Control Components',
  'Blu-ray Disc',
  'Broadcast & Professional Video',
  'Business Communication Systems',
  'Business Fax',
  'Capacitors',
  'Document Scanner',
  'Electronic Materials',
  'Electronic Whiteboard',
  'FA Sensors & Components',
  'Factory Automation, Welding Machines',
  'HD Visual Communications System',
  'Housing Equipment Devices',
  'Inductors (Coils)',
  'Industrial Batteries',
  'IP Phone',
  'Lighting',
  'Media Entertainment',
  'Mobile PC / Tablet',
  'Motors, Compressors',
  'Multi-Function Laser',
  'Optical Disc Archive Solution',
  'Photovoltaic',
  'POS Workstation',
  'Professional Displays',
  'Projector',
  'Resistors',
  'SD Memory Card',
  'Security',
  'Semiconductors',
  'Sensors',
  'Silky Fine Mist Systems',
  'Thermal Management Solutions',
  'Ventilating Fan',
  'Visual Sort Assist',
};

const Set<String> allCompatibleDevices = {
  'KX-TEA308',
  'KX-TES824',
  'KX-TEM824',
  'KX-TDA30',
  'KX-TDA100',
  'KX-TDA100D',
  'KX-TDA200',
  'KX-TDA600',
  'KX-TDA620',
  'KX-NCP500',
  'KX-NCP1000',
  'KX-TDE100',
  'KX-TDE200',
  'KX-TDE600',
  'KX-TDE620',
  'KX-NS500',
  'KX-NS1000',
};

double widthOfCustoms(BuildContext context) => MediaQuery.of(context).size.width - KPadding * 2;
const double KPadding = 15;
BorderRadius KRadius = BorderRadius.circular(10);
const double heightOfCustoms = 55;
